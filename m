Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:36368 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752449AbdJKTSB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Oct 2017 15:18:01 -0400
Date: Wed, 11 Oct 2017 16:17:53 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/17] kernel-doc: add supported to document nested
 structs/
Message-ID: <20171011161753.400cc1d6@vento.lan>
In-Reply-To: <20171009101955.4a860821@vento.lan>
References: <cover.1507116877.git.mchehab@s-opensource.com>
        <20171007103440.35393957@lwn.net>
        <46422126-F8AB-41A0-8962-99D024EE17D3@darmarit.de>
        <20171009101955.4a860821@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 9 Oct 2017 10:19:55 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:

> > > I really don't want to add that much noise to the docs build; I think it
> > > will defeat any hope of cleaning up the warnings we already have.  I
> > > wonder if we could suppress warnings about nested structs by default, and
> > > add a flag or envar to turn them back on for those who want them?    
> > 
> > This is what I vote for: +1
> >   
> > > In truth, now that I look, the real problem is that the warnings are
> > > repeated many times - as in, like 100 times:
> > >     
> > >> ./include/net/cfg80211.h:4115: warning: Function parameter or member 'wext.ibss' not described in 'wireless_dev'
> > >> ./include/net/cfg80211.h:4115: warning: Function parameter or member 'wext.ibss' not described in 'wireless_dev'    
> > > <107 instances deleted...>    
> > >> ./include/net/cfg80211.h:4115: warning: Function parameter or member 'wext.ibss' not described in 'wireless_dev'    
> > > 
> > > That's not something that used to happen, and is certainly not helpful.
> > > Figuring that out would help a lot.  Can I get you to take a look at
> > > what's going on here?    
> > 
> > Hi Jon, if you grep for 
> > 
> >  .. kernel-doc:: include/net/cfg80211.h
> > 
> > e.g. by:  grep cfg80211.h Documentation/driver-api/80211/cfg80211.rst | wc -l
> > you will see, that this directive is used 110 times in one reST file. If you
> > have 5 warnings about the kernel-doc markup in include/net/cfg80211.h you will
> > get 550 warnings about kernel-doc markup just for just one source code file.
> > 
> > This is because the kernel-doc parser is an external process which is called
> > (in this example) 110 times for one reST file and one source code file. If 
> > include/net/cfg80211.h is referred in other reST files, we got accordingly
> > more and more warnings .. thats really noise.   
> 
> I guess the solution here is simple: if any output selection argument
> is passed (-export, -internal, -function, -nofunction), only report
> warnings for things that match the output criteria. 
> 
> Not sure how easy is to implement that. I'll take a look.

It is actually very easy to suppress those warnings. See the enclosed
proof of concept patch.

Please notice that this patch is likely incomplete: all it does is that,
if --function or --nofunction is used, it won't print any warnings
for structs or enums.

I didn't check yet if this is not making it too silent.

If we're going to follow this way, IMHO, the best would be to define
a warning function and move the needed checks for $output_selection
and for $function for it to do the right thing, printing warnings only
for the stuff that will be output.

Jon,

Please let me know if you prefer go though this way or if, instead, you
opt to replace the kernel-doc perl script by a Sphinx module.

If you decide to keep with the perl script for now, I can work on an
improved version of this PoC.


Regards,
Mauro

scripts: kernel-doc: shut up enum/struct warnings if parsing only functions

There are two command line parameters that restrict the kernel-doc output
to output only functions. If this is used, it doesn't make any sense to
produce warnings about enums and structs. So, shut up such warnings.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 049044d95c0e..b4eebea6a8d6 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1138,16 +1138,20 @@ sub dump_enum($$) {
 	    push @parameterlist, $arg;
 	    if (!$parameterdescs{$arg}) {
 		$parameterdescs{$arg} = $undescribed;
-		print STDERR "${file}:$.: warning: Enum value '$arg' ".
-		    "not described in enum '$declaration_name'\n";
+		if ($output_selection != OUTPUT_INCLUDE &&
+		    $output_selection != OUTPUT_EXCLUDE) {
+			print STDERR "${file}:$.: warning: Enum value '$arg' not described in enum '$declaration_name'\n";
+		}
 	    }
 	    $_members{$arg} = 1;
 	}
 
 	while (my ($k, $v) = each %parameterdescs) {
 	    if (!exists($_members{$k})) {
-	     print STDERR "${file}:$.: warning: Excess enum value " .
-	                  "'$k' description in '$declaration_name'\n";
+		if ($output_selection != OUTPUT_INCLUDE &&
+		    $output_selection != OUTPUT_EXCLUDE) {
+		     print STDERR "${file}:$.: warning: Excess enum value '$k' description in '$declaration_name'\n";
+		}
 	    }
         }
 
@@ -1353,9 +1357,12 @@ sub push_parameter($$$$) {
 	if (!defined $parameterdescs{$param} && $param !~ /^#/) {
 		$parameterdescs{$param} = $undescribed;
 
-		print STDERR
-		      "${file}:$.: warning: Function parameter or member '$param' not described in '$declaration_name'\n";
-		++$warnings;
+		if ($output_selection != OUTPUT_INCLUDE &&
+		    $output_selection != OUTPUT_EXCLUDE) {
+			print STDERR
+			      "${file}:$.: warning: Function parameter or member '$param' not described in '$declaration_name'\n";
+			++$warnings;
+		}
 	}
 
 	$param = xml_escape($param);
