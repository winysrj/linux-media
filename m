Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:32960
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751985AbdI0VKd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 17:10:33 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH v2 09/13] scripts: kernel-doc: parse next structs/unions
Date: Wed, 27 Sep 2017 18:10:20 -0300
Message-Id: <b2528c4f1d2e76b7dacde8c5660e94de32e2eb71.1506546492.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506546492.git.mchehab@s-opensource.com>
References: <cover.1506546492.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506546492.git.mchehab@s-opensource.com>
References: <cover.1506546492.git.mchehab@s-opensource.com>
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
 Documentation/doc-guide/kernel-doc.rst |  46 ++++++++++++
 scripts/kernel-doc                     | 123 ++++++++++++++++++---------------
 2 files changed, 115 insertions(+), 54 deletions(-)

diff --git a/Documentation/doc-guide/kernel-doc.rst b/Documentation/doc-guide/kernel-doc.rst
index 96012f9e314d..9e63a18cceea 100644
--- a/Documentation/doc-guide/kernel-doc.rst
+++ b/Documentation/doc-guide/kernel-doc.rst
@@ -281,6 +281,52 @@ comment block.
 The kernel-doc data structure comments describe each member of the structure,
 in order, with the member descriptions.
 
+Nested structs/unions
+~~~~~~~~~~~~~~~~~~~~~
+
+It is possible to document nested structs unions, like::
+
+      /**
+       * struct nested_foobar - a struct with nested unions and structs
+       * @arg1: - first argument of anonymous union/anonymous struct
+       * @arg2: - second argument of anonymous union/anonymous struct
+       * @arg3: - third argument of anonymous union/anonymous struct
+       * @arg4: - fourth argument of anonymous union/anonymous struct
+       * @bar.st1.arg1 - first argument of struct st1 on union bar
+       * @bar.st1.arg2 - second argument of struct st1 on union bar
+       * @bar.st2.arg1 - first argument of struct st2 on union bar
+       * @bar.st2.arg2 - second argument of struct st2 on union bar
+      struct nested_foobar {
+        /* Anonymous union/struct*/
+        union {
+          struct {
+            int arg1;
+            int arg2;
+	  }
+          struct {
+            void *arg3;
+            int arg4;
+	  }
+	}
+	union {
+          struct {
+            int arg1;
+            int arg2;
+	  } st1;
+          struct {
+            void *arg1;
+            int arg2;
+	  } st2;
+	} bar;
+      };
+
+.. note::
+
+   #) When documenting nested structs or unions, if the struct/union ``foo``
+      is named, the argument ``bar`` inside it should be documented as
+      ``@foo.bar:``
+   #) When the nested struct/union is anonymous, the argument ``bar`` on it
+      should be documented as ``@bar:``
 
 Typedef documentation
 ---------------------
diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index b6f3f6962897..63aa9f85d635 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -210,7 +210,7 @@ my $anon_struct_union = 0;
 my $type_constant = '\b``([^\`]+)``\b';
 my $type_constant2 = '\%([-_\w]+)';
 my $type_func = '(\w+)\(\)';
-my $type_param = '\@(\w+(\.\.\.)?)';
+my $type_param = '\@(\w*(\.\w+)*(\.\.\.)?)';
 my $type_fp_param = '\@(\w+)\(\)';  # Special RST handling for func ptr params
 my $type_env = '(\$\w+)';
 my $type_enum = '\&(enum\s*([_\w]+))';
@@ -663,32 +663,12 @@ sub output_struct_man(%) {
     print ".SH NAME\n";
     print $args{'type'} . " " . $args{'struct'} . " \\- " . $args{'purpose'} . "\n";
 
+    my $declaration = $args{'definition'};
+    $declaration =~ s/\t/  /g;
+    $declaration =~ s/\n/"\n.br\n.BI \"/g;
     print ".SH SYNOPSIS\n";
     print $args{'type'} . " " . $args{'struct'} . " {\n.br\n";
-
-    foreach my $parameter (@{$args{'parameterlist'}}) {
-	if ($parameter =~ /^#/) {
-	    print ".BI \"$parameter\"\n.br\n";
-	    next;
-	}
-	my $parameter_name = $parameter;
-	$parameter_name =~ s/\[.*//;
-
-	($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
-	$type = $args{'parametertypes'}{$parameter};
-	if ($type =~ m/([^\(]*\(\*)\s*\)\s*\(([^\)]*)\)/) {
-	    # pointer-to-function
-	    print ".BI \"    " . $1 . "\" " . $parameter . " \") (" . $2 . ")" . "\"\n;\n";
-	} elsif ($type =~ m/^(.*?)\s*(:.*)/) {
-	    # bitfield
-	    print ".BI \"    " . $1 . "\ \" " . $parameter . $2 . " \"" . "\"\n;\n";
-	} else {
-	    $type =~ s/([^\*])$/$1 /;
-	    print ".BI \"    " . $type . "\" " . $parameter . " \"" . "\"\n;\n";
-	}
-	print "\n.br\n";
-    }
-    print "};\n.br\n";
+    print ".BI \"$declaration\n};\n.br\n\n";
 
     print ".SH Members\n";
     foreach $parameter (@{$args{'parameterlist'}}) {
@@ -926,29 +906,9 @@ sub output_struct_rst(%) {
 
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
@@ -1022,20 +982,15 @@ sub dump_struct($$) {
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
@@ -1047,13 +1002,73 @@ sub dump_struct($$) {
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
+			$id =~ s/^\*+//;
+			foreach my $arg (split /;/, $content) {
+				next if ($arg =~ m/^\s*$/);
+				my $type = $arg;
+				my $name = $arg;
+				$type =~ s/\s\S+$//;
+				$name =~ s/.*\s//;
+				$name =~ s/[:\[].*//;
+				$name =~ s/^\*+//;
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
+	$declaration =~ s/([{;])/$1\n/g;
+	$declaration =~ s/}\s+;/};/g;
+	# Better handle inlined enums
+	do {} while ($declaration =~ s/(enum\s+{[^}]+),([^\n])/$1,\n$2/);
+
+	my @def_args = split /\n/, $declaration;
+	my $level = 1;
+	$declaration = "";
+	foreach my $clause (@def_args) {
+		$clause =~ s/^\s+//;
+		$clause =~ s/\s+$//;
+		$clause =~ s/\s+/ /;
+		next if (!$clause);
+		$level-- if ($clause =~ m/(})/ && $level > 1);
+		if (!($clause =~ m/^\s*#/)) {
+			$declaration .= "\t" x $level;
+		}
+		$declaration .= "\t" . $clause . "\n";
+		$level++ if ($clause =~ m/({)/ && !($clause =~m/}/));
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
