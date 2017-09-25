Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:44925
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S964892AbdIYSW1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Sep 2017 14:22:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-doc@vger.kernel.org,
        Markus Heiser <markus.heiser@darmarit.de>
Subject: [PATCH] scripts: kernel-doc: parse next structs/unions
Date: Mon, 25 Sep 2017 15:22:20 -0300
Message-Id: <3eff4e45c88ce0d5449d5794cf3019898c2a16bc.1506363302.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several places within the Kernel tree with nested
structs/unions, like this one:

  struct ingenic_cgu_clk_info {
    const char *name;
    enum {
      CGU_CLK_NONE = 0,
      CGU_CLK_EXT = BIT(0),
      CGU_CLK_PLL = BIT(1),
      CGU_CLK_GATE = BIT(2),
      CGU_CLK_MUX = BIT(3),
      CGU_CLK_MUX_GLITCHFREE = BIT(4),
      CGU_CLK_DIV = BIT(5),
      CGU_CLK_FIXDIV = BIT(6),
      CGU_CLK_CUSTOM = BIT(7),
    } type;
    int parents[4];
    union {
      struct ingenic_cgu_pll_info pll;
      struct {
        struct ingenic_cgu_gate_info gate;
        struct ingenic_cgu_mux_info mux;
        struct ingenic_cgu_div_info div;
        struct ingenic_cgu_fixdiv_info fixdiv;
      };
      struct ingenic_cgu_custom_info custom;
    };
  };

Currently, such struct is documented as:

	**Definition**

	::
	struct ingenic_cgu_clk_info {
	    const char * name;
	};

	**Members**

	``name``
	  name of the clock

With is obvioulsy wrong. It also generates an error:
	drivers/clk/ingenic/cgu.h:169: warning: No description found for parameter 'enum'

However, there's nothing wrong with this kernel-doc markup: everything
is documented there.

It makes sense to document all fields there. So, add a
way for the core to parse those structs.

With this patch, all documented fields will properly generate
documentation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---

Jon,

Please let me know what you think about this approach. IMHO, it is a way
better than what we do right now. This is more a proof of concept, as the
patch is not complete. 

With it, we can now document both anonymous and named unions/structs.

For named structs, the name of the fields should be in the format:
	foo.bar

What's missing on this PoC:

1) I didn't check if @foo.bar: would work, though.  Probably the parser
   for it should be added to allow this new syntax.

2) I only changed the ReST output to preserve the struct format with
   nested fields. 

For (2), I'm thinking is we should still have all those output formats for
kernel-doc. IMHO, I would keep just RST (and perhaps man - while we don't
have a "make man" targed working.

Depending on your comments, I'll proceed addressing (1) and (2)
and doing more tests with it.



 scripts/kernel-doc | 83 +++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 54 insertions(+), 29 deletions(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 9d3eafea58f0..5ca81b879088 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -2035,29 +2035,9 @@ sub output_struct_rst(%) {
 
     print "**Definition**\n\n";
     print "::\n\n";
-    print "  " . $args{'type'} . " " . $args{'struct'} . " {\n";
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	if ($parameter =~ /^#/) {
-	    print "  " . "$parameter\n";
-	    next;
-	}
-
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
-    }
-    print "  };\n\n";
+    my $declaration = $args{'definition'};
+    $declaration =~ s/\t/  /g;
+    print "  " . $args{'type'} . " " . $args{'struct'} . " {\n$declaration  };\n\n";
 
     print "**Members**\n\n";
     $lineprefix = "  ";
@@ -2168,20 +2148,15 @@ sub dump_struct($$) {
     my $nested;
 
     if ($x =~ /(struct|union)\s+(\w+)\s*{(.*)}/) {
-	#my $decl_type = $1;
+	my $decl_type = $1;
 	$declaration_name = $2;
 	my $members = $3;
 
-	# ignore embedded structs or unions
-	$members =~ s/({.*})//g;
-	$nested = $1;
-
 	# ignore members marked private:
 	$members =~ s/\/\*\s*private:.*?\/\*\s*public:.*?\*\///gosi;
 	$members =~ s/\/\*\s*private:.*//gosi;
 	# strip comments:
 	$members =~ s/\/\*.*?\*\///gos;
-	$nested =~ s/\/\*.*?\*\///gos;
 	# strip kmemcheck_bitfield_{begin,end}.*;
 	$members =~ s/kmemcheck_bitfield_.*?;//gos;
 	# strip attributes
@@ -2193,13 +2168,63 @@ sub dump_struct($$) {
 	# replace DECLARE_HASHTABLE
 	$members =~ s/DECLARE_HASHTABLE\s*\(([^,)]+), ([^,)]+)\)/unsigned long $1\[1 << (($2) - 1)\]/gos;
 
+	my $declaration = $members;
+
+	# Split nested struct/union elements as newer ones
+	my $cont = 1;
+	while ($cont) {
+		$cont = 0;
+		while ($members =~ m/(struct|union)([^{};]+){([^{}]*)}([^{}\;]*)\;/) {
+			my $newmember = "$1 $4;";
+			my $id = $4;
+			my $content = $3;
+			$id =~ s/[:\[].*//;
+			foreach my $arg (split /;/, $content) {
+				next if ($arg =~ m/^\s*$/);
+				my $type = $arg;
+				my $name = $arg;
+				$type =~ s/\s\S+$//;
+				$name =~ s/.*\s//;
+				next if (($name =~ m/^\s*$/));
+				if ($id =~ m/^\s*$/) {
+					# anonymous struct/union
+					$newmember .= "$type $name;";
+				} else {
+					$newmember .= "$type $id.$name;";
+				}
+			}
+			$members =~ s/(struct|union)([^{};]+){([^{}]*)}([^{}\;]*)\;/$newmember/;
+			$cont = 1;
+		};
+	};
+
+	# Ignore other nested elements, like enums
+	$members =~ s/({[^\{\}]*})//g;
+	$nested = $decl_type;
+	$nested =~ s/\/\*.*?\*\///gos;
+
 	create_parameterlist($members, ';', $file);
 	check_sections($file, $declaration_name, "struct", $sectcheck, $struct_actual, $nested);
 
+	# Adjust declaration for better display
+	$declaration =~ s/([{,;])/$1\n/g;
+	$declaration =~ s/}\s+;/};/g;
+	my @def_args = split /\n/, $declaration;
+	my $level = 2;
+	$declaration = "";
+	foreach my $clause (@def_args) {
+		$clause =~ s/^\s+//;
+		$clause =~ s/\s+$//;
+		$clause =~ s/\s+/ /;
+		$level-- if ($clause =~ m/}/ && $level > 2);
+		$declaration .= "\t" x $level . $clause . "\n" if ($clause);
+		$level++ if ($clause =~ m/{/);
+	}
 	output_declaration($declaration_name,
 			   'struct',
 			   {'struct' => $declaration_name,
 			    'module' => $modulename,
+			    'definition' => $declaration,
 			    'parameterlist' => \@parameterlist,
 			    'parameterdescs' => \%parameterdescs,
 			    'parametertypes' => \%parametertypes,
-- 
2.13.5
