Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:56337
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S964984AbdIZTRA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 15:17:00 -0400
Date: Tue, 26 Sep 2017 16:16:48 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: Re: [PATCH] scripts: kernel-doc: parse next structs/unions
Message-ID: <20170926161648.2ba4b270@recife.lan>
In-Reply-To: <97F66D9A-45EA-444A-82F4-0A06AB3FE50A@darmarit.de>
References: <3eff4e45c88ce0d5449d5794cf3019898c2a16bc.1506363302.git.mchehab@s-opensource.com>
        <97F66D9A-45EA-444A-82F4-0A06AB3FE50A@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 26 Sep 2017 18:56:10 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> > Am 25.09.2017 um 20:22 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> > 
> > Jon,
> > 
> > Please let me know what you think about this approach. IMHO, it is a way
> > better than what we do right now. This is more a proof of concept, as the
> > patch is not complete. 
> > 
> > With it, we can now document both anonymous and named unions/structs.
> > 
> > For named structs, the name of the fields should be in the format:
> > 	foo.bar
> > 
> > What's missing on this PoC:
> > 
> > 1) I didn't check if @foo.bar: would work, though.  Probably the parser
> >   for it should be added to allow this new syntax.  
> 
> Below you will find my <test case> with a "@sys_clk.rate: lorem ipsum".
> With I expected a output in the **Members** section for sys_clk.rate but
> I got none :o

The parser line for @foo.bar: was not working, as I was expecting. The
version I posted today handles it well:

``sys_clk.rate``
  lorem ipsum

It didn't handled - nor warned - about the lack of documentation for
this one:
        const struct omap_vfsm_instance *vfsm;

but this is unrelated.

> Anyway your concept is good and so I applied it to my py-version. If you
> are interested in follow the patches titled ...
> 
>     kernel-doc: fix nested & sub-nested handling (continued
> 
> at  https://github.com/return42/linuxdoc/commits/master
> 
> I also added some comments from my (py-) experience to your perl
> implementation below.
> 
> Here are some links which illustrate how your concept could work:
> 
> documentation with example: 
>   https://return42.github.io/linuxdoc/linuxdoc-howto/kernel-doc-syntax.html#structs-unions
> 
> how the example is rendered:
>   https://return42.github.io/linuxdoc/linuxdoc-howto/all-in-a-tumble.html#example-my-struct

> > 
> > +	my $declaration = $members;
> > +
> > +	# Split nested struct/union elements as newer ones
> > +	my $cont = 1;
> > +	while ($cont) {
> > +		$cont = 0;  
> 
> Is the outer loop needed ..
> 
> > +		while ($members =~ m/(struct|union)([^{};]+){([^{}]*)}([^{}\;]*)\;/) {  
> 
> this (inner) loop seems enough to me.
> 
> > +			my $newmember = "$1 $4;";
> > +			my $id = $4;  
> 
> This won't work if  you have e.g.
> 
>    union car {int foo;} bar1, bar2, *bbar3;
> 
> where $id will be "bar1, bar2, *bbar3", you need to split
> this string and iterate over the id's.

That's true, if we have cases like that. I hope not!

Seriously, in the above case, the developer should very likely declare
the union outside the main struct and have its own kernel-doc markup.

My personal taste would be to not explicitly support the above. If it
hits some code, try to argue with the developer first, before patching
kernel-doc to such weird stuff.

> > +			my $content = $3;
> > +			$id =~ s/[:\[].*//;
> > +			foreach my $arg (split /;/, $content) {
> > +				next if ($arg =~ m/^\s*$/);
> > +				my $type = $arg;
> > +				my $name = $arg;
> > +				$type =~ s/\s\S+$//;
> > +				$name =~ s/.*\s//;
> > +				next if (($name =~ m/^\s*$/));
> > +				if ($id =~ m/^\s*$/) {
> > +					# anonymous struct/union
> > +					$newmember .= "$type $name;";
> > +				} else {
> > +					$newmember .= "$type $id.$name;";
> > +				}
> > +			}
> > +			$members =~ s/(struct|union)([^{};]+){([^{}]*)}([^{}\;]*)\;/$newmember/;  
> 
> I'am not so familiar with Perl regexpr, does this replace only the
> first matching occurrence with $newmember or all?

Just the first match. if we wanted to apply it multiple times, we need
to add a "g" at the end, e. g.:

	$members =~ s/(struct|union)([^{};]+){([^{}]*)}([^{}\;]*)\;/$newmember/g;


> 
> > +			$cont = 1;
> > +		};
> > +	};
> > +
> > +	# Ignore other nested elements, like enums
> > +	$members =~ s/({[^\{\}]*})//g;
> > +	$nested = $decl_type;
> > +	$nested =~ s/\/\*.*?\*\///gos;
> > +
> > 	create_parameterlist($members, ';', $file);
> > 	check_sections($file, $declaration_name, "struct", $sectcheck, $struct_actual, $nested);
> > 
> > +	# Adjust declaration for better display
> > +	$declaration =~ s/([{,;])/$1\n/g;
> > +	$declaration =~ s/}\s+;/};/g;
> > +	my @def_args = split /\n/, $declaration;
> > +	my $level = 2;
> > +	$declaration = "";
> > +	foreach my $clause (@def_args) {
> > +		$clause =~ s/^\s+//;
> > +		$clause =~ s/\s+$//;
> > +		$clause =~ s/\s+/ /;
> > +		$level-- if ($clause =~ m/}/ && $level > 2);
> > +		$declaration .= "\t" x $level . $clause . "\n" if ($clause);  
> 
> why inserting tabs, indentation in reST is normally done with
> spaces, which are clear for everyone / IMO tabs are more
> confusing than helpful.

For ReST output, using two spaces is likely better than tab, specially
if we end by having very long arguments (with cause troubles on PDF output).
For other output formats, the actual representation can be different.

So, I opted to convert \t into two spaces only when generating
the output.

Please notice that the entire code can be reviewed/simplified once we get
support for man pages output and strip it from kernel-doc.

Yet, when this happens, perhaps we could just get rid of the perl version
of this script and have only a Sphinx extension that could, optionally,
be called via command line, for testing purposes.
 
> > +		$level++ if ($clause =~ m/{/);
> > +	}
> > 	output_declaration($declaration_name,
> > 			   'struct',
> > 			   {'struct' => $declaration_name,
> > 			    'module' => $modulename,
> > +			    'definition' => $declaration,
> > 			    'parameterlist' => \@parameterlist,
> > 			    'parameterdescs' => \%parameterdescs,
> > 			    'parametertypes' => \%parametertypes,
> > -- 
> > 2.13.5
> >   
> 
> 
> Some more comments ..
> 
> With parsing nested names, we get a lot more of such warnings:
> 
>   rch/arm/mach-omap2/voltage.h:91: warning: No description found for parameter 'sys_clk.rate'

That's true.

> 
> IMO we should better supress such warnings (BTW fix the identation):

My personal preference would be to have an optional argument that would
allow enabling/disabling such warnings in runtime.

Thanks,
Mauro
