Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3.goneo.de ([85.220.129.37]:60420 "EHLO smtp3.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966076AbdIZQ4u (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 12:56:50 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH] scripts: kernel-doc: parse next structs/unions
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <3eff4e45c88ce0d5449d5794cf3019898c2a16bc.1506363302.git.mchehab@s-opensource.com>
Date: Tue, 26 Sep 2017 18:56:10 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <97F66D9A-45EA-444A-82F4-0A06AB3FE50A@darmarit.de>
References: <3eff4e45c88ce0d5449d5794cf3019898c2a16bc.1506363302.git.mchehab@s-opensource.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Am 25.09.2017 um 20:22 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> 
> Jon,
> 
> Please let me know what you think about this approach. IMHO, it is a way
> better than what we do right now. This is more a proof of concept, as the
> patch is not complete. 
> 
> With it, we can now document both anonymous and named unions/structs.
> 
> For named structs, the name of the fields should be in the format:
> 	foo.bar
> 
> What's missing on this PoC:
> 
> 1) I didn't check if @foo.bar: would work, though.  Probably the parser
>   for it should be added to allow this new syntax.

Below you will find my <test case> with a "@sys_clk.rate: lorem ipsum".
With I expected a output in the **Members** section for sys_clk.rate but
I got none :o

Anyway your concept is good and so I applied it to my py-version. If you
are interested in follow the patches titled ...

    kernel-doc: fix nested & sub-nested handling (continued

at  https://github.com/return42/linuxdoc/commits/master

I also added some comments from my (py-) experience to your perl
implementation below.

Here are some links which illustrate how your concept could work:

documentation with example: 
  https://return42.github.io/linuxdoc/linuxdoc-howto/kernel-doc-syntax.html#structs-unions

how the example is rendered:
  https://return42.github.io/linuxdoc/linuxdoc-howto/all-in-a-tumble.html#example-my-struct


> 
> 2) I only changed the ReST output to preserve the struct format with
>   nested fields. 
> 
> For (2), I'm thinking is we should still have all those output formats for
> kernel-doc. IMHO, I would keep just RST (and perhaps man - while we don't
> have a "make man" targed working.
> 
> Depending on your comments, I'll proceed addressing (1) and (2)
> and doing more tests with it.
> 
> 
> 
> scripts/kernel-doc | 83 +++++++++++++++++++++++++++++++++++-------------------
> 1 file changed, 54 insertions(+), 29 deletions(-)
> 
> diff --git a/scripts/kernel-doc b/scripts/kernel-doc
> index 9d3eafea58f0..5ca81b879088 100755
> --- a/scripts/kernel-doc
> +++ b/scripts/kernel-doc
> @@ -2035,29 +2035,9 @@ sub output_struct_rst(%) {
> 
>     print "**Definition**\n\n";
>     print "::\n\n";
> -    print "  " . $args{'type'} . " " . $args{'struct'} . " {\n";
> -    foreach $parameter (@{$args{'parameterlist'}}) {
> -	if ($parameter =~ /^#/) {
> -	    print "  " . "$parameter\n";
> -	    next;
> -	}
> -
> -	my $parameter_name = $parameter;
> -	$parameter_name =~ s/\[.*//;
> -
> -	($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
> -	$type = $args{'parametertypes'}{$parameter};
> -	if ($type =~ m/([^\(]*\(\*)\s*\)\s*\(([^\)]*)\)/) {
> -	    # pointer-to-function
> -	    print "    $1 $parameter) ($2);\n";
> -	} elsif ($type =~ m/^(.*?)\s*(:.*)/) {
> -	    # bitfield
> -	    print "    $1 $parameter$2;\n";
> -	} else {
> -	    print "    " . $type . " " . $parameter . ";\n";
> -	}
> -    }
> -    print "  };\n\n";
> +    my $declaration = $args{'definition'};
> +    $declaration =~ s/\t/  /g;
> +    print "  " . $args{'type'} . " " . $args{'struct'} . " {\n$declaration  };\n\n";
> 
>     print "**Members**\n\n";
>     $lineprefix = "  ";
> @@ -2168,20 +2148,15 @@ sub dump_struct($$) {
>     my $nested;
> 
>     if ($x =~ /(struct|union)\s+(\w+)\s*{(.*)}/) {
> -	#my $decl_type = $1;
> +	my $decl_type = $1;
> 	$declaration_name = $2;
> 	my $members = $3;
> 
> -	# ignore embedded structs or unions
> -	$members =~ s/({.*})//g;
> -	$nested = $1;
> -
> 	# ignore members marked private:
> 	$members =~ s/\/\*\s*private:.*?\/\*\s*public:.*?\*\///gosi;
> 	$members =~ s/\/\*\s*private:.*//gosi;
> 	# strip comments:
> 	$members =~ s/\/\*.*?\*\///gos;
> -	$nested =~ s/\/\*.*?\*\///gos;
> 	# strip kmemcheck_bitfield_{begin,end}.*;
> 	$members =~ s/kmemcheck_bitfield_.*?;//gos;
> 	# strip attributes
> @@ -2193,13 +2168,63 @@ sub dump_struct($$) {
> 	# replace DECLARE_HASHTABLE
> 	$members =~ s/DECLARE_HASHTABLE\s*\(([^,)]+), ([^,)]+)\)/unsigned long $1\[1 << (($2) - 1)\]/gos;
> 
> +	my $declaration = $members;
> +
> +	# Split nested struct/union elements as newer ones
> +	my $cont = 1;
> +	while ($cont) {
> +		$cont = 0;

Is the outer loop needed ..

> +		while ($members =~ m/(struct|union)([^{};]+){([^{}]*)}([^{}\;]*)\;/) {

this (inner) loop seems enough to me.

> +			my $newmember = "$1 $4;";
> +			my $id = $4;

This won't work if  you have e.g.

   union car {int foo;} bar1, bar2, *bbar3;

where $id will be "bar1, bar2, *bbar3", you need to split
this string and iterate over the id's.

> +			my $content = $3;
> +			$id =~ s/[:\[].*//;
> +			foreach my $arg (split /;/, $content) {
> +				next if ($arg =~ m/^\s*$/);
> +				my $type = $arg;
> +				my $name = $arg;
> +				$type =~ s/\s\S+$//;
> +				$name =~ s/.*\s//;
> +				next if (($name =~ m/^\s*$/));
> +				if ($id =~ m/^\s*$/) {
> +					# anonymous struct/union
> +					$newmember .= "$type $name;";
> +				} else {
> +					$newmember .= "$type $id.$name;";
> +				}
> +			}
> +			$members =~ s/(struct|union)([^{};]+){([^{}]*)}([^{}\;]*)\;/$newmember/;

I'am not so familiar with Perl regexpr, does this replace only the
first matching occurrence with $newmember or all?

> +			$cont = 1;
> +		};
> +	};
> +
> +	# Ignore other nested elements, like enums
> +	$members =~ s/({[^\{\}]*})//g;
> +	$nested = $decl_type;
> +	$nested =~ s/\/\*.*?\*\///gos;
> +
> 	create_parameterlist($members, ';', $file);
> 	check_sections($file, $declaration_name, "struct", $sectcheck, $struct_actual, $nested);
> 
> +	# Adjust declaration for better display
> +	$declaration =~ s/([{,;])/$1\n/g;
> +	$declaration =~ s/}\s+;/};/g;
> +	my @def_args = split /\n/, $declaration;
> +	my $level = 2;
> +	$declaration = "";
> +	foreach my $clause (@def_args) {
> +		$clause =~ s/^\s+//;
> +		$clause =~ s/\s+$//;
> +		$clause =~ s/\s+/ /;
> +		$level-- if ($clause =~ m/}/ && $level > 2);
> +		$declaration .= "\t" x $level . $clause . "\n" if ($clause);

why inserting tabs, indentation in reST is normally done with
spaces, which are clear for everyone / IMO tabs are more
confusing than helpful.

> +		$level++ if ($clause =~ m/{/);
> +	}
> 	output_declaration($declaration_name,
> 			   'struct',
> 			   {'struct' => $declaration_name,
> 			    'module' => $modulename,
> +			    'definition' => $declaration,
> 			    'parameterlist' => \@parameterlist,
> 			    'parameterdescs' => \%parameterdescs,
> 			    'parametertypes' => \%parametertypes,
> -- 
> 2.13.5
> 


Some more comments ..

With parsing nested names, we get a lot more of such warnings:

  rch/arm/mach-omap2/voltage.h:91: warning: No description found for parameter 'sys_clk.rate'

IMO we should better supress such warnings (BTW fix the identation):

@@ -2531,9 +2529,7 @@ sub check_sections($$$$$$) {
 			} else {
-				if ($nested !~ m/\Q$sects[$sx]\E/) {
-				    print STDERR "${file}:$.: warning: " .
-					"Excess struct/union/enum/typedef member " .
-					"'$sects[$sx]' " .
-					"description in '$decl_name'\n";
-				    ++$warnings;
-				}
+                            print STDERR "${file}:$.: warning: " .
+                                "Excess struct/union/enum/typedef member " .
+                                "'$sects[$sx]' " .
+                                "description in '$decl_name'\n";
+                            ++$warnings;
 			}





<test case>-----------------
/**
 * struct voltagedomain - omap voltage domain global structure.
 * @name: Name of the voltage domain which can be used as a unique identifier.
 * @scalable: Whether or not this voltage domain is scalable
 * @node: list_head linking all voltage domains
 * @vc: pointer to VC channel associated with this voltagedomain
 * @vp: pointer to VP associated with this voltagedomain
 * @read: read a VC/VP register
 * @write: write a VC/VP register
 * @read: read-modify-write a VC/VP register
 * @sys_clk: system clock name/frequency, used for various timing calculations
 * @sys_clk.rate: lorem ipsum
 * @scale: function used to scale the voltage of the voltagedomain
 * @nominal_volt: current nominal voltage for this voltage domain
 * @volt_data: voltage table having the distinct voltages supported
 *             by the domain and other associated per voltage data.
 */
struct voltagedomain {
	char *name;
	bool scalable;
	struct list_head node;
	struct omap_vc_channel *vc;
	const struct omap_vfsm_instance *vfsm;
	struct omap_vp_instance *vp;
	struct omap_voltdm_pmic *pmic;
	struct omap_vp_param *vp_param;
	struct omap_vc_param *vc_param;

	/* VC/VP register access functions: SoC specific */
	u32 (*read) (u8 offset);
	void (*write) (u32 val, u8 offset);
	u32 (*rmw)(u32 mask, u32 bits, u8 offset);

	union {
		const char *name;
		u32 rate;
	} sys_clk;

	int (*scale) (struct voltagedomain *voltdm,
		      unsigned long target_volt);

	u32 nominal_volt;
	struct omap_volt_data *volt_data;
};

<test case>-----------------

-- Markus --
