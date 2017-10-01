Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:46399 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751021AbdJALDB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 1 Oct 2017 07:03:01 -0400
Date: Sun, 1 Oct 2017 08:02:27 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH v2 09/13] scripts: kernel-doc: parse next structs/unions
Message-ID: <20171001080146.282dad4b@vento.lan>
In-Reply-To: <68968C67-7CD6-4264-A46D-1EE195CBC58D@darmarit.de>
References: <cover.1506546492.git.mchehab@s-opensource.com>
        <cover.1506546492.git.mchehab@s-opensource.com>
        <b2528c4f1d2e76b7dacde8c5660e94de32e2eb71.1506546492.git.mchehab@s-opensource.com>
        <68968C67-7CD6-4264-A46D-1EE195CBC58D@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 28 Sep 2017 18:28:32 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> Hi Mauro,
> 
> > Am 27.09.2017 um 23:10 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:

> > +	# Split nested struct/union elements as newer ones
> > +	my $cont = 1;
> > +	while ($cont) {
> > +		$cont = 0;  
> 
> 
> You ignored the remarks I made to v1: 
> 
>  this outer loop is not needed!
> 
> 
> > +		while ($members =~ m/(struct|union)([^{};]+){([^{}]*)}([^{}\;]*)\;/) {  
> 
> 
> The inner loop is enough.
> 
> > +			my $newmember = "$1 $4;";
> > +			my $id = $4;  
> 
> 
> > Am 26.09.2017 um 21:16 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> >   
> >> This won't work if  you have e.g.
> >> 
> >>  union car {int foo;} bar1, bar2, *bbar3;
> >> 
> >> where $id will be "bar1, bar2, *bbar3", you need to split
> >> this string and iterate over the id's.  
> > 
> > That's true, if we have cases like that. I hope not!  
> 
> We have! I can't remember where, but I hit such constructs while
> parsing the whole sources.
> 
> > 
> > Seriously, in the above case, the developer should very likely declare
> > the union outside the main struct and have its own kernel-doc markup.
> > 
> > My personal taste would be to not explicitly support the above. If it
> > hits some code, try to argue with the developer first, before patching
> > kernel-doc to such weird stuff.  
> 
> Why is it wired? Anyway we have it and this kernel-doc fails with.
> 
> It also fails with bit types e.g.
> 
>        struct {
> 	    __u8 arg1 : 1;
> 	    __u8 arg2 : 3;
>        };
> 
> 
> May it help, if you inspect the py-version of this loop:
> 
>    https://github.com/return42/linuxdoc/blob/master/linuxdoc/kernel_doc.py#L2499

I addressed the things you pointed above.

I decided to add the new logic on a separate patch, as handling
those special cases seemed complex enough to justify placing it
in separate.

I also added the test for nested structs at the commit log, as it may
help if someone would further need to improve it to handle other
cases.

The entire patch series is at:
	https://git.linuxtv.org/mchehab/experimental.git/log/?h=nested-fix-v4


Thanks,
Mauro

[PATCH] scripts: kernel-doc: improve nested logic to handle multiple
 identifiers

It is possible to use nested structs like:

struct {
	struct {
		void *arg1;
	} st1, st2, *st3, st4;
}

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

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 2dd36c2256fa..0037be99d44d 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1004,15 +1004,16 @@ sub dump_struct($$) {
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
@@ -1023,30 +1024,48 @@ sub dump_struct($$) {
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
