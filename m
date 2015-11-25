Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55239 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754637AbbKYOYv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2015 09:24:51 -0500
Date: Wed, 25 Nov 2015 12:24:44 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ben Hutchings <ben@decadent.org.uk>,
	Lukas Wunner <lukas@wunner.de>,
	Daniel Baluta <daniel.baluta@intel.com>,
	Michal Marek <mmarek@suse.cz>,
	Danilo Cesar Lemes de Paula <danilo.cesar@collabora.co.uk>,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH 3/3] DocBook: make index.html generation less verbose by
 default
Message-ID: <20151125122444.4636304e@recife.lan>
In-Reply-To: <20151125114038.GU17050@phenom.ffwll.local>
References: <cover.1447943571.git.mchehab@osg.samsung.com>
	<4178c97531d615b88b2208ad6fd1284b4fc50519.1447943571.git.mchehab@osg.samsung.com>
	<20151125114038.GU17050@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 25 Nov 2015 12:40:38 +0100
Daniel Vetter <daniel.vetter@ffwll.ch> escreveu:

> On Thu, Nov 19, 2015 at 3:38 PM, Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:
> > When make htmldocs is called on non-verbose mode, it will still be
> > verbose with index.html generation for no good reason, printing:
> >
> >         rm -rf Documentation/DocBook/index.html; echo '<h1>Linux Kernel HTML Documentation</h1>' >> Documentation/DocBook/index.html && echo '<h2>Kernel Version: 4.4.0-rc1</h2>' >> Documentation/DocBook/index.html && cat Documentation/DocBook/iio.html >> Documentation/DocBook/index.html
> >
> > Instead, use the standard non-verbose mode, using:
> >
> >           HTML    Documentation/DocBook/index.html
> >
> > if not called with V=1.
> >
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> Interesting, but seems to fail for e.g. gpu.xml:
> 
> $ git clean -dfx Documentation/
> $ make DOCBOOKS="gpu.xml" htmldocs
>  HOSTCC  scripts/basic/fixdep
>  HOSTCC  scripts/docproc
>  HOSTCC  scripts/check-lc_ctype
>  DOCPROC Documentation/DocBook/gpu.xml
> 
> ... lots of warnings about kerneldoc issues in gpu.xml
> 
>  XMLREF  Documentation/DocBook/gpu.aux.xml
>  HTML    Documentation/DocBook/gpu.html
> rm -rf Documentation/DocBook/index.html; echo '<h1>Linux Kernel HTML Documentation</h1>' >> Documentation/DocBook/index.html && echo '<h2>Kernel Version: 4.4.0-rc2</h2>' >> Documentation/DocBook/index.html && cat Documentation/DocBook/gpu.html >> Documentation/DocBook/index.html
> cp: cannot stat ‘./Documentation/DocBook//bayer.png’: No such file or directory
> cp: cannot stat ‘./Documentation/DocBook//constraints.png’: No such file or directory
> cp: cannot stat ‘./Documentation/DocBook//crop.gif’: No such file or directory
> cp: cannot stat ‘./Documentation/DocBook//dvbstb.png’: No such file or directory
> cp: cannot stat ‘./Documentation/DocBook//fieldseq_bt.gif’: No such file or directory
> cp: cannot stat ‘./Documentation/DocBook//fieldseq_tb.gif’: No such file or directory
> cp: cannot stat ‘./Documentation/DocBook//nv12mt.gif’: No such file or directory
> cp: cannot stat ‘./Documentation/DocBook//nv12mt_example.gif’: No such file or directory
> cp: cannot stat ‘./Documentation/DocBook//pipeline.png’: No such file or directory
> cp: cannot stat ‘./Documentation/DocBook//selection.png’: No such file or directory
> cp: cannot stat ‘./Documentation/DocBook//vbi_525.gif’: No such file or directory
> cp: cannot stat ‘./Documentation/DocBook//vbi_625.gif’: No such file or directory
> cp: cannot stat ‘./Documentation/DocBook//vbi_hsync.gif’: No such file or directory
> Documentation/DocBook/Makefile:55: recipe for target 'htmldocs' failed
> make[1]: [htmldocs] Error 1 (ignored)
> 
> Once I've built media_api.xml the above goes away

There's actually one patch fixing this at media tree:

>From d01b2d53a5a4db38c7c95651ca9ff23bb930844e Mon Sep 17 00:00:00 2001
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Date: Thu, 19 Nov 2015 07:41:40 -0200
Subject: [PATCH] DocBook: only copy stuff to media_api if media xml is
 generated

It is possible to use:
	make DOCBOOKS=device-drivers.xml htmldocs

To produce just a few docbooks. In such case, the media docs
won't be built, causing the makefile target to return an error.

While this is ok for human eyes, if the above is used on an script,
it would cause troubles.

Fix it by only creating/filling the media_api directory if the
media_api.xml is found at DOCBOOKS.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index 02848146fc3a..2840ff483d5a 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -199,8 +199,10 @@ DVB_DOCUMENTED = \
 #
 
 install_media_images = \
-	$(Q)-mkdir -p $(MEDIA_OBJ_DIR)/media_api; \
-	cp $(OBJIMGFILES) $(MEDIA_SRC_DIR)/*.svg $(MEDIA_SRC_DIR)/v4l/*.svg $(MEDIA_OBJ_DIR)/media_api
+	$(Q)if [ "x$(findstring media_api.xml,$(DOCBOOKS))" != "x" ]; then \
+		mkdir -p $(MEDIA_OBJ_DIR)/media_api; \
+		cp $(OBJIMGFILES) $(MEDIA_SRC_DIR)/*.svg $(MEDIA_SRC_DIR)/v4l/*.svg $(MEDIA_OBJ_DIR)/media_api; \
+	fi
 
 $(MEDIA_OBJ_DIR)/%: $(MEDIA_SRC_DIR)/%.b64
 	$(Q)base64 -d $< >$@


> and then I get a new warning when trying to rebuild:
> 
> $ make DOCBOOKS="media_api.xml" htmldocs      
> 
> ... output cut ...
> 
> $ make DOCBOOKS="gpu.xml" htmldocs      
> rm -rf Documentation/DocBook/index.html; echo '<h1>Linux Kernel HTML Documentation</h1>' >> Documentation/DocBook/index.html && echo '<h2>Kernel Version: 4.4.0-rc2</h2>' >> Documentation/DocBook/index.html && cat Documentation/DocBook/gpu.html >> Documentation/DocBook/index.html
> mkdir: cannot create directory ‘./Documentation/DocBook//media_api’: File exists

There are two other patches for Documentation/DocBook/media/Makefile
that will fix this trouble.

Those patches are already at linux-next, via my tree.

Regards,
Mauro
