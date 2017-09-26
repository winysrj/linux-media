Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:55749
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S969491AbdIZR72 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 13:59:28 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/10] docs: get rid of kernel-doc-nano-HOWTO.txt
Date: Tue, 26 Sep 2017 14:59:18 -0300
Message-Id: <8f89a9ad3fa730402fcaaa2ae17f4073630647fb.1506448061.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506448061.git.mchehab@s-opensource.com>
References: <cover.1506448061.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506448061.git.mchehab@s-opensource.com>
References: <cover.1506448061.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Everything there is already described at
Documentation/doc-guide/kernel-doc.rst. So, there's no reason why
to keep it anymore.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/00-INDEX                  |   2 -
 Documentation/kernel-doc-nano-HOWTO.txt | 322 --------------------------------
 scripts/kernel-doc                      |   2 +-
 3 files changed, 1 insertion(+), 325 deletions(-)
 delete mode 100644 Documentation/kernel-doc-nano-HOWTO.txt

diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index 3bec49c33bbb..aca4f00ec69b 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -228,8 +228,6 @@ isdn/
 	- directory with info on the Linux ISDN support, and supported cards.
 kbuild/
 	- directory with info about the kernel build process.
-kernel-doc-nano-HOWTO.txt
-	- outdated info about kernel-doc documentation.
 kdump/
 	- directory with mini HowTo on getting the crash dump code to work.
 doc-guide/
diff --git a/Documentation/kernel-doc-nano-HOWTO.txt b/Documentation/kernel-doc-nano-HOWTO.txt
deleted file mode 100644
index c23e2c5ab80d..000000000000
--- a/Documentation/kernel-doc-nano-HOWTO.txt
+++ /dev/null
@@ -1,322 +0,0 @@
-NOTE: this document is outdated and will eventually be removed.  See
-Documentation/doc-guide/ for current information.
-
-kernel-doc nano-HOWTO
-=====================
-
-How to format kernel-doc comments
----------------------------------
-
-In order to provide embedded, 'C' friendly, easy to maintain,
-but consistent and extractable documentation of the functions and
-data structures in the Linux kernel, the Linux kernel has adopted
-a consistent style for documenting functions and their parameters,
-and structures and their members.
-
-The format for this documentation is called the kernel-doc format.
-It is documented in this Documentation/kernel-doc-nano-HOWTO.txt file.
-
-This style embeds the documentation within the source files, using
-a few simple conventions.  The scripts/kernel-doc perl script, the
-Documentation/sphinx/kerneldoc.py Sphinx extension and other tools understand
-these conventions, and are used to extract this embedded documentation
-into various documents.
-
-In order to provide good documentation of kernel functions and data
-structures, please use the following conventions to format your
-kernel-doc comments in Linux kernel source.
-
-We definitely need kernel-doc formatted documentation for functions
-that are exported to loadable modules using EXPORT_SYMBOL.
-
-We also look to provide kernel-doc formatted documentation for
-functions externally visible to other kernel files (not marked
-"static").
-
-We also recommend providing kernel-doc formatted documentation
-for private (file "static") routines, for consistency of kernel
-source code layout.  But this is lower priority and at the
-discretion of the MAINTAINER of that kernel source file.
-
-Data structures visible in kernel include files should also be
-documented using kernel-doc formatted comments.
-
-The opening comment mark "/**" is reserved for kernel-doc comments.
-Only comments so marked will be considered by the kernel-doc scripts,
-and any comment so marked must be in kernel-doc format.  Do not use
-"/**" to be begin a comment block unless the comment block contains
-kernel-doc formatted comments.  The closing comment marker for
-kernel-doc comments can be either "*/" or "**/", but "*/" is
-preferred in the Linux kernel tree.
-
-Kernel-doc comments should be placed just before the function
-or data structure being described.
-
-Example kernel-doc function comment:
-
-/**
- * foobar() - short function description of foobar
- * @arg1:	Describe the first argument to foobar.
- * @arg2:	Describe the second argument to foobar.
- *		One can provide multiple line descriptions
- *		for arguments.
- *
- * A longer description, with more discussion of the function foobar()
- * that might be useful to those using or modifying it.  Begins with
- * empty comment line, and may include additional embedded empty
- * comment lines.
- *
- * The longer description can have multiple paragraphs.
- *
- * Return: Describe the return value of foobar.
- */
-
-The short description following the subject can span multiple lines
-and ends with an @argument description, an empty line or the end of
-the comment block.
-
-The @argument descriptions must begin on the very next line following
-this opening short function description line, with no intervening
-empty comment lines.
-
-If a function parameter is "..." (varargs), it should be listed in
-kernel-doc notation as:
- * @...: description
-
-The return value, if any, should be described in a dedicated section
-named "Return".
-
-Example kernel-doc data structure comment.
-
-/**
- * struct blah - the basic blah structure
- * @mem1:	describe the first member of struct blah
- * @mem2:	describe the second member of struct blah,
- *		perhaps with more lines and words.
- *
- * Longer description of this structure.
- */
-
-The kernel-doc function comments describe each parameter to the
-function, in order, with the @name lines.
-
-The kernel-doc data structure comments describe each structure member
-in the data structure, with the @name lines.
-
-The longer description formatting is "reflowed", losing your line
-breaks.  So presenting carefully formatted lists within these
-descriptions won't work so well; derived documentation will lose
-the formatting.
-
-See the section below "How to add extractable documentation to your
-source files" for more details and notes on how to format kernel-doc
-comments.
-
-Components of the kernel-doc system
------------------------------------
-
-Many places in the source tree have extractable documentation in the
-form of block comments above functions.  The components of this system
-are:
-
-- scripts/kernel-doc
-
-  This is a perl script that hunts for the block comments and can mark
-  them up directly into DocBook, ReST, man, text, and HTML. (No, not
-  texinfo.)
-
-- scripts/docproc.c
-
-  This is a program for converting SGML template files into SGML
-  files. When a file is referenced it is searched for symbols
-  exported (EXPORT_SYMBOL), to be able to distinguish between internal
-  and external functions.
-  It invokes kernel-doc, giving it the list of functions that
-  are to be documented.
-  Additionally it is used to scan the SGML template files to locate
-  all the files referenced herein. This is used to generate dependency
-  information as used by make.
-
-- Makefile
-
-  The targets 'xmldocs', 'latexdocs', 'pdfdocs', 'epubdocs'and 'htmldocs'
-  are used to build XML DocBook files, LaTeX files, PDF files,
-  ePub files and html files in Documentation/.
-
-How to extract the documentation
---------------------------------
-
-If you just want to read the ready-made books on the various
-subsystems, just type 'make epubdocs', or 'make pdfdocs', or 'make htmldocs',
-depending on your preference.  If you would rather read a different format,
-you can type 'make xmldocs' and then use DocBook tools to convert
-Documentation/output/*.xml to a format of your choice (for example,
-'db2html ...' if 'make htmldocs' was not defined).
-
-If you want to see man pages instead, you can do this:
-
-$ cd linux
-$ scripts/kernel-doc -man $(find -name '*.c') | split-man.pl /tmp/man
-$ scripts/kernel-doc -man $(find -name '*.h') | split-man.pl /tmp/man
-
-Here is split-man.pl:
-
--->
-#!/usr/bin/perl
-
-if ($#ARGV < 0) {
-   die "where do I put the results?\n";
-}
-
-mkdir $ARGV[0],0777;
-$state = 0;
-while (<STDIN>) {
-    if (/^\.TH \"[^\"]*\" 9 \"([^\"]*)\"/) {
-	if ($state == 1) { close OUT }
-	$state = 1;
-	$fn = "$ARGV[0]/$1.9";
-	print STDERR "Creating $fn\n";
-	open OUT, ">$fn" or die "can't open $fn: $!\n";
-	print OUT $_;
-    } elsif ($state != 0) {
-	print OUT $_;
-    }
-}
-
-close OUT;
-<--
-
-If you just want to view the documentation for one function in one
-file, you can do this:
-
-$ scripts/kernel-doc -man -function fn file | nroff -man | less
-
-or this:
-
-$ scripts/kernel-doc -text -function fn file
-
-
-How to add extractable documentation to your source files
----------------------------------------------------------
-
-The format of the block comment is like this:
-
-/**
- * function_name(:)? (- short description)?
-(* @parameterx(space)*: (description of parameter x)?)*
-(* a blank line)?
- * (Description:)? (Description of function)?
- * (section header: (section description)? )*
-(*)?*/
-
-All "description" text can span multiple lines, although the
-function_name & its short description are traditionally on a single line.
-Description text may also contain blank lines (i.e., lines that contain
-only a "*").
-
-"section header:" names must be unique per function (or struct,
-union, typedef, enum).
-
-Use the section header "Return" for sections describing the return value
-of a function.
-
-Avoid putting a spurious blank line after the function name, or else the
-description will be repeated!
-
-All descriptive text is further processed, scanning for the following special
-patterns, which are highlighted appropriately.
-
-'funcname()' - function
-'$ENVVAR' - environment variable
-'&struct_name' - name of a structure (up to two words including 'struct')
-'@parameter' - name of a parameter
-'%CONST' - name of a constant.
-
-NOTE 1:  The multi-line descriptive text you provide does *not* recognize
-line breaks, so if you try to format some text nicely, as in:
-
-  Return:
-    0 - cool
-    1 - invalid arg
-    2 - out of memory
-
-this will all run together and produce:
-
-  Return: 0 - cool 1 - invalid arg 2 - out of memory
-
-NOTE 2:  If the descriptive text you provide has lines that begin with
-some phrase followed by a colon, each of those phrases will be taken as
-a new section heading, which means you should similarly try to avoid text
-like:
-
-  Return:
-    0: cool
-    1: invalid arg
-    2: out of memory
-
-every line of which would start a new section.  Again, probably not
-what you were after.
-
-Take a look around the source tree for examples.
-
-
-kernel-doc for structs, unions, enums, and typedefs
----------------------------------------------------
-
-Beside functions you can also write documentation for structs, unions,
-enums and typedefs. Instead of the function name you must write the name
-of the declaration;  the struct/union/enum/typedef must always precede
-the name. Nesting of declarations is not supported.
-Use the argument mechanism to document members or constants.
-
-Inside a struct description, you can use the "private:" and "public:"
-comment tags.  Structure fields that are inside a "private:" area
-are not listed in the generated output documentation.  The "private:"
-and "public:" tags must begin immediately following a "/*" comment
-marker.  They may optionally include comments between the ":" and the
-ending "*/" marker.
-
-Example:
-
-/**
- * struct my_struct - short description
- * @a: first member
- * @b: second member
- *
- * Longer description
- */
-struct my_struct {
-    int a;
-    int b;
-/* private: internal use only */
-    int c;
-};
-
-
-Including documentation blocks in source files
-----------------------------------------------
-
-To facilitate having source code and comments close together, you can
-include kernel-doc documentation blocks that are free-form comments
-instead of being kernel-doc for functions, structures, unions,
-enums, or typedefs.  This could be used for something like a
-theory of operation for a driver or library code, for example.
-
-This is done by using a DOC: section keyword with a section title.  E.g.:
-
-/**
- * DOC: Theory of Operation
- *
- * The whizbang foobar is a dilly of a gizmo.  It can do whatever you
- * want it to do, at any time.  It reads your mind.  Here's how it works.
- *
- * foo bar splat
- *
- * The only drawback to this gizmo is that is can sometimes damage
- * hardware, software, or its subject(s).
- */
-
-DOC: sections are used in ReST files.
-
-Tim.
-*/ <twaugh@redhat.com>
diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 69757ee9db4c..b6f3f6962897 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -48,7 +48,7 @@ Read C language source or header FILEs, extract embedded documentation comments,
 and print formatted documentation to standard output.
 
 The documentation comments are identified by "/**" opening comment mark. See
-Documentation/kernel-doc-nano-HOWTO.txt for the documentation comment syntax.
+Documentation/doc-guide/kernel-doc.rst for the documentation comment syntax.
 
 Output format selection (mutually exclusive):
   -man			Output troff manual page format. This is the default.
-- 
2.13.5
