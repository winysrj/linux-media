Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:56759 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932854AbcKQLHp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Nov 2016 06:07:45 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: ksummit-discuss@lists.linuxfoundation.org,
        Josh Triplett <josh@joshtriplett.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Ksummit-discuss] Including images on Sphinx documents
Date: Thu, 17 Nov 2016 12:07:15 +0100
Message-ID: <2923918.nyphv1Ma7d@wuerfel>
In-Reply-To: <20161116182633.74559ffd@vento.lan>
References: <20161107075524.49d83697@vento.lan> <11020459.EheIgy38UF@wuerfel> <20161116182633.74559ffd@vento.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday, November 16, 2016 6:26:33 PM CET Mauro Carvalho Chehab wrote:
> Em Wed, 16 Nov 2016 17:03:47 +0100
> Arnd Bergmann <arnd@arndb.de> escreveu:
> 
> > On Tuesday, November 8, 2016 8:50:36 AM CET Mauro Carvalho Chehab wrote:
> > > It basically calls ImageMagick "convert" tool for all png and
> > > pdf files currently at the documentation (they're all at media,
> > > ATM).  
> > 
> > It looks like we still need to find a way to address the .gif files
> > though, as they have the same problem as the .pdf files.
> 
> Actually, my last patch series removed all *.pdf images and converted
> all .gif files under Documentation/media to PNG[1]. I also replaced some
> images by .svg, but the remaining ones are more complex. I'm even not
> sure if it makes sense to convert a few of them to vectorial graphics,
> like on this case:
> 	https://mchehab.fedorapeople.org/kernel_docs/media/_images/selection.png
> 
> >
> > During the kernel summit, I looked around for any binary files in
> > the kernel source tree, and except for the penguin logo, they are
> > all in Documentation/media/uapi/v4l/, but they are not all pdf
> > files, but also .png and .pdf.
> 
> From what I understood from Linus, his problem is to carry on a
> non-editable file at the Kernel tree. With that sense, a PNG file
> is OK, as it is editable.

[adding Linus for clarification]

I understood the concern as being about binary files that you cannot
modify with classic 'patch', which is a separate issue.

> I had, in the past, problems with binary contents on either Mercurial
> or git (before migrating to git, we used Mercurial for a while).
> So, before Kernel 4.8, those .pdf, .png (and .gif) images were uuencoded,
> in order to avoid troubles handling patches with them.
> 
> Nowadays, I don't see any issue handling binary images via e-mail or via git.



> Btw, with that regards, SVG images are a lot worse to handle, as a single
> line can easily have more than 998 characters, with makes some email
> servers to reject patches with them. So, at the version 3 of my patch 
> series, I had to use inkscape to ungroup some images, and to rewrite their
> files, as otherwise, two patches were silently rejected by the VGER 
> server.

Ok, good to know.

> [1] The reason to convert to PNG is that it means one less format to be
> concerned with. Also, it doesn't make much sense to use two different
> formats for bitmap images at the documentation.

I just tried converting all the .gif and .png files to .pnm. This would
make the files patchable but also add around 25MB to the uncompressed
kernel source tree (118kb compressed, compared to 113kb for the .gif and
.png files). This is certainly worse than the uuencoded files you
had before

	Arnd
