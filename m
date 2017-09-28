Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3.goneo.de ([85.220.129.37]:44804 "EHLO smtp3.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751689AbdI1Q2p (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Sep 2017 12:28:45 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v2 09/13] scripts: kernel-doc: parse next structs/unions
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <b2528c4f1d2e76b7dacde8c5660e94de32e2eb71.1506546492.git.mchehab@s-opensource.com>
Date: Thu, 28 Sep 2017 18:28:32 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Transfer-Encoding: 8BIT
Message-Id: <68968C67-7CD6-4264-A46D-1EE195CBC58D@darmarit.de>
References: <cover.1506546492.git.mchehab@s-opensource.com>
 <cover.1506546492.git.mchehab@s-opensource.com>
 <b2528c4f1d2e76b7dacde8c5660e94de32e2eb71.1506546492.git.mchehab@s-opensource.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

> Am 27.09.2017 um 23:10 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> 
> 
> 
> diff --git a/Documentation/doc-guide/kernel-doc.rst b/Documentation/doc-guide/kernel-doc.rst
> index 96012f9e314d..9e63a18cceea 100644
> --- a/Documentation/doc-guide/kernel-doc.rst
> +++ b/Documentation/doc-guide/kernel-doc.rst
> @@ -281,6 +281,52 @@ comment block.
> The kernel-doc data structure comments describe each member of the structure,
> in order, with the member descriptions.
> 
> +Nested structs/unions
> +~~~~~~~~~~~~~~~~~~~~~
> +
> +It is possible to document nested structs unions, like::
> +
> +      /**
> +       * struct nested_foobar - a struct with nested unions and structs
> +       * @arg1: - first argument of anonymous union/anonymous struct
> +       * @arg2: - second argument of anonymous union/anonymous struct
> +       * @arg3: - third argument of anonymous union/anonymous struct
> +       * @arg4: - fourth argument of anonymous union/anonymous struct
> +       * @bar.st1.arg1 - first argument of struct st1 on union bar
> +       * @bar.st1.arg2 - second argument of struct st1 on union bar
> +       * @bar.st2.arg1 - first argument of struct st2 on union bar
> +       * @bar.st2.arg2 - second argument of struct st2 on union bar

Sorry, this example is totally broken --> below I attached a more
elaborate example. I also untabified the example since tabs in reST are
a nightmare, especially in code blocks ... tabulators are the source
of all evil [1] ...

  Please, never use tabs in markups or programming languages
  where indentation is a part of the markup respectively the 
  language!!

> diff --git a/scripts/kernel-doc b/scripts/kernel-doc
> index b6f3f6962897..63aa9f85d635 100755
> --- a/scripts/kernel-doc
> +++ b/scripts/kernel-doc
> @@ -210,7 +210,7 @@ my $anon_struct_union = 0;
> my $type_constant = '\b``([^\`]+)``\b';
> my $type_constant2 = '\%([-_\w]+)';
> my $type_func = '(\w+)\(\)';
> -my $type_param = '\@(\w+(\.\.\.)?)';
> +my $type_param = '\@(\w*(\.\w+)*(\.\.\.)?)';
> my $type_fp_param = '\@(\w+)\(\)';  # Special RST handling for func ptr params
> my $type_env = '(\$\w+)';
> my $type_enum = '\&(enum\s*([_\w]+))';
> @@ -663,32 +663,12 @@ sub output_struct_man(%) {
>    print ".SH NAME\n";
>    print $args{'type'} . " " . $args{'struct'} . " \\- " . $args{'purpose'} . "\n";
> 
> +    my $declaration = $args{'definition'};
> +    $declaration =~ s/\t/  /g;
> +    $declaration =~ s/\n/"\n.br\n.BI \"/g;
>    print ".SH SYNOPSIS\n";
>    print $args{'type'} . " " . $args{'struct'} . " {\n.br\n";
> -
> -    foreach my $parameter (@{$args{'parameterlist'}}) {
> -	if ($parameter =~ /^#/) {
> -	    print ".BI \"$parameter\"\n.br\n";
> -	    next;
> -	}
> -	my $parameter_name = $parameter;
> -	$parameter_name =~ s/\[.*//;
> -
> -	($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
> -	$type = $args{'parametertypes'}{$parameter};
> -	if ($type =~ m/([^\(]*\(\*)\s*\)\s*\(([^\)]*)\)/) {
> -	    # pointer-to-function
> -	    print ".BI \"    " . $1 . "\" " . $parameter . " \") (" . $2 . ")" . "\"\n;\n";
> -	} elsif ($type =~ m/^(.*?)\s*(:.*)/) {
> -	    # bitfield
> -	    print ".BI \"    " . $1 . "\ \" " . $parameter . $2 . " \"" . "\"\n;\n";
> -	} else {
> -	    $type =~ s/([^\*])$/$1 /;
> -	    print ".BI \"    " . $type . "\" " . $parameter . " \"" . "\"\n;\n";
> -	}
> -	print "\n.br\n";
> -    }
> -    print "};\n.br\n";
> +    print ".BI \"$declaration\n};\n.br\n\n";
> 
>    print ".SH Members\n";
>    foreach $parameter (@{$args{'parameterlist'}}) {
> @@ -926,29 +906,9 @@ sub output_struct_rst(%) {
> 
>    print "**Definition**\n\n";
>    print "::\n\n";
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
>    print "**Members**\n\n";
>    $lineprefix = "  ";
> @@ -1022,20 +982,15 @@ sub dump_struct($$) {
>    my $nested;
> 
>    if ($x =~ /(struct|union)\s+(\w+)\s*{(.*)}/) {
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
> @@ -1047,13 +1002,73 @@ sub dump_struct($$) {
> 	# replace DECLARE_HASHTABLE
> 	$members =~ s/DECLARE_HASHTABLE\s*\(([^,)]+), ([^,)]+)\)/unsigned long $1\[1 << (($2) - 1)\]/gos;
> 
> +	my $declaration = $members;
> +
> +	# Split nested struct/union elements as newer ones
> +	my $cont = 1;
> +	while ($cont) {
> +		$cont = 0;


You ignored the remarks I made to v1: 

 this outer loop is not needed!


> +		while ($members =~ m/(struct|union)([^{};]+){([^{}]*)}([^{}\;]*)\;/) {


The inner loop is enough.

> +			my $newmember = "$1 $4;";
> +			my $id = $4;


> Am 26.09.2017 um 21:16 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> 
>> This won't work if  you have e.g.
>> 
>>  union car {int foo;} bar1, bar2, *bbar3;
>> 
>> where $id will be "bar1, bar2, *bbar3", you need to split
>> this string and iterate over the id's.
> 
> That's true, if we have cases like that. I hope not!

We have! I can't remember where, but I hit such constructs while
parsing the whole sources.

> 
> Seriously, in the above case, the developer should very likely declare
> the union outside the main struct and have its own kernel-doc markup.
> 
> My personal taste would be to not explicitly support the above. If it
> hits some code, try to argue with the developer first, before patching
> kernel-doc to such weird stuff.

Why is it wired? Anyway we have it and this kernel-doc fails with.

It also fails with bit types e.g.

       struct {
	    __u8 arg1 : 1;
	    __u8 arg2 : 3;
       };


May it help, if you inspect the py-version of this loop:

   https://github.com/return42/linuxdoc/blob/master/linuxdoc/kernel_doc.py#L2499


> +			my $content = $3;
> +			$id =~ s/[:\[].*//;
> +			$id =~ s/^\*+//;
> +			foreach my $arg (split /;/, $content) {
> +				next if ($arg =~ m/^\s*$/);
> +				my $type = $arg;
> +				my $name = $arg;
> +				$type =~ s/\s\S+$//;
> +				$name =~ s/.*\s//;
> +				$name =~ s/[:\[].*//;
> +				$name =~ s/^\*+//;
> +				next if (($name =~ m/^\s*$/));
> +				if ($id =~ m/^\s*$/) {
> +					# anonymous struct/union
> +					$newmember .= "$type $name;";
> +				} else {
> +					$newmember .= "$type $id.$name;";
> +				}
> +			}
> +			$members =~ s/(struct|union)([^{};]+){([^{}]*)}([^{}\;]*)\;/$newmember/;
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
> +	$declaration =~ s/([{;])/$1\n/g;
> +	$declaration =~ s/}\s+;/};/g;
> +	# Better handle inlined enums
> +	do {} while ($declaration =~ s/(enum\s+{[^}]+),([^\n])/$1,\n$2/);
> +
> +	my @def_args = split /\n/, $declaration;
> +	my $level = 1;
> +	$declaration = "";
> +	foreach my $clause (@def_args) {
> +		$clause =~ s/^\s+//;
> +		$clause =~ s/\s+$//;
> +		$clause =~ s/\s+/ /;
> +		next if (!$clause);
> +		$level-- if ($clause =~ m/(})/ && $level > 1);
> +		if (!($clause =~ m/^\s*#/)) {
> +			$declaration .= "\t" x $level;
> +		}
> +		$declaration .= "\t" . $clause . "\n";
> +		$level++ if ($clause =~ m/({)/ && !($clause =~m/}/));
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


-- Markus --


[1] https://www.emacswiki.org/emacs/TabsAreEvil


---

/* parse-SNIP: my_struct */
/**
* struct my_struct - a struct with nested unions and structs
* @arg1: first argument of anonymous union/anonymous struct
* @arg2: second argument of anonymous union/anonymous struct
* @arg3: third argument of anonymous union/anonymous struct
* @arg4: fourth argument of anonymous union/anonymous struct
* @bar.st1.arg1: first argument of struct st1 on union bar
* @bar.st1.arg2: second argument of struct st1 on union bar
* @bar.st2.arg1: first argument of struct st2 on union bar
* @bar.st2.arg2: second argument of struct st2 on union bar
* @bar.st3.arg2: second argument of struct st3 on union bar
*/
struct my_struct {
   /* Anonymous union/struct*/
   union {
	struct {
	    __u8 arg1 : 1;
	    __u8 arg2 : 3;
	};
       struct {
           int arg1;
           int arg2;
       };
       struct {
           void *arg3;
           int arg4;
       };
   };
   union {
       struct {
           int arg1;
           int arg2;
       } st1;           /* bar.st1 is undocumented, cause a warning */
       struct {
           void *arg1;  /* bar.st3.arg1 is undocumented, cause a warning */
	    int arg2;
       } st2, st3;
   } bar;               /* bar is undocumented, cause a warning */

   /* private: */
   int undoc_privat;    /* is undocumented but private, no warning */

   /* public: */
   int undoc_public;    /* is undocumented, cause a warning */

};
