Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33643
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752624AbdIXRin (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Sep 2017 13:38:43 -0400
Date: Sun, 24 Sep 2017 14:38:33 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2] scripts: kernel-doc: fix nexted handling
Message-ID: <20170924143833.63e9b3cd@vento.lan>
In-Reply-To: <4F0B529A-AF0A-48F9-808A-594BF07D035B@darmarit.de>
References: <3d54014d786733715a94fa783a479a498aaca1ea.1506248420.git.mchehab@s-opensource.com>
        <4F0B529A-AF0A-48F9-808A-594BF07D035B@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 24 Sep 2017 17:13:13 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> > Am 24.09.2017 um 12:23 schrieb Mauro Carvalho Che
> > 
> > v2:  handle embedded structs/unions from inner to outer
> > 
> > When we have multiple levels of embedded structs,
> > 
> > we need a smarter rule that will be removing nested structs
> > from the inner to the outer ones. So, changed the parsing rule to
> > remove nested structs/unions from the inner ones to the outer
> > ones, while it matches.  
> 
> argh, sub-nested I forgot.
> 
> > scripts/kernel-doc | 2 +-
> > 1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/scripts/kernel-doc b/scripts/kernel-doc
> > index 9d3eafea58f0..443e1bcc78db 100755
> > --- a/scripts/kernel-doc
> > +++ b/scripts/kernel-doc
> > @@ -2173,7 +2173,7 @@ sub dump_struct($$) {
> > 	my $members = $3;
> > 
> > 	# ignore embedded structs or unions
> > -	$members =~ s/({.*})//g;
> > +	while ($members =~ s/({[^\{\}]*})//g) {};
> > 	$nested = $1;  
> 
> I haven't tested this patch, but I guess with you might get
> some "excess struct member" warnings, since the value of
> 'nested' is just the content of the last match.
> 
> Here is what I have done in the python version:
> 
>  https://github.com/return42/linuxdoc/commit/8d9394
> 
> and here is the impact:
> 
>  https://github.com/return42/sphkerneldoc/commit/2ff22cf82de3236c1ec7616bd4b65ce2aedd2a90
> 
> As you can see in my linked patch above, I implemented it by
> hand and collected all the 'nested' stuff. I guess this
> is impossible with regexpr.
> 
> I recommend to do something similar with the perl script.
> 
> Since your perl is better than my; could you please prepare such a v3 patch?
> 
> Thanks!

Hmm... after looking at the "impact" URL, I guess we should, instead,
*not* ignore nested arguments, but also parse them, as this would allow
adding documentation for them, e. g. something like the (incomplete)
patch.

As reference, I'm testing it with:

	$ scripts/kernel-doc -rst ./drivers/clk/ingenic/cgu.h 

PS.: I'm pretty sure it can be improved. Also, only the ReST output
is working properly on this current version.

Regards,
Mauro

[PATCH RFC] scripts: kernel-doc: parse nexted structs/unions
    
At DVB, we have, at some structs, things like (see
struct dvb_demux_feed, at dvb_demux.h):
    
            union {
                    struct dmx_ts_feed ts;
                    struct dmx_section_feed sec;
            } feed;
    
            union {
                    dmx_ts_cb ts;
                    dmx_section_cb sec;
            } cb;
    
Fix the nested parser to avoid it to eat the first union.
    
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 9d3eafea58f0..102d5ec200a4 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -2036,26 +2036,18 @@ sub output_struct_rst(%) {
     print "**Definition**\n\n";
     print "::\n\n";
     print "  " . $args{'type'} . " " . $args{'struct'} . " {\n";
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	if ($parameter =~ /^#/) {
-	    print "  " . "$parameter\n";
-	    next;
-	}
 
-	my $parameter_name = $parameter;
-	$parameter_name =~ s/\[.*//;
-
-	($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
-	$type = $args{'parametertypes'}{$parameter};
-	if ($type =~ m/([^\(]*\(\*)\s*\)\s*\(([^\)]*)\)/) {
-	    # pointer-to-function
-	    print "    $1 $parameter) ($2);\n";
-	} elsif ($type =~ m/^(.*?)\s*(:.*)/) {
-	    # bitfield
-	    print "    $1 $parameter$2;\n";
-	} else {
-	    print "    " . $type . " " . $parameter . ";\n";
-	}
+    my $def = $args{'definition'};
+    $def =~ s/([{,;])/$1\n/g;
+    $def =~ s/}\s+;/};/g;
+    my @def_args = split /\n/, $def;
+    my $level = 1;
+    foreach my $clause (@def_args) {
+	$clause =~ s/^\s+//;
+	$clause =~ s/\s+$//;
+	$level-- if ($clause =~ m/}/ && $level > 1);
+	print "  " . "  " x $level. "$clause\n" if ($clause);
+	$level++ if ($clause =~ m/{/);
     }
     print "  };\n\n";
 
@@ -2168,13 +2160,22 @@ sub dump_struct($$) {
     my $nested;
 
     if ($x =~ /(struct|union)\s+(\w+)\s*{(.*)}/) {
-	#my $decl_type = $1;
+	my $decl_type = $1;
 	$declaration_name = $2;
 	my $members = $3;
-
-	# ignore embedded structs or unions
-	$members =~ s/({.*})//g;
-	$nested = $1;
+	my $clause = $3;
+
+	# Split nested struct/union elements as newer ones
+	my $cont = 1;
+	while ($cont) {
+		$cont = 0;
+		while ($members =~ s/(struct|union)\s+{([^{}]*)}(\s*\S+\s*)\;?/$1 $3; $2 /g) {
+			$cont = 1;
+		};
+	};
+	# Ignore other nested elements, like enums
+	$members =~ s/({[^\{\}]*})//g;
+	$nested = $decl_type;
 
 	# ignore members marked private:
 	$members =~ s/\/\*\s*private:.*?\/\*\s*public:.*?\*\///gosi;
@@ -2200,6 +2201,7 @@ sub dump_struct($$) {
 			   'struct',
 			   {'struct' => $declaration_name,
 			    'module' => $modulename,
+			    'definition' => $clause,
 			    'parameterlist' => \@parameterlist,
 			    'parameterdescs' => \%parameterdescs,
 			    'parametertypes' => \%parametertypes,



Thanks,
Mauro
