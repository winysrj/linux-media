Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:64894 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752025AbdJDL6h (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Oct 2017 07:58:37 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v3 16/17] scripts: kernel-doc: improve nested logic to handle multiple identifiers
Date: Wed,  4 Oct 2017 08:48:54 -0300
Message-Id: <03fbd714e9c2def6f6a081ca27ca99f794a5bd0c.1507116877.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507116877.git.mchehab@s-opensource.com>
References: <cover.1507116877.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507116877.git.mchehab@s-opensource.com>
References: <cover.1507116877.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is possible to use nested structs like:

struct {
	struct {
		void *arg1;
	} st1, st2, *st3, st4;
};

Handling it requires to split each parameter. Change the logic
to allow such definitions.

In order to test the new nested logic, the following file
was used to test

<code>
struct foo { int a; }; /* Just to avoid errors if compiled */

/**
 * struct my_struct - a struct with nested unions and structs
 * @arg1: first argument of anonymous union/anonymous struct
 * @arg2: second argument of anonymous union/anonymous struct
 * @arg1b: first argument of anonymous union/anonymous struct
 * @arg2b: second argument of anonymous union/anonymous struct
 * @arg3: third argument of anonymous union/anonymous struct
 * @arg4: fourth argument of anonymous union/anonymous struct
 * @bar.st1.arg1: first argument of struct st1 on union bar
 * @bar.st1.arg2: second argument of struct st1 on union bar
 * @bar.st1.bar1: bar1 at st1
 * @bar.st1.bar2: bar2 at st1
 * @bar.st2.arg1: first argument of struct st2 on union bar
 * @bar.st2.arg2: second argument of struct st2 on union bar
 * @bar.st3.arg2: second argument of struct st3 on union bar
 * @f1: nested function on anonimous union/struct
 * @bar.st2.f2: nested function on named union/struct
 */
struct my_struct {
   /* Anonymous union/struct*/
   union {
	struct {
	    char arg1 : 1;
	    char arg2 : 3;
	};
       struct {
           int arg1b;
           int arg2b;
       };
       struct {
           void *arg3;
           int arg4;
           int (*f1)(char foo, int bar);
       };
   };
   union {
       struct {
           int arg1;
           int arg2;
	   struct foo bar1, *bar2;
       } st1;           /* bar.st1 is undocumented, cause a warning */
       struct {
           void *arg1;  /* bar.st3.arg1 is undocumented, cause a warning */
	    int arg2;
          int (*f2)(char foo, int bar); /* bar.st3.fn2 is undocumented, cause a warning */
       } st2, st3, *st4;
       int (*f3)(char foo, int bar); /* f3 is undocumented, cause a warning */
   } bar;               /* bar is undocumented, cause a warning */

   /* private: */
   int undoc_privat;    /* is undocumented but private, no warning */

   /* public: */
   int undoc_public;    /* is undocumented, cause a warning */
};
</code>

It produces the following warnings, as expected:

test2.h:57: warning: Function parameter or member 'bar' not described in 'my_struct'
test2.h:57: warning: Function parameter or member 'bar.st1' not described in 'my_struct'
test2.h:57: warning: Function parameter or member 'bar.st2' not described in 'my_struct'
test2.h:57: warning: Function parameter or member 'bar.st3' not described in 'my_struct'
test2.h:57: warning: Function parameter or member 'bar.st3.arg1' not described in 'my_struct'
test2.h:57: warning: Function parameter or member 'bar.st3.f2' not described in 'my_struct'
test2.h:57: warning: Function parameter or member 'bar.st4' not described in 'my_struct'
test2.h:57: warning: Function parameter or member 'bar.st4.arg1' not described in 'my_struct'
test2.h:57: warning: Function parameter or member 'bar.st4.arg2' not described in 'my_struct'
test2.h:57: warning: Function parameter or member 'bar.st4.f2' not described in 'my_struct'
test2.h:57: warning: Function parameter or member 'bar.f3' not described in 'my_struct'
test2.h:57: warning: Function parameter or member 'undoc_public' not described in 'my_struct'

Suggested-by: Markus Heiser <markus.heiser@darmarit.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 scripts/kernel-doc | 69 ++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 44 insertions(+), 25 deletions(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 67e8712aa324..049044d95c0e 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1008,15 +1008,16 @@ sub dump_struct($$) {
 	my $declaration = $members;
 
 	# Split nested struct/union elements as newer ones
-	my $cont = 1;
-	while ($cont) {
-		$cont = 0;
-		while ($members =~ m/(struct|union)([^{};]+){([^{}]*)}([^{}\;]*)\;/) {
-			my $newmember = "$1 $4;";
-			my $id = $4;
-			my $content = $3;
+	while ($members =~ m/(struct|union)([^{};]+){([^{}]*)}([^{}\;]*)\;/) {
+		my $newmember;
+		my $maintype = $1;
+		my $ids = $4;
+		my $content = $3;
+		foreach my $id(split /,/, $ids) {
+			$newmember .= "$maintype $id; ";
+
 			$id =~ s/[:\[].*//;
-			$id =~ s/^\*+//;
+			$id =~ s/^\s*\**(\S+)\s*/$1/;
 			foreach my $arg (split /;/, $content) {
 				next if ($arg =~ m/^\s*$/);
 				if ($arg =~ m/^([^\(]+\(\*?\s*)([\w\.]*)(\s*\).*)/) {
@@ -1027,30 +1028,48 @@ sub dump_struct($$) {
 					next if (!$name);
 					if ($id =~ m/^\s*$/) {
 						# anonymous struct/union
-						$newmember .= "$type$name$extra;";
+						$newmember .= "$type$name$extra; ";
 					} else {
-						$newmember .= "$type$id.$name$extra;";
+						$newmember .= "$type$id.$name$extra; ";
 					}
 				} else {
-					my $type = $arg;
-					my $name = $arg;
-					$type =~ s/\s\S+$//;
-					$name =~ s/.*\s+//;
-					$name =~ s/[:\[].*//;
-					$name =~ s/^\*+//;
-					next if (($name =~ m/^\s*$/));
-					if ($id =~ m/^\s*$/) {
-						# anonymous struct/union
-						$newmember .= "$type $name;";
+					my $type;
+					my $names;
+					$arg =~ s/^\s+//;
+					$arg =~ s/\s+$//;
+					# Handle bitmaps
+					$arg =~ s/:\s*\d+\s*//g;
+					# Handle arrays
+					$arg =~ s/\[\S+\]//g;
+					# The type may have multiple words,
+					# and multiple IDs can be defined, like:
+					#	const struct foo, *bar, foobar
+					# So, we remove spaces when parsing the
+					# names, in order to match just names
+					# and commas for the names
+					$arg =~ s/\s*,\s*/,/g;
+					if ($arg =~ m/(.*)\s+([\S+,]+)/) {
+						$type = $1;
+						$names = $2;
 					} else {
-						$newmember .= "$type $id.$name;";
+						$newmember .= "$arg; ";
+						next;
+					}
+					foreach my $name (split /,/, $names) {
+						$name =~ s/^\s*\**(\S+)\s*/$1/;
+						next if (($name =~ m/^\s*$/));
+						if ($id =~ m/^\s*$/) {
+							# anonymous struct/union
+							$newmember .= "$type $name; ";
+						} else {
+							$newmember .= "$type $id.$name; ";
+						}
 					}
 				}
 			}
-			$members =~ s/(struct|union)([^{};]+){([^{}]*)}([^{}\;]*)\;/$newmember/;
-			$cont = 1;
-		};
-	};
+		}
+		$members =~ s/(struct|union)([^{};]+){([^{}]*)}([^{}\;]*)\;/$newmember/;
+	}
 
 	# Ignore other nested elements, like enums
 	$members =~ s/({[^\{\}]*})//g;
-- 
2.13.6
