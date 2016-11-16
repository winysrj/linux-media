Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53242 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752679AbcKPU0m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 15:26:42 -0500
Date: Wed, 16 Nov 2016 18:26:33 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: ksummit-discuss@lists.linuxfoundation.org,
        Josh Triplett <josh@joshtriplett.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [Ksummit-discuss] Including images on Sphinx documents
Message-ID: <20161116182633.74559ffd@vento.lan>
In-Reply-To: <11020459.EheIgy38UF@wuerfel>
References: <20161107075524.49d83697@vento.lan>
        <20161107170504.25j4rwfohhqp67fw@x>
        <20161108085036.304fdfea@vento.lan>
        <11020459.EheIgy38UF@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

Em Wed, 16 Nov 2016 17:03:47 +0100
Arnd Bergmann <arnd@arndb.de> escreveu:

> On Tuesday, November 8, 2016 8:50:36 AM CET Mauro Carvalho Chehab wrote:
> > It basically calls ImageMagick "convert" tool for all png and
> > pdf files currently at the documentation (they're all at media,
> > ATM).  
> 
> It looks like we still need to find a way to address the .gif files
> though, as they have the same problem as the .pdf files.

Actually, my last patch series removed all *.pdf images and converted
all .gif files under Documentation/media to PNG[1]. I also replaced some
images by .svg, but the remaining ones are more complex. I'm even not
sure if it makes sense to convert a few of them to vectorial graphics,
like on this case:
	https://mchehab.fedorapeople.org/kernel_docs/media/_images/selection.png

>
> During the kernel summit, I looked around for any binary files in
> the kernel source tree, and except for the penguin logo, they are
> all in Documentation/media/uapi/v4l/, but they are not all pdf
> files, but also .png and .pdf.

>From what I understood from Linus, his problem is to carry on a
non-editable file at the Kernel tree. With that sense, a PNG file
is OK, as it is editable.

I had, in the past, problems with binary contents on either Mercurial
or git (before migrating to git, we used Mercurial for a while).
So, before Kernel 4.8, those .pdf, .png (and .gif) images were uuencoded,
in order to avoid troubles handling patches with them.

Nowadays, I don't see any issue handling binary images via e-mail or via git.

Btw, with that regards, SVG images are a lot worse to handle, as a single
line can easily have more than 998 characters, with makes some email
servers to reject patches with them. So, at the version 3 of my patch 
series, I had to use inkscape to ungroup some images, and to rewrite their
files, as otherwise, two patches were silently rejected by the VGER 
server.

[1] The reason to convert to PNG is that it means one less format to be
concerned with. Also, it doesn't make much sense to use two different
formats for bitmap images at the documentation.

Thanks,
Mauro
