Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:55771
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S969609AbdIZR7c (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 13:59:32 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/10] scripts: kernel-doc: get rid of unused output formats
Date: Tue, 26 Sep 2017 14:59:11 -0300
Message-Id: <de8b9f4b394ca349889bfdc467ae33e0ce7939b1.1506448061.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506448061.git.mchehab@s-opensource.com>
References: <cover.1506448061.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506448061.git.mchehab@s-opensource.com>
References: <cover.1506448061.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since there isn't any docbook code anymore upstream,
we can get rid of several output formats:

- docbook/xml, html, html5 and list formats were used by
  the old build system;
- As ReST is text, there's not much sense on outputting
  on a different text format.

After this patch, only man and rst output formats are
supported.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 scripts/kernel-doc | 1182 +---------------------------------------------------
 1 file changed, 4 insertions(+), 1178 deletions(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 9d3eafea58f0..69757ee9db4c 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -51,13 +51,8 @@ The documentation comments are identified by "/**" opening comment mark. See
 Documentation/kernel-doc-nano-HOWTO.txt for the documentation comment syntax.
 
 Output format selection (mutually exclusive):
-  -docbook		Output DocBook format.
-  -html			Output HTML format.
-  -html5		Output HTML5 format.
-  -list			Output symbol list format. This is for use by docproc.
   -man			Output troff manual page format. This is the default.
   -rst			Output reStructuredText format.
-  -text			Output plain text format.
 
 Output selection (mutually exclusive):
   -export		Only output documentation for symbols that have been
@@ -224,84 +219,11 @@ my $type_typedef = '\&(typedef\s*([_\w]+))';
 my $type_union = '\&(union\s*([_\w]+))';
 my $type_member = '\&([_\w]+)(\.|->)([_\w]+)';
 my $type_fallback = '\&([_\w]+)';
-my $type_enum_xml = '\&amp;(enum\s*([_\w]+))';
-my $type_struct_xml = '\&amp;(struct\s*([_\w]+))';
-my $type_typedef_xml = '\&amp;(typedef\s*([_\w]+))';
-my $type_union_xml = '\&amp;(union\s*([_\w]+))';
-my $type_member_xml = '\&amp;([_\w]+)(\.|-\&gt;)([_\w]+)';
-my $type_fallback_xml = '\&amp([_\w]+)';
 my $type_member_func = $type_member . '\(\)';
 
 # Output conversion substitutions.
 #  One for each output format
 
-# these work fairly well
-my @highlights_html = (
-                       [$type_constant, "<i>\$1</i>"],
-                       [$type_constant2, "<i>\$1</i>"],
-                       [$type_func, "<b>\$1</b>"],
-                       [$type_enum_xml, "<i>\$1</i>"],
-                       [$type_struct_xml, "<i>\$1</i>"],
-                       [$type_typedef_xml, "<i>\$1</i>"],
-                       [$type_union_xml, "<i>\$1</i>"],
-                       [$type_env, "<b><i>\$1</i></b>"],
-                       [$type_param, "<tt><b>\$1</b></tt>"],
-                       [$type_member_xml, "<tt><i>\$1</i>\$2\$3</tt>"],
-                       [$type_fallback_xml, "<i>\$1</i>"]
-                      );
-my $local_lt = "\\\\\\\\lt:";
-my $local_gt = "\\\\\\\\gt:";
-my $blankline_html = $local_lt . "p" . $local_gt;	# was "<p>"
-
-# html version 5
-my @highlights_html5 = (
-                        [$type_constant, "<span class=\"const\">\$1</span>"],
-                        [$type_constant2, "<span class=\"const\">\$1</span>"],
-                        [$type_func, "<span class=\"func\">\$1</span>"],
-                        [$type_enum_xml, "<span class=\"enum\">\$1</span>"],
-                        [$type_struct_xml, "<span class=\"struct\">\$1</span>"],
-                        [$type_typedef_xml, "<span class=\"typedef\">\$1</span>"],
-                        [$type_union_xml, "<span class=\"union\">\$1</span>"],
-                        [$type_env, "<span class=\"env\">\$1</span>"],
-                        [$type_param, "<span class=\"param\">\$1</span>]"],
-                        [$type_member_xml, "<span class=\"literal\"><span class=\"struct\">\$1</span>\$2<span class=\"member\">\$3</span></span>"],
-                        [$type_fallback_xml, "<span class=\"struct\">\$1</span>"]
-		       );
-my $blankline_html5 = $local_lt . "br /" . $local_gt;
-
-# XML, docbook format
-my @highlights_xml = (
-                      ["([^=])\\\"([^\\\"<]+)\\\"", "\$1<quote>\$2</quote>"],
-                      [$type_constant, "<constant>\$1</constant>"],
-                      [$type_constant2, "<constant>\$1</constant>"],
-                      [$type_enum_xml, "<type>\$1</type>"],
-                      [$type_struct_xml, "<structname>\$1</structname>"],
-                      [$type_typedef_xml, "<type>\$1</type>"],
-                      [$type_union_xml, "<structname>\$1</structname>"],
-                      [$type_param, "<parameter>\$1</parameter>"],
-                      [$type_func, "<function>\$1</function>"],
-                      [$type_env, "<envar>\$1</envar>"],
-                      [$type_member_xml, "<literal><structname>\$1</structname>\$2<structfield>\$3</structfield></literal>"],
-                      [$type_fallback_xml, "<structname>\$1</structname>"]
-		     );
-my $blankline_xml = $local_lt . "/para" . $local_gt . $local_lt . "para" . $local_gt . "\n";
-
-# gnome, docbook format
-my @highlights_gnome = (
-                        [$type_constant, "<replaceable class=\"option\">\$1</replaceable>"],
-                        [$type_constant2, "<replaceable class=\"option\">\$1</replaceable>"],
-                        [$type_func, "<function>\$1</function>"],
-                        [$type_enum, "<type>\$1</type>"],
-                        [$type_struct, "<structname>\$1</structname>"],
-                        [$type_typedef, "<type>\$1</type>"],
-                        [$type_union, "<structname>\$1</structname>"],
-                        [$type_env, "<envar>\$1</envar>"],
-                        [$type_param, "<parameter>\$1</parameter>" ],
-                        [$type_member, "<literal><structname>\$1</structname>\$2<structfield>\$3</structfield></literal>"],
-                        [$type_fallback, "<structname>\$1</structname>"]
-		       );
-my $blankline_gnome = "</para><para>\n";
-
 # these are pretty rough
 my @highlights_man = (
                       [$type_constant, "\$1"],
@@ -317,21 +239,6 @@ my @highlights_man = (
 		     );
 my $blankline_man = "";
 
-# text-mode
-my @highlights_text = (
-                       [$type_constant, "\$1"],
-                       [$type_constant2, "\$1"],
-                       [$type_func, "\$1"],
-                       [$type_enum, "\$1"],
-                       [$type_struct, "\$1"],
-                       [$type_typedef, "\$1"],
-                       [$type_union, "\$1"],
-                       [$type_param, "\$1"],
-                       [$type_member, "\$1\$2\$3"],
-                       [$type_fallback, "\$1"]
-		      );
-my $blankline_text = "";
-
 # rst-mode
 my @highlights_rst = (
                        [$type_constant, "``\$1``"],
@@ -351,21 +258,6 @@ my @highlights_rst = (
 		      );
 my $blankline_rst = "\n";
 
-# list mode
-my @highlights_list = (
-                       [$type_constant, "\$1"],
-                       [$type_constant2, "\$1"],
-                       [$type_func, "\$1"],
-                       [$type_enum, "\$1"],
-                       [$type_struct, "\$1"],
-                       [$type_typedef, "\$1"],
-                       [$type_union, "\$1"],
-                       [$type_param, "\$1"],
-                       [$type_member, "\$1"],
-                       [$type_fallback, "\$1"]
-		      );
-my $blankline_list = "";
-
 # read arguments
 if ($#ARGV == -1) {
     usage();
@@ -500,38 +392,14 @@ reset_state();
 
 while ($ARGV[0] =~ m/^-(.*)/) {
     my $cmd = shift @ARGV;
-    if ($cmd eq "-html") {
-	$output_mode = "html";
-	@highlights = @highlights_html;
-	$blankline = $blankline_html;
-    } elsif ($cmd eq "-html5") {
-	$output_mode = "html5";
-	@highlights = @highlights_html5;
-	$blankline = $blankline_html5;
-    } elsif ($cmd eq "-man") {
+    if ($cmd eq "-man") {
 	$output_mode = "man";
 	@highlights = @highlights_man;
 	$blankline = $blankline_man;
-    } elsif ($cmd eq "-text") {
-	$output_mode = "text";
-	@highlights = @highlights_text;
-	$blankline = $blankline_text;
     } elsif ($cmd eq "-rst") {
 	$output_mode = "rst";
 	@highlights = @highlights_rst;
 	$blankline = $blankline_rst;
-    } elsif ($cmd eq "-docbook") {
-	$output_mode = "xml";
-	@highlights = @highlights_xml;
-	$blankline = $blankline_xml;
-    } elsif ($cmd eq "-list") {
-	$output_mode = "list";
-	@highlights = @highlights_list;
-	$blankline = $blankline_list;
-    } elsif ($cmd eq "-gnome") {
-	$output_mode = "gnome";
-	@highlights = @highlights_gnome;
-	$blankline = $blankline_gnome;
     } elsif ($cmd eq "-module") { # not needed for XML, inherits from calling document
 	$modulename = shift @ARGV;
     } elsif ($cmd eq "-function") { # to only output specific functions
@@ -667,22 +535,11 @@ sub output_highlight {
 #	confess "output_highlight got called with no args?\n";
 #   }
 
-    if ($output_mode eq "html" || $output_mode eq "html5" ||
-	$output_mode eq "xml") {
-	$contents = local_unescape($contents);
-	# convert data read & converted thru xml_escape() into &xyz; format:
-	$contents =~ s/\\\\\\/\&/g;
-    }
 #   print STDERR "contents b4:$contents\n";
     eval $dohighlight;
     die $@ if $@;
 #   print STDERR "contents af:$contents\n";
 
-#   strip whitespaces when generating html5
-    if ($output_mode eq "html5") {
-	$contents =~ s/^\s+//;
-	$contents =~ s/\s+$//;
-    }
     foreach $line (split "\n", $contents) {
 	if (! $output_preformatted) {
 	    $line =~ s/^\s*//;
@@ -703,817 +560,6 @@ sub output_highlight {
     }
 }
 
-# output sections in html
-sub output_section_html(%) {
-    my %args = %{$_[0]};
-    my $section;
-
-    foreach $section (@{$args{'sectionlist'}}) {
-	print "<h3>$section</h3>\n";
-	print "<blockquote>\n";
-	output_highlight($args{'sections'}{$section});
-	print "</blockquote>\n";
-    }
-}
-
-# output enum in html
-sub output_enum_html(%) {
-    my %args = %{$_[0]};
-    my ($parameter);
-    my $count;
-    print "<h2>enum " . $args{'enum'} . "</h2>\n";
-
-    print "<b>enum " . $args{'enum'} . "</b> {<br>\n";
-    $count = 0;
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	print " <b>" . $parameter . "</b>";
-	if ($count != $#{$args{'parameterlist'}}) {
-	    $count++;
-	    print ",\n";
-	}
-	print "<br>";
-    }
-    print "};<br>\n";
-
-    print "<h3>Constants</h3>\n";
-    print "<dl>\n";
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	print "<dt><b>" . $parameter . "</b>\n";
-	print "<dd>";
-	output_highlight($args{'parameterdescs'}{$parameter});
-    }
-    print "</dl>\n";
-    output_section_html(@_);
-    print "<hr>\n";
-}
-
-# output typedef in html
-sub output_typedef_html(%) {
-    my %args = %{$_[0]};
-    my ($parameter);
-    my $count;
-    print "<h2>typedef " . $args{'typedef'} . "</h2>\n";
-
-    print "<b>typedef " . $args{'typedef'} . "</b>\n";
-    output_section_html(@_);
-    print "<hr>\n";
-}
-
-# output struct in html
-sub output_struct_html(%) {
-    my %args = %{$_[0]};
-    my ($parameter);
-
-    print "<h2>" . $args{'type'} . " " . $args{'struct'} . " - " . $args{'purpose'} . "</h2>\n";
-    print "<b>" . $args{'type'} . " " . $args{'struct'} . "</b> {<br>\n";
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	if ($parameter =~ /^#/) {
-		print "$parameter<br>\n";
-		next;
-	}
-	my $parameter_name = $parameter;
-	$parameter_name =~ s/\[.*//;
-
-	($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
-	$type = $args{'parametertypes'}{$parameter};
-	if ($type =~ m/([^\(]*\(\*)\s*\)\s*\(([^\)]*)\)/) {
-	    # pointer-to-function
-	    print "&nbsp; &nbsp; <i>$1</i><b>$parameter</b>) <i>($2)</i>;<br>\n";
-	} elsif ($type =~ m/^(.*?)\s*(:.*)/) {
-	    # bitfield
-	    print "&nbsp; &nbsp; <i>$1</i> <b>$parameter</b>$2;<br>\n";
-	} else {
-	    print "&nbsp; &nbsp; <i>$type</i> <b>$parameter</b>;<br>\n";
-	}
-    }
-    print "};<br>\n";
-
-    print "<h3>Members</h3>\n";
-    print "<dl>\n";
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	($parameter =~ /^#/) && next;
-
-	my $parameter_name = $parameter;
-	$parameter_name =~ s/\[.*//;
-
-	($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
-	print "<dt><b>" . $parameter . "</b>\n";
-	print "<dd>";
-	output_highlight($args{'parameterdescs'}{$parameter_name});
-    }
-    print "</dl>\n";
-    output_section_html(@_);
-    print "<hr>\n";
-}
-
-# output function in html
-sub output_function_html(%) {
-    my %args = %{$_[0]};
-    my ($parameter, $section);
-    my $count;
-
-    print "<h2>" . $args{'function'} . " - " . $args{'purpose'} . "</h2>\n";
-    print "<i>" . $args{'functiontype'} . "</i>\n";
-    print "<b>" . $args{'function'} . "</b>\n";
-    print "(";
-    $count = 0;
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	$type = $args{'parametertypes'}{$parameter};
-	if ($type =~ m/([^\(]*\(\*)\s*\)\s*\(([^\)]*)\)/) {
-	    # pointer-to-function
-	    print "<i>$1</i><b>$parameter</b>) <i>($2)</i>";
-	} else {
-	    print "<i>" . $type . "</i> <b>" . $parameter . "</b>";
-	}
-	if ($count != $#{$args{'parameterlist'}}) {
-	    $count++;
-	    print ",\n";
-	}
-    }
-    print ")\n";
-
-    print "<h3>Arguments</h3>\n";
-    print "<dl>\n";
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	my $parameter_name = $parameter;
-	$parameter_name =~ s/\[.*//;
-
-	($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
-	print "<dt><b>" . $parameter . "</b>\n";
-	print "<dd>";
-	output_highlight($args{'parameterdescs'}{$parameter_name});
-    }
-    print "</dl>\n";
-    output_section_html(@_);
-    print "<hr>\n";
-}
-
-# output DOC: block header in html
-sub output_blockhead_html(%) {
-    my %args = %{$_[0]};
-    my ($parameter, $section);
-    my $count;
-
-    foreach $section (@{$args{'sectionlist'}}) {
-	print "<h3>$section</h3>\n";
-	print "<ul>\n";
-	output_highlight($args{'sections'}{$section});
-	print "</ul>\n";
-    }
-    print "<hr>\n";
-}
-
-# output sections in html5
-sub output_section_html5(%) {
-    my %args = %{$_[0]};
-    my $section;
-
-    foreach $section (@{$args{'sectionlist'}}) {
-	print "<section>\n";
-	print "<h1>$section</h1>\n";
-	print "<p>\n";
-	output_highlight($args{'sections'}{$section});
-	print "</p>\n";
-	print "</section>\n";
-    }
-}
-
-# output enum in html5
-sub output_enum_html5(%) {
-    my %args = %{$_[0]};
-    my ($parameter);
-    my $count;
-    my $html5id;
-
-    $html5id = $args{'enum'};
-    $html5id =~ s/[^a-zA-Z0-9\-]+/_/g;
-    print "<article class=\"enum\" id=\"enum:". $html5id . "\">";
-    print "<h1>enum " . $args{'enum'} . "</h1>\n";
-    print "<ol class=\"code\">\n";
-    print "<li>";
-    print "<span class=\"keyword\">enum</span> ";
-    print "<span class=\"identifier\">" . $args{'enum'} . "</span> {";
-    print "</li>\n";
-    $count = 0;
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	print "<li class=\"indent\">";
-	print "<span class=\"param\">" . $parameter . "</span>";
-	if ($count != $#{$args{'parameterlist'}}) {
-	    $count++;
-	    print ",";
-	}
-	print "</li>\n";
-    }
-    print "<li>};</li>\n";
-    print "</ol>\n";
-
-    print "<section>\n";
-    print "<h1>Constants</h1>\n";
-    print "<dl>\n";
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	print "<dt>" . $parameter . "</dt>\n";
-	print "<dd>";
-	output_highlight($args{'parameterdescs'}{$parameter});
-	print "</dd>\n";
-    }
-    print "</dl>\n";
-    print "</section>\n";
-    output_section_html5(@_);
-    print "</article>\n";
-}
-
-# output typedef in html5
-sub output_typedef_html5(%) {
-    my %args = %{$_[0]};
-    my ($parameter);
-    my $count;
-    my $html5id;
-
-    $html5id = $args{'typedef'};
-    $html5id =~ s/[^a-zA-Z0-9\-]+/_/g;
-    print "<article class=\"typedef\" id=\"typedef:" . $html5id . "\">\n";
-    print "<h1>typedef " . $args{'typedef'} . "</h1>\n";
-
-    print "<ol class=\"code\">\n";
-    print "<li>";
-    print "<span class=\"keyword\">typedef</span> ";
-    print "<span class=\"identifier\">" . $args{'typedef'} . "</span>";
-    print "</li>\n";
-    print "</ol>\n";
-    output_section_html5(@_);
-    print "</article>\n";
-}
-
-# output struct in html5
-sub output_struct_html5(%) {
-    my %args = %{$_[0]};
-    my ($parameter);
-    my $html5id;
-
-    $html5id = $args{'struct'};
-    $html5id =~ s/[^a-zA-Z0-9\-]+/_/g;
-    print "<article class=\"struct\" id=\"struct:" . $html5id . "\">\n";
-    print "<hgroup>\n";
-    print "<h1>" . $args{'type'} . " " . $args{'struct'} . "</h1>";
-    print "<h2>". $args{'purpose'} . "</h2>\n";
-    print "</hgroup>\n";
-    print "<ol class=\"code\">\n";
-    print "<li>";
-    print "<span class=\"type\">" . $args{'type'} . "</span> ";
-    print "<span class=\"identifier\">" . $args{'struct'} . "</span> {";
-    print "</li>\n";
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	print "<li class=\"indent\">";
-	if ($parameter =~ /^#/) {
-		print "<span class=\"param\">" . $parameter ."</span>\n";
-		print "</li>\n";
-		next;
-	}
-	my $parameter_name = $parameter;
-	$parameter_name =~ s/\[.*//;
-
-	($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
-	$type = $args{'parametertypes'}{$parameter};
-	if ($type =~ m/([^\(]*\(\*)\s*\)\s*\(([^\)]*)\)/) {
-	    # pointer-to-function
-	    print "<span class=\"type\">$1</span> ";
-	    print "<span class=\"param\">$parameter</span>";
-	    print "<span class=\"type\">)</span> ";
-	    print "(<span class=\"args\">$2</span>);";
-	} elsif ($type =~ m/^(.*?)\s*(:.*)/) {
-	    # bitfield
-	    print "<span class=\"type\">$1</span> ";
-	    print "<span class=\"param\">$parameter</span>";
-	    print "<span class=\"bits\">$2</span>;";
-	} else {
-	    print "<span class=\"type\">$type</span> ";
-	    print "<span class=\"param\">$parameter</span>;";
-	}
-	print "</li>\n";
-    }
-    print "<li>};</li>\n";
-    print "</ol>\n";
-
-    print "<section>\n";
-    print "<h1>Members</h1>\n";
-    print "<dl>\n";
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	($parameter =~ /^#/) && next;
-
-	my $parameter_name = $parameter;
-	$parameter_name =~ s/\[.*//;
-
-	($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
-	print "<dt>" . $parameter . "</dt>\n";
-	print "<dd>";
-	output_highlight($args{'parameterdescs'}{$parameter_name});
-	print "</dd>\n";
-    }
-    print "</dl>\n";
-    print "</section>\n";
-    output_section_html5(@_);
-    print "</article>\n";
-}
-
-# output function in html5
-sub output_function_html5(%) {
-    my %args = %{$_[0]};
-    my ($parameter, $section);
-    my $count;
-    my $html5id;
-
-    $html5id = $args{'function'};
-    $html5id =~ s/[^a-zA-Z0-9\-]+/_/g;
-    print "<article class=\"function\" id=\"func:". $html5id . "\">\n";
-    print "<hgroup>\n";
-    print "<h1>" . $args{'function'} . "</h1>";
-    print "<h2>" . $args{'purpose'} . "</h2>\n";
-    print "</hgroup>\n";
-    print "<ol class=\"code\">\n";
-    print "<li>";
-    print "<span class=\"type\">" . $args{'functiontype'} . "</span> ";
-    print "<span class=\"identifier\">" . $args{'function'} . "</span> (";
-    print "</li>";
-    $count = 0;
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	print "<li class=\"indent\">";
-	$type = $args{'parametertypes'}{$parameter};
-	if ($type =~ m/([^\(]*\(\*)\s*\)\s*\(([^\)]*)\)/) {
-	    # pointer-to-function
-	    print "<span class=\"type\">$1</span> ";
-	    print "<span class=\"param\">$parameter</span>";
-	    print "<span class=\"type\">)</span> ";
-	    print "(<span class=\"args\">$2</span>)";
-	} else {
-	    print "<span class=\"type\">$type</span> ";
-	    print "<span class=\"param\">$parameter</span>";
-	}
-	if ($count != $#{$args{'parameterlist'}}) {
-	    $count++;
-	    print ",";
-	}
-	print "</li>\n";
-    }
-    print "<li>)</li>\n";
-    print "</ol>\n";
-
-    print "<section>\n";
-    print "<h1>Arguments</h1>\n";
-    print "<p>\n";
-    print "<dl>\n";
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	my $parameter_name = $parameter;
-	$parameter_name =~ s/\[.*//;
-
-	($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
-	print "<dt>" . $parameter . "</dt>\n";
-	print "<dd>";
-	output_highlight($args{'parameterdescs'}{$parameter_name});
-	print "</dd>\n";
-    }
-    print "</dl>\n";
-    print "</section>\n";
-    output_section_html5(@_);
-    print "</article>\n";
-}
-
-# output DOC: block header in html5
-sub output_blockhead_html5(%) {
-    my %args = %{$_[0]};
-    my ($parameter, $section);
-    my $count;
-    my $html5id;
-
-    foreach $section (@{$args{'sectionlist'}}) {
-	$html5id = $section;
-	$html5id =~ s/[^a-zA-Z0-9\-]+/_/g;
-	print "<article class=\"doc\" id=\"doc:". $html5id . "\">\n";
-	print "<h1>$section</h1>\n";
-	print "<p>\n";
-	output_highlight($args{'sections'}{$section});
-	print "</p>\n";
-    }
-    print "</article>\n";
-}
-
-sub output_section_xml(%) {
-    my %args = %{$_[0]};
-    my $section;
-    # print out each section
-    $lineprefix="   ";
-    foreach $section (@{$args{'sectionlist'}}) {
-	print "<refsect1>\n";
-	print "<title>$section</title>\n";
-	if ($section =~ m/EXAMPLE/i) {
-	    print "<informalexample><programlisting>\n";
-	    $output_preformatted = 1;
-	} else {
-	    print "<para>\n";
-	}
-	output_highlight($args{'sections'}{$section});
-	$output_preformatted = 0;
-	if ($section =~ m/EXAMPLE/i) {
-	    print "</programlisting></informalexample>\n";
-	} else {
-	    print "</para>\n";
-	}
-	print "</refsect1>\n";
-    }
-}
-
-# output function in XML DocBook
-sub output_function_xml(%) {
-    my %args = %{$_[0]};
-    my ($parameter, $section);
-    my $count;
-    my $id;
-
-    $id = "API-" . $args{'function'};
-    $id =~ s/[^A-Za-z0-9]/-/g;
-
-    print "<refentry id=\"$id\">\n";
-    print "<refentryinfo>\n";
-    print " <title>LINUX</title>\n";
-    print " <productname>Kernel Hackers Manual</productname>\n";
-    print " <date>$man_date</date>\n";
-    print "</refentryinfo>\n";
-    print "<refmeta>\n";
-    print " <refentrytitle><phrase>" . $args{'function'} . "</phrase></refentrytitle>\n";
-    print " <manvolnum>9</manvolnum>\n";
-    print " <refmiscinfo class=\"version\">" . $kernelversion . "</refmiscinfo>\n";
-    print "</refmeta>\n";
-    print "<refnamediv>\n";
-    print " <refname>" . $args{'function'} . "</refname>\n";
-    print " <refpurpose>\n";
-    print "  ";
-    output_highlight ($args{'purpose'});
-    print " </refpurpose>\n";
-    print "</refnamediv>\n";
-
-    print "<refsynopsisdiv>\n";
-    print " <title>Synopsis</title>\n";
-    print "  <funcsynopsis><funcprototype>\n";
-    print "   <funcdef>" . $args{'functiontype'} . " ";
-    print "<function>" . $args{'function'} . " </function></funcdef>\n";
-
-    $count = 0;
-    if ($#{$args{'parameterlist'}} >= 0) {
-	foreach $parameter (@{$args{'parameterlist'}}) {
-	    $type = $args{'parametertypes'}{$parameter};
-	    if ($type =~ m/([^\(]*\(\*)\s*\)\s*\(([^\)]*)\)/) {
-		# pointer-to-function
-		print "   <paramdef>$1<parameter>$parameter</parameter>)\n";
-		print "     <funcparams>$2</funcparams></paramdef>\n";
-	    } else {
-		print "   <paramdef>" . $type;
-		print " <parameter>$parameter</parameter></paramdef>\n";
-	    }
-	}
-    } else {
-	print "  <void/>\n";
-    }
-    print "  </funcprototype></funcsynopsis>\n";
-    print "</refsynopsisdiv>\n";
-
-    # print parameters
-    print "<refsect1>\n <title>Arguments</title>\n";
-    if ($#{$args{'parameterlist'}} >= 0) {
-	print " <variablelist>\n";
-	foreach $parameter (@{$args{'parameterlist'}}) {
-	    my $parameter_name = $parameter;
-	    $parameter_name =~ s/\[.*//;
-	    $type = $args{'parametertypes'}{$parameter};
-
-	    print "  <varlistentry>\n   <term><parameter>$type $parameter</parameter></term>\n";
-	    print "   <listitem>\n    <para>\n";
-	    $lineprefix="     ";
-	    output_highlight($args{'parameterdescs'}{$parameter_name});
-	    print "    </para>\n   </listitem>\n  </varlistentry>\n";
-	}
-	print " </variablelist>\n";
-    } else {
-	print " <para>\n  None\n </para>\n";
-    }
-    print "</refsect1>\n";
-
-    output_section_xml(@_);
-    print "</refentry>\n\n";
-}
-
-# output struct in XML DocBook
-sub output_struct_xml(%) {
-    my %args = %{$_[0]};
-    my ($parameter, $section);
-    my $id;
-
-    $id = "API-struct-" . $args{'struct'};
-    $id =~ s/[^A-Za-z0-9]/-/g;
-
-    print "<refentry id=\"$id\">\n";
-    print "<refentryinfo>\n";
-    print " <title>LINUX</title>\n";
-    print " <productname>Kernel Hackers Manual</productname>\n";
-    print " <date>$man_date</date>\n";
-    print "</refentryinfo>\n";
-    print "<refmeta>\n";
-    print " <refentrytitle><phrase>" . $args{'type'} . " " . $args{'struct'} . "</phrase></refentrytitle>\n";
-    print " <manvolnum>9</manvolnum>\n";
-    print " <refmiscinfo class=\"version\">" . $kernelversion . "</refmiscinfo>\n";
-    print "</refmeta>\n";
-    print "<refnamediv>\n";
-    print " <refname>" . $args{'type'} . " " . $args{'struct'} . "</refname>\n";
-    print " <refpurpose>\n";
-    print "  ";
-    output_highlight ($args{'purpose'});
-    print " </refpurpose>\n";
-    print "</refnamediv>\n";
-
-    print "<refsynopsisdiv>\n";
-    print " <title>Synopsis</title>\n";
-    print "  <programlisting>\n";
-    print $args{'type'} . " " . $args{'struct'} . " {\n";
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	if ($parameter =~ /^#/) {
-	    my $prm = $parameter;
-	    # convert data read & converted thru xml_escape() into &xyz; format:
-	    # This allows us to have #define macros interspersed in a struct.
-	    $prm =~ s/\\\\\\/\&/g;
-	    print "$prm\n";
-	    next;
-	}
-
-	my $parameter_name = $parameter;
-	$parameter_name =~ s/\[.*//;
-
-	defined($args{'parameterdescs'}{$parameter_name}) || next;
-	($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
-	$type = $args{'parametertypes'}{$parameter};
-	if ($type =~ m/([^\(]*\(\*)\s*\)\s*\(([^\)]*)\)/) {
-	    # pointer-to-function
-	    print "  $1 $parameter) ($2);\n";
-	} elsif ($type =~ m/^(.*?)\s*(:.*)/) {
-	    # bitfield
-	    print "  $1 $parameter$2;\n";
-	} else {
-	    print "  " . $type . " " . $parameter . ";\n";
-	}
-    }
-    print "};";
-    print "  </programlisting>\n";
-    print "</refsynopsisdiv>\n";
-
-    print " <refsect1>\n";
-    print "  <title>Members</title>\n";
-
-    if ($#{$args{'parameterlist'}} >= 0) {
-    print "  <variablelist>\n";
-    foreach $parameter (@{$args{'parameterlist'}}) {
-      ($parameter =~ /^#/) && next;
-
-      my $parameter_name = $parameter;
-      $parameter_name =~ s/\[.*//;
-
-      defined($args{'parameterdescs'}{$parameter_name}) || next;
-      ($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
-      $type = $args{'parametertypes'}{$parameter};
-      print "    <varlistentry>";
-      print "      <term><literal>$type $parameter</literal></term>\n";
-      print "      <listitem><para>\n";
-      output_highlight($args{'parameterdescs'}{$parameter_name});
-      print "      </para></listitem>\n";
-      print "    </varlistentry>\n";
-    }
-    print "  </variablelist>\n";
-    } else {
-	print " <para>\n  None\n </para>\n";
-    }
-    print " </refsect1>\n";
-
-    output_section_xml(@_);
-
-    print "</refentry>\n\n";
-}
-
-# output enum in XML DocBook
-sub output_enum_xml(%) {
-    my %args = %{$_[0]};
-    my ($parameter, $section);
-    my $count;
-    my $id;
-
-    $id = "API-enum-" . $args{'enum'};
-    $id =~ s/[^A-Za-z0-9]/-/g;
-
-    print "<refentry id=\"$id\">\n";
-    print "<refentryinfo>\n";
-    print " <title>LINUX</title>\n";
-    print " <productname>Kernel Hackers Manual</productname>\n";
-    print " <date>$man_date</date>\n";
-    print "</refentryinfo>\n";
-    print "<refmeta>\n";
-    print " <refentrytitle><phrase>enum " . $args{'enum'} . "</phrase></refentrytitle>\n";
-    print " <manvolnum>9</manvolnum>\n";
-    print " <refmiscinfo class=\"version\">" . $kernelversion . "</refmiscinfo>\n";
-    print "</refmeta>\n";
-    print "<refnamediv>\n";
-    print " <refname>enum " . $args{'enum'} . "</refname>\n";
-    print " <refpurpose>\n";
-    print "  ";
-    output_highlight ($args{'purpose'});
-    print " </refpurpose>\n";
-    print "</refnamediv>\n";
-
-    print "<refsynopsisdiv>\n";
-    print " <title>Synopsis</title>\n";
-    print "  <programlisting>\n";
-    print "enum " . $args{'enum'} . " {\n";
-    $count = 0;
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	print "  $parameter";
-	if ($count != $#{$args{'parameterlist'}}) {
-	    $count++;
-	    print ",";
-	}
-	print "\n";
-    }
-    print "};";
-    print "  </programlisting>\n";
-    print "</refsynopsisdiv>\n";
-
-    print "<refsect1>\n";
-    print " <title>Constants</title>\n";
-    print "  <variablelist>\n";
-    foreach $parameter (@{$args{'parameterlist'}}) {
-      my $parameter_name = $parameter;
-      $parameter_name =~ s/\[.*//;
-
-      print "    <varlistentry>";
-      print "      <term>$parameter</term>\n";
-      print "      <listitem><para>\n";
-      output_highlight($args{'parameterdescs'}{$parameter_name});
-      print "      </para></listitem>\n";
-      print "    </varlistentry>\n";
-    }
-    print "  </variablelist>\n";
-    print "</refsect1>\n";
-
-    output_section_xml(@_);
-
-    print "</refentry>\n\n";
-}
-
-# output typedef in XML DocBook
-sub output_typedef_xml(%) {
-    my %args = %{$_[0]};
-    my ($parameter, $section);
-    my $id;
-
-    $id = "API-typedef-" . $args{'typedef'};
-    $id =~ s/[^A-Za-z0-9]/-/g;
-
-    print "<refentry id=\"$id\">\n";
-    print "<refentryinfo>\n";
-    print " <title>LINUX</title>\n";
-    print " <productname>Kernel Hackers Manual</productname>\n";
-    print " <date>$man_date</date>\n";
-    print "</refentryinfo>\n";
-    print "<refmeta>\n";
-    print " <refentrytitle><phrase>typedef " . $args{'typedef'} . "</phrase></refentrytitle>\n";
-    print " <manvolnum>9</manvolnum>\n";
-    print "</refmeta>\n";
-    print "<refnamediv>\n";
-    print " <refname>typedef " . $args{'typedef'} . "</refname>\n";
-    print " <refpurpose>\n";
-    print "  ";
-    output_highlight ($args{'purpose'});
-    print " </refpurpose>\n";
-    print "</refnamediv>\n";
-
-    print "<refsynopsisdiv>\n";
-    print " <title>Synopsis</title>\n";
-    print "  <synopsis>typedef " . $args{'typedef'} . ";</synopsis>\n";
-    print "</refsynopsisdiv>\n";
-
-    output_section_xml(@_);
-
-    print "</refentry>\n\n";
-}
-
-# output in XML DocBook
-sub output_blockhead_xml(%) {
-    my %args = %{$_[0]};
-    my ($parameter, $section);
-    my $count;
-
-    my $id = $args{'module'};
-    $id =~ s/[^A-Za-z0-9]/-/g;
-
-    # print out each section
-    $lineprefix="   ";
-    foreach $section (@{$args{'sectionlist'}}) {
-	if (!$args{'content-only'}) {
-		print "<refsect1>\n <title>$section</title>\n";
-	}
-	if ($section =~ m/EXAMPLE/i) {
-	    print "<example><para>\n";
-	    $output_preformatted = 1;
-	} else {
-	    print "<para>\n";
-	}
-	output_highlight($args{'sections'}{$section});
-	$output_preformatted = 0;
-	if ($section =~ m/EXAMPLE/i) {
-	    print "</para></example>\n";
-	} else {
-	    print "</para>";
-	}
-	if (!$args{'content-only'}) {
-		print "\n</refsect1>\n";
-	}
-    }
-
-    print "\n\n";
-}
-
-# output in XML DocBook
-sub output_function_gnome {
-    my %args = %{$_[0]};
-    my ($parameter, $section);
-    my $count;
-    my $id;
-
-    $id = $args{'module'} . "-" . $args{'function'};
-    $id =~ s/[^A-Za-z0-9]/-/g;
-
-    print "<sect2>\n";
-    print " <title id=\"$id\">" . $args{'function'} . "</title>\n";
-
-    print "  <funcsynopsis>\n";
-    print "   <funcdef>" . $args{'functiontype'} . " ";
-    print "<function>" . $args{'function'} . " ";
-    print "</function></funcdef>\n";
-
-    $count = 0;
-    if ($#{$args{'parameterlist'}} >= 0) {
-	foreach $parameter (@{$args{'parameterlist'}}) {
-	    $type = $args{'parametertypes'}{$parameter};
-	    if ($type =~ m/([^\(]*\(\*)\s*\)\s*\(([^\)]*)\)/) {
-		# pointer-to-function
-		print "   <paramdef>$1 <parameter>$parameter</parameter>)\n";
-		print "     <funcparams>$2</funcparams></paramdef>\n";
-	    } else {
-		print "   <paramdef>" . $type;
-		print " <parameter>$parameter</parameter></paramdef>\n";
-	    }
-	}
-    } else {
-	print "  <void>\n";
-    }
-    print "  </funcsynopsis>\n";
-    if ($#{$args{'parameterlist'}} >= 0) {
-	print " <informaltable pgwide=\"1\" frame=\"none\" role=\"params\">\n";
-	print "<tgroup cols=\"2\">\n";
-	print "<colspec colwidth=\"2*\">\n";
-	print "<colspec colwidth=\"8*\">\n";
-	print "<tbody>\n";
-	foreach $parameter (@{$args{'parameterlist'}}) {
-	    my $parameter_name = $parameter;
-	    $parameter_name =~ s/\[.*//;
-
-	    print "  <row><entry align=\"right\"><parameter>$parameter</parameter></entry>\n";
-	    print "   <entry>\n";
-	    $lineprefix="     ";
-	    output_highlight($args{'parameterdescs'}{$parameter_name});
-	    print "    </entry></row>\n";
-	}
-	print " </tbody></tgroup></informaltable>\n";
-    } else {
-	print " <para>\n  None\n </para>\n";
-    }
-
-    # print out each section
-    $lineprefix="   ";
-    foreach $section (@{$args{'sectionlist'}}) {
-	print "<simplesect>\n <title>$section</title>\n";
-	if ($section =~ m/EXAMPLE/i) {
-	    print "<example><programlisting>\n";
-	    $output_preformatted = 1;
-	} else {
-	}
-	print "<para>\n";
-	output_highlight($args{'sections'}{$section});
-	$output_preformatted = 0;
-	print "</para>\n";
-	if ($section =~ m/EXAMPLE/i) {
-	    print "</programlisting></example>\n";
-	} else {
-	}
-	print " </simplesect>\n";
-    }
-
-    print "</sect2>\n\n";
-}
-
 ##
 # output function in man
 sub output_function_man(%) {
@@ -1692,161 +738,6 @@ sub output_blockhead_man(%) {
 }
 
 ##
-# output in text
-sub output_function_text(%) {
-    my %args = %{$_[0]};
-    my ($parameter, $section);
-    my $start;
-
-    print "Name:\n\n";
-    print $args{'function'} . " - " . $args{'purpose'} . "\n";
-
-    print "\nSynopsis:\n\n";
-    if ($args{'functiontype'} ne "") {
-	$start = $args{'functiontype'} . " " . $args{'function'} . " (";
-    } else {
-	$start = $args{'function'} . " (";
-    }
-    print $start;
-
-    my $count = 0;
-    foreach my $parameter (@{$args{'parameterlist'}}) {
-	$type = $args{'parametertypes'}{$parameter};
-	if ($type =~ m/([^\(]*\(\*)\s*\)\s*\(([^\)]*)\)/) {
-	    # pointer-to-function
-	    print $1 . $parameter . ") (" . $2;
-	} else {
-	    print $type . " " . $parameter;
-	}
-	if ($count != $#{$args{'parameterlist'}}) {
-	    $count++;
-	    print ",\n";
-	    print " " x length($start);
-	} else {
-	    print ");\n\n";
-	}
-    }
-
-    print "Arguments:\n\n";
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	my $parameter_name = $parameter;
-	$parameter_name =~ s/\[.*//;
-
-	print $parameter . "\n\t" . $args{'parameterdescs'}{$parameter_name} . "\n";
-    }
-    output_section_text(@_);
-}
-
-#output sections in text
-sub output_section_text(%) {
-    my %args = %{$_[0]};
-    my $section;
-
-    print "\n";
-    foreach $section (@{$args{'sectionlist'}}) {
-	print "$section:\n\n";
-	output_highlight($args{'sections'}{$section});
-    }
-    print "\n\n";
-}
-
-# output enum in text
-sub output_enum_text(%) {
-    my %args = %{$_[0]};
-    my ($parameter);
-    my $count;
-    print "Enum:\n\n";
-
-    print "enum " . $args{'enum'} . " - " . $args{'purpose'} . "\n\n";
-    print "enum " . $args{'enum'} . " {\n";
-    $count = 0;
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	print "\t$parameter";
-	if ($count != $#{$args{'parameterlist'}}) {
-	    $count++;
-	    print ",";
-	}
-	print "\n";
-    }
-    print "};\n\n";
-
-    print "Constants:\n\n";
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	print "$parameter\n\t";
-	print $args{'parameterdescs'}{$parameter} . "\n";
-    }
-
-    output_section_text(@_);
-}
-
-# output typedef in text
-sub output_typedef_text(%) {
-    my %args = %{$_[0]};
-    my ($parameter);
-    my $count;
-    print "Typedef:\n\n";
-
-    print "typedef " . $args{'typedef'} . " - " . $args{'purpose'} . "\n";
-    output_section_text(@_);
-}
-
-# output struct as text
-sub output_struct_text(%) {
-    my %args = %{$_[0]};
-    my ($parameter);
-
-    print $args{'type'} . " " . $args{'struct'} . " - " . $args{'purpose'} . "\n\n";
-    print $args{'type'} . " " . $args{'struct'} . " {\n";
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	if ($parameter =~ /^#/) {
-	    print "$parameter\n";
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
-	    print "\t$1 $parameter) ($2);\n";
-	} elsif ($type =~ m/^(.*?)\s*(:.*)/) {
-	    # bitfield
-	    print "\t$1 $parameter$2;\n";
-	} else {
-	    print "\t" . $type . " " . $parameter . ";\n";
-	}
-    }
-    print "};\n\n";
-
-    print "Members:\n\n";
-    foreach $parameter (@{$args{'parameterlist'}}) {
-	($parameter =~ /^#/) && next;
-
-	my $parameter_name = $parameter;
-	$parameter_name =~ s/\[.*//;
-
-	($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
-	print "$parameter\n\t";
-	print $args{'parameterdescs'}{$parameter_name} . "\n";
-    }
-    print "\n";
-    output_section_text(@_);
-}
-
-sub output_blockhead_text(%) {
-    my %args = %{$_[0]};
-    my ($parameter, $section);
-
-    foreach $section (@{$args{'sectionlist'}}) {
-	print " $section:\n";
-	print "    -> ";
-	output_highlight($args{'sections'}{$section});
-    }
-}
-
-##
 # output in restructured text
 #
 
@@ -2080,43 +971,6 @@ sub output_struct_rst(%) {
     output_section_rst(@_);
 }
 
-
-## list mode output functions
-
-sub output_function_list(%) {
-    my %args = %{$_[0]};
-
-    print $args{'function'} . "\n";
-}
-
-# output enum in list
-sub output_enum_list(%) {
-    my %args = %{$_[0]};
-    print $args{'enum'} . "\n";
-}
-
-# output typedef in list
-sub output_typedef_list(%) {
-    my %args = %{$_[0]};
-    print $args{'typedef'} . "\n";
-}
-
-# output struct as list
-sub output_struct_list(%) {
-    my %args = %{$_[0]};
-
-    print $args{'struct'} . "\n";
-}
-
-sub output_blockhead_list(%) {
-    my %args = %{$_[0]};
-    my ($parameter, $section);
-
-    foreach $section (@{$args{'sectionlist'}}) {
-	print "DOC: $section\n";
-    }
-}
-
 ##
 # generic output function for all types (function, struct/union, typedef, enum);
 # calls the generated, variable output_ function name based on
@@ -2795,7 +1649,7 @@ sub process_proto_type($$) {
 # just before actual output; (this is done by local_unescape())
 sub xml_escape($) {
 	my $text = shift;
-	if (($output_mode eq "text") || ($output_mode eq "man")) {
+	if ($output_mode eq "man") {
 		return $text;
 	}
 	$text =~ s/\&/\\\\\\amp;/g;
@@ -2807,7 +1661,7 @@ sub xml_escape($) {
 # xml_unescape: reverse the effects of xml_escape
 sub xml_unescape($) {
 	my $text = shift;
-	if (($output_mode eq "text") || ($output_mode eq "man")) {
+	if ($output_mode eq "man") {
 		return $text;
 	}
 	$text =~ s/\\\\\\amp;/\&/g;
@@ -2820,7 +1674,7 @@ sub xml_unescape($) {
 # local escape strings look like:  '\\\\menmonic:' (that's 4 backslashes)
 sub local_unescape($) {
 	my $text = shift;
-	if (($output_mode eq "text") || ($output_mode eq "man")) {
+	if ($output_mode eq "man") {
 		return $text;
 	}
 	$text =~ s/\\\\\\\\lt:/</g;
@@ -3140,34 +1994,6 @@ sub process_file($) {
 	if (($output_selection == OUTPUT_INCLUDE) && ($show_not_found == 1)) {
 	    print STDERR "    Was looking for '$_'.\n" for keys %function_table;
 	}
-	if ($output_mode eq "xml") {
-	    # The template wants at least one RefEntry here; make one.
-	    print "<refentry>\n";
-	    print " <refnamediv>\n";
-	    print "  <refname>\n";
-	    print "   ${orig_file}\n";
-	    print "  </refname>\n";
-	    print "  <refpurpose>\n";
-	    print "   Document generation inconsistency\n";
-	    print "  </refpurpose>\n";
-	    print " </refnamediv>\n";
-	    print " <refsect1>\n";
-	    print "  <title>\n";
-	    print "   Oops\n";
-	    print "  </title>\n";
-	    print "  <warning>\n";
-	    print "   <para>\n";
-	    print "    The template for this document tried to insert\n";
-	    print "    the structured comment from the file\n";
-	    print "    <filename>${orig_file}</filename> at this point,\n";
-	    print "    but none was found.\n";
-	    print "    This dummy section is inserted to allow\n";
-	    print "    generation to continue.\n";
-	    print "   </para>\n";
-	    print "  </warning>\n";
-	    print " </refsect1>\n";
-	    print "</refentry>\n";
-	}
     }
 }
 
-- 
2.13.5
