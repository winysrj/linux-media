Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:56210
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933917AbdIZS6c (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 14:58:32 -0400
Date: Tue, 26 Sep 2017 15:58:23 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2] scripts: kernel-doc: fix nexted handling
Message-ID: <20170926155823.7d322cf3@recife.lan>
In-Reply-To: <0BDD5AC2-EECB-4748-9DDE-DDD7AC0062D3@darmarit.de>
References: <3d54014d786733715a94fa783a479a498aaca1ea.1506248420.git.mchehab@s-opensource.com>
        <4F0B529A-AF0A-48F9-808A-594BF07D035B@darmarit.de>
        <20170924143833.63e9b3cd@vento.lan>
        <A9911D58-7C66-4543-B3AA-AEBA930CDB79@darmarit.de>
        <20170925154144.055e3ee7@vento.lan>
        <0BDD5AC2-EECB-4748-9DDE-DDD7AC0062D3@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 26 Sep 2017 14:45:08 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> > Am 25.09.2017 um 20:41 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:  
> 
> >>> +			$cont = 1;
> >>> +		};
> >>> +	};
> >>> +	# Ignore other nested elements, like enums
> >>> +	$members =~ s/({[^\{\}]*})//g;
> >>> +	$nested = $decl_type;    
> >> 
> >> What is the latter good for? I guess the 'nested' trick to suppress
> >> such 'excess' warnings from nested types is no longer needed .. right?  
> > 
> > For things like:
> > 
> > 	enum { foo, bar } type;
> > 
> > Granted, a good documentation should also describe "foo" and "bar",
> > but that could be easily done by moving enums out of the struct, or
> > by add descriptions for "foo" and "bar" at @type: markup.  
> 
> 
> Hm .. I suppose you are misunderstanding me. I didn't asked about 
> $members, I asked about $nested. There is only one place where
> $nested is used, and this is in the check_sections function ...
> 
> @@ -2531,9 +2527,7 @@ sub check_sections($$$$$$) {
>  			} else {
> -				if ($nested !~ m/\Q$sects[$sx]\E/) {
> -				    print STDERR "${file}:$.: warning: " .
> -					"Excess struct/union/enum/typedef member " .
> -					"'$sects[$sx]' " .
> -					"description in '$decl_name'\n";
> -				    ++$warnings;
> -				}
> +                            print STDERR "${file}:$.: warning: " .
> +                                "Excess struct/union/enum/typedef member " .
> +                                "'$sects[$sx]' " .
> +                                "description in '$decl_name'\n";
> +                            ++$warnings;
>  			}
> 
> Since this is the only place where $nested is use, we can drop all
> the occurrence of $nested in the kernel-doc script .. or I'am
> totally wrong?

Ah, now I understood you! Yeah, this can be removed. I'll put it into
a separate cleanup patch.

See below.

Regards,
Mauro


[PATCH] scripts: kernel-doc: get rid of $nested parameter

The check_sections() function has a $nested parameter, meant
to identify when a nested struct is present. As we now have
a logic that handles it, get rid of such parameter.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 880a196c7dc7..cff66ee91f2c 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -979,7 +979,6 @@ sub dump_union($$) {
 sub dump_struct($$) {
     my $x = shift;
     my $file = shift;
-    my $nested;
 
     if ($x =~ /(struct|union)\s+(\w+)\s*{(.*)}/) {
 	my $decl_type = $1;
@@ -1034,11 +1033,9 @@ sub dump_struct($$) {
 
 	# Ignore other nested elements, like enums
 	$members =~ s/({[^\{\}]*})//g;
-	$nested = $decl_type;
-	$nested =~ s/\/\*.*?\*\///gos;
 
 	create_parameterlist($members, ';', $file);
-	check_sections($file, $declaration_name, "struct", $sectcheck, $struct_actual, $nested);
+	check_sections($file, $declaration_name, "struct", $sectcheck, $struct_actual);
 
 	# Adjust declaration for better display
 	$declaration =~ s/([{;])/$1\n/g;
@@ -1334,8 +1331,8 @@ sub push_parameter($$$) {
 	$parametertypes{$param} = $type;
 }
 
-sub check_sections($$$$$$) {
-	my ($file, $decl_name, $decl_type, $sectcheck, $prmscheck, $nested) = @_;
+sub check_sections($$$$$) {
+	my ($file, $decl_name, $decl_type, $sectcheck, $prmscheck) = @_;
 	my @sects = split ' ', $sectcheck;
 	my @prms = split ' ', $prmscheck;
 	my $err;
@@ -1369,14 +1366,6 @@ sub check_sections($$$$$$) {
 					"'$sects[$sx]' " .
 					"description in '$decl_name'\n";
 				++$warnings;
-			} else {
-				if ($nested !~ m/\Q$sects[$sx]\E/) {
-				    print STDERR "${file}:$.: warning: " .
-					"Excess struct/union/enum/typedef member " .
-					"'$sects[$sx]' " .
-					"description in '$decl_name'\n";
-				    ++$warnings;
-				}
 			}
 		}
 	}
@@ -1487,7 +1476,7 @@ sub dump_function($$) {
     }
 
 	my $prms = join " ", @parameterlist;
-	check_sections($file, $declaration_name, "function", $sectcheck, $prms, "");
+	check_sections($file, $declaration_name, "function", $sectcheck, $prms);
 
         # This check emits a lot of warnings at the moment, because many
         # functions don't have a 'Return' doc section. So until the number


Thanks,
Mauro
