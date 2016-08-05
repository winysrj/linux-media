Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:54018
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934979AbcHEKrc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Aug 2016 06:47:32 -0400
Date: Fri, 5 Aug 2016 07:47:24 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Jani Nikula <jani.nikula@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org
Subject: Re: Functions and data structure cross references with Sphinx
Message-ID: <20160805074724.74190683@recife.lan>
In-Reply-To: <91BDDA51-4A60-495F-9475-341950051EE9@darmarit.de>
References: <20160801082527.0eb7eace@recife.lan>
	<91BDDA51-4A60-495F-9475-341950051EE9@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 5 Aug 2016 09:29:23 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> Am 01.08.2016 um 13:25 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> 
> > There's one remaining major issue I noticed after the conversion of the
> > media books to Sphinx:
> > 
> > While sphinx complains if a cross-reference (using :ref:) points to an
> > undefined reference, the same doesn't happen if the reference uses
> > :c:func: and :c:type:.
> > 
> > In practice, it means that, if we do some typo there, or if we forget to
> > add the function/struct prototype (or use the wrong domain, like :cpp:),
> > Sphinx won't generate the proper cross-reference, nor warning the user.
> > 
> > That's specially bad for media, as, while we're using the c domain for
> > the kAPI and driver-specific books, we need to use the cpp domain on the 
> > uAPI book - as the c domain doesn't allow multiple declarations for
> > syscalls, and we have multiple pages for read, write, open, close, 
> > poll and ioctl.
> > 
> > It would be good to have a way to run Sphinx on some "pedantic"
> > mode or have something similar to xmlint that would be complaining
> > about invalid c/cpp domain references.
> > 
> > Thanks,
> > Mauro  
> 
> Hi Mauro,
> 
> there is a nit-picky mode [1], which could be activated by setting
> "nitpicky=True" in the conf.py or alternative, set "-n" to the 
> SPHINXOPTS:
> 
>   make SPHINXOPTS=-n htmldocs
> 
> Within nit-picky mode, Sphinx will warn about **all** references. This
> might be more then you want. For this, in the conf.py you could
> assemble a "nitpick_ignore" list [2]. But I think, assemble the
> ignore list is quite a lot of work.
> 
> [1] http://www.sphinx-doc.org/en/stable/config.html#confval-nitpicky
> [2] http://www.sphinx-doc.org/en/stable/config.html#confval-nitpick_ignore

Yeah, this is what I was looking for.

We indeed want to use this option on media, but there are some things
that need to be addressed. From some quick tests here, what I noticed
is:

1) Sphinx will generate several references that should be safely ignored
for everyone, like "enum", "u32", "int32_t", "bool", "NULL", etc;

2) the usage of cpp domain for system calls make several symbols to
not match, as the cpp function prototype will generate cross references
for the cpp domain, instead of using the c domain. So, we need a
better way to fix it using the c domain, or convert everything to the
cpp domain;

3) The references generated from the header files I'm parsing don't
use the c (or cpp) domain. They're declared at the media book as a
normal reference:
	Documentation/media/uapi/v4l/field-order.rst:.. _v4l2-field:

and cross-referenced with:
	ref:`v4l2_field <v4l2-field>`

Is there a way to change it to the c domain?


4) there are several references that, IMHO, should be nitpick-ignored
only when the book is generated stand alone. For example, at the
media docbooks, we have references for things like:

- pci_dev, mutex, off_t, container_of, etc - those are generic
  references for the symbols that every driver uses, but, as we
  don't have the books with those converted yet, nitpick complains.
  Once we have such references, they should be ignored *only* when
  the book is generated standalone. As those are "core" symbols,
  they should be already be documented, but the book was not
  ported from DocBook yet. Once we have everything ported to
  Sphinx, I would expect that they all will vanish (and, if not,
  IMHO, documenting them should be prioritized).

- References for subsystem-specific symbols like: spi_board_info,
  led_classdev_flash, i2c_adapter, etc. Those would require that
  the maintainers of the specific subsystems to add documentation
  to them, as I bet several such symbols won't be currently
  documented. So, even after the port, I afraid that we'll still
  have several such symbols missing.

To address (3), we need different sets of nitpick ignore lists.

At least in my case, I have two different procedures, depending
on the time at the Kernel release cycle:

a) daily patch merge workflow
   --------------------------

In any case, for (3), I don't want to see those warnings during
my daily patch handling process where I rebuild documentation for
every patch that touches a documented file. I want to see only
things like:
	Documentation/media/uapi/v4l/hist-v4l2.rst:1295: WARNING: c:type reference target not found: struct v4l2_buffer

With indicates that a new patch would be introducing documentation
gaps.

So, we need a way to have a per-subsystem nitpick_ignore list
(or a way to pass such list via command line), for us to be able to
ignore "alien" symbols that aren't part of the subsystem we're
maintaining.

b) preparation for the merge window
   --------------------------------

Late at the patch handling cycle, I run a very long task here that
builds the media subsystem for 50+ different archs. I also check and
fix smatch/sparse warnings. During such time, I would love to view
the full list of missing symbols, in order to be able to handle
eventual cross-subsystem wrong references (or eventually help documenting
something that we use at the media subsystem).

So, I would need to use a different nitpick_ignore list.

Is there a way for us to specify the nitpick_ignore list (or a different
conf.py) via command line?

Btw, I'm enclosing a patch adding several of those references that are
alien to the media subsystem and currently causes nitpick complains.


doc-rst: ignore several undefined symbols in nitpick mode
    
using Sphinx in nitpick mode is too verbose to make it useful.
So, we need to make it less verbose, in order to be able to
actually use it.
    
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

diff --git a/Documentation/conf.py b/Documentation/conf.py
index 96b7aa66c89c..d1805b8710c3 100644
--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -419,3 +419,88 @@ pdf_documents = [
 # line arguments.
 kerneldoc_bin = '../scripts/kernel-doc'
 kerneldoc_srctree = '..'
+
+#
+# It is possible to run Sphinx in nickpick mode with:
+#	make SPHINXOPTS=-n htmldocs
+# In such case, it will complain about lots of missing references that
+#	1) are just typedefs like: bool, __u32, etc;
+#	2) It will complain for things like: enum, NULL;
+#	3) It will complain for symbols that should be on different
+#	   books (but currently aren't ported to ReST)
+# The list below has a list of such symbols to be ignored in nitpick mode
+#
+nitpick_ignore = [
+	("c:func", "clock_gettime"),
+	("c:func", "close"),
+	("c:func", "container_of"),
+	("c:func", "determine_valid_ioctls"),
+	("c:func", "ERR_PTR"),
+	("c:func", "ioctl"),
+	("c:func", "IS_ERR"),
+	("c:func", "mmap"),
+	("c:func", "open"),
+	("c:func", "pci_name"),
+	("c:func", "poll"),
+	("c:func", "PTR_ERR"),
+	("c:func", "read"),
+	("c:func", "release"),
+	("c:func", "set"),
+	("c:func", "struct fd_set"),
+	("c:func", "struct pollfd"),
+	("c:func", "usb_make_path"),
+	("c:func", "write"),
+	("c:type", "atomic_t"),
+	("c:type", "bool"),
+	("c:type", "buf_queue"),
+	("c:type", "device"),
+	("c:type", "device_driver"),
+	("c:type", "device_node"),
+	("c:type", "enum"),
+	("c:type", "file"),
+	("c:type", "i2c_adapter"),
+	("c:type", "i2c_board_info"),
+	("c:type", "i2c_client"),
+	("c:type", "ktime_t"),
+	("c:type", "led_classdev_flash"),
+	("c:type", "list_head"),
+	("c:type", "lock_class_key"),
+	("c:type", "module"),
+	("c:type", "mutex"),
+	("c:type", "pci_dev"),
+	("c:type", "pdvbdev"),
+	("c:type", "poll_table_struct"),
+	("c:type", "s32"),
+	("c:type", "s64"),
+	("c:type", "sd"),
+	("c:type", "spi_board_info"),
+	("c:type", "spi_device"),
+	("c:type", "spi_master"),
+	("c:type", "struct fb_fix_screeninfo"),
+	("c:type", "struct pollfd"),
+	("c:type", "struct timeval"),
+	("c:type", "struct video_capability"),
+	("c:type", "u16"),
+	("c:type", "u32"),
+	("c:type", "u64"),
+	("c:type", "u8"),
+	("c:type", "union"),
+	("c:type", "usb_device"),
+
+	("cpp:type", "boolean"),
+	("cpp:type", "fd"),
+	("cpp:type", "fd_set"),
+	("cpp:type", "int16_t"),
+	("cpp:type", "NULL"),
+	("cpp:type", "off_t"),
+	("cpp:type", "pollfd"),
+	("cpp:type", "size_t"),
+	("cpp:type", "ssize_t"),
+	("cpp:type", "timeval"),
+	("cpp:type", "__u16"),
+	("cpp:type", "__u32"),
+	("cpp:type", "__u64"),
+	("cpp:type", "uint16_t"),
+	("cpp:type", "uint32_t"),
+	("cpp:type", "video_system_t"),
+]



