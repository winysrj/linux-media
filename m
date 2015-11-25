Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:38875 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbbKYLkn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2015 06:40:43 -0500
Received: by wmec201 with SMTP id c201so66283812wme.1
        for <linux-media@vger.kernel.org>; Wed, 25 Nov 2015 03:40:41 -0800 (PST)
Date: Wed, 25 Nov 2015 12:40:38 +0100
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
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
Message-ID: <20151125114038.GU17050@phenom.ffwll.local>
References: <cover.1447943571.git.mchehab@osg.samsung.com>
 <4178c97531d615b88b2208ad6fd1284b4fc50519.1447943571.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4178c97531d615b88b2208ad6fd1284b4fc50519.1447943571.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 19, 2015 at 3:38 PM, Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:
> When make htmldocs is called on non-verbose mode, it will still be
> verbose with index.html generation for no good reason, printing:
>
>         rm -rf Documentation/DocBook/index.html; echo '<h1>Linux Kernel HTML Documentation</h1>' >> Documentation/DocBook/index.html && echo '<h2>Kernel Version: 4.4.0-rc1</h2>' >> Documentation/DocBook/index.html && cat Documentation/DocBook/iio.html >> Documentation/DocBook/index.html
>
> Instead, use the standard non-verbose mode, using:
>
>           HTML    Documentation/DocBook/index.html
>
> if not called with V=1.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Interesting, but seems to fail for e.g. gpu.xml:

$ git clean -dfx Documentation/
$ make DOCBOOKS="gpu.xml" htmldocs
 HOSTCC  scripts/basic/fixdep
 HOSTCC  scripts/docproc
 HOSTCC  scripts/check-lc_ctype
 DOCPROC Documentation/DocBook/gpu.xml

... lots of warnings about kerneldoc issues in gpu.xml

 XMLREF  Documentation/DocBook/gpu.aux.xml
 HTML    Documentation/DocBook/gpu.html
rm -rf Documentation/DocBook/index.html; echo '<h1>Linux Kernel HTML Documentation</h1>' >> Documentation/DocBook/index.html && echo '<h2>Kernel Version: 4.4.0-rc2</h2>' >> Documentation/DocBook/index.html && cat Documentation/DocBook/gpu.html >> Documentation/DocBook/index.html
cp: cannot stat ‘./Documentation/DocBook//bayer.png’: No such file or directory
cp: cannot stat ‘./Documentation/DocBook//constraints.png’: No such file or directory
cp: cannot stat ‘./Documentation/DocBook//crop.gif’: No such file or directory
cp: cannot stat ‘./Documentation/DocBook//dvbstb.png’: No such file or directory
cp: cannot stat ‘./Documentation/DocBook//fieldseq_bt.gif’: No such file or directory
cp: cannot stat ‘./Documentation/DocBook//fieldseq_tb.gif’: No such file or directory
cp: cannot stat ‘./Documentation/DocBook//nv12mt.gif’: No such file or directory
cp: cannot stat ‘./Documentation/DocBook//nv12mt_example.gif’: No such file or directory
cp: cannot stat ‘./Documentation/DocBook//pipeline.png’: No such file or directory
cp: cannot stat ‘./Documentation/DocBook//selection.png’: No such file or directory
cp: cannot stat ‘./Documentation/DocBook//vbi_525.gif’: No such file or directory
cp: cannot stat ‘./Documentation/DocBook//vbi_625.gif’: No such file or directory
cp: cannot stat ‘./Documentation/DocBook//vbi_hsync.gif’: No such file or directory
Documentation/DocBook/Makefile:55: recipe for target 'htmldocs' failed
make[1]: [htmldocs] Error 1 (ignored)

Once I've built media_api.xml the above goes away and then I get a new warning when trying to rebuild:

$ make DOCBOOKS="media_api.xml" htmldocs      

... output cut ...

$ make DOCBOOKS="gpu.xml" htmldocs      
rm -rf Documentation/DocBook/index.html; echo '<h1>Linux Kernel HTML Documentation</h1>' >> Documentation/DocBook/index.html && echo '<h2>Kernel Version: 4.4.0-rc2</h2>' >> Documentation/DocBook/index.html && cat Documentation/DocBook/gpu.html >> Documentation/DocBook/index.html
mkdir: cannot create directory ‘./Documentation/DocBook//media_api’: File exists

Cheers, Daniel


> ---
>  Documentation/DocBook/Makefile | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
> index 5b4176673ada..d70f9b68174e 100644
> --- a/Documentation/DocBook/Makefile
> +++ b/Documentation/DocBook/Makefile
> @@ -50,7 +50,7 @@ pdfdocs: $(PDF)
>
>  HTML := $(sort $(patsubst %.xml, %.html, $(BOOKS)))
>  htmldocs: $(HTML)
> -       $(call build_main_index)
> +       $(call cmd,build_main_index)
>         $(call install_media_images)
>
>  MAN := $(patsubst %.xml, %.9, $(BOOKS))
> @@ -138,7 +138,8 @@ quiet_cmd_db2pdf = PDF     $@
>
>  index = index.html
>  main_idx = $(obj)/$(index)
> -build_main_index = rm -rf $(main_idx); \
> +quiet_cmd_build_main_index = HTML    $(main_idx)
> +      cmd_build_main_index = rm -rf $(main_idx); \
>                    echo '<h1>Linux Kernel HTML Documentation</h1>' >> $(main_idx) && \
>                    echo '<h2>Kernel Version: $(KERNELVERSION)</h2>' >> $(main_idx) && \
>                    cat $(HTML) >> $(main_idx)
> --
> 2.5.0
>
>



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
