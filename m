Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49050 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934154AbcKQRGF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Nov 2016 12:06:05 -0500
Date: Thu, 17 Nov 2016 10:39:47 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jani Nikula <jani.nikula@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        ksummit-discuss@lists.linuxfoundation.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-media@vger.kernel.org, labbott@redhat.com
Subject: Re: [Ksummit-discuss] Including images on Sphinx documents
Message-ID: <20161117103947.0ccbb634@vento.lan>
In-Reply-To: <87r36az6oy.fsf@intel.com>
References: <20161107075524.49d83697@vento.lan>
        <11020459.EheIgy38UF@wuerfel>
        <20161116182633.74559ffd@vento.lan>
        <2923918.nyphv1Ma7d@wuerfel>
        <87r36az6oy.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 17 Nov 2016 13:28:29 +0200
Jani Nikula <jani.nikula@intel.com> escreveu:

> On Thu, 17 Nov 2016, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Wednesday, November 16, 2016 6:26:33 PM CET Mauro Carvalho Chehab wrote:  
> >> Em Wed, 16 Nov 2016 17:03:47 +0100
> >> Arnd Bergmann <arnd@arndb.de> escreveu:
> >>   
> >> > On Tuesday, November 8, 2016 8:50:36 AM CET Mauro Carvalho Chehab wrote:  

> >> > During the kernel summit, I looked around for any binary files in
> >> > the kernel source tree, and except for the penguin logo, they are
> >> > all in Documentation/media/uapi/v4l/, but they are not all pdf
> >> > files, but also .png and .pdf.  
> >> 
> >> From what I understood from Linus, his problem is to carry on a
> >> non-editable file at the Kernel tree. With that sense, a PNG file
> >> is OK, as it is editable.  

Btw, Sphinx is indeed supporting PNG without external conversions, for
both html and pdf. For reference, those are the formats it supports
for images:

	http://www.sphinx-doc.org/en/1.4.8/builders.html

There are just two formats supported for the output types we use:
PNG and JPEG. Any other format requires external conversion.

> >
> > [adding Linus for clarification]
> >
> > I understood the concern as being about binary files that you cannot
> > modify with classic 'patch', which is a separate issue.  

I don't think this is a big issue, as nowadays everyone uses git.

> 
> Also reported at [1]. So kernel.org has patches that you can't apply
> with either classic patch or git apply. They could at least be in git
> binary format so you could apply them with *something*. Of course, not
> having binaries at all would be clean.
> 
> [1] http://lkml.kernel.org/r/02a78907-933d-3f61-572e-28154b16b9e5@redhat.com

This could be solved the other way around: someone could send a patch
to "patch" adding support for binary patches in the git format.

The thing is: images usually don't change that much. For example, the
tux logo only had 3 patches in git:
	3d4f16348b77 Revert "linux.conf.au 2009: Tuz"
	8032b526d1a3 linux.conf.au 2009: Tuz
	1da177e4c3f4 (tag: v2.6.12-rc2) Linux-2.6.12-rc2

Some other examples:

$ git log --oneline ./Documentation/blockdev/drbd/DRBD-data-packets.svg
b411b3637fa7 The DRBD driver

$ git log --oneline ./Documentation/RCU/Design/Data-Structures/HugeTreeClassicRCU.svg
5c1458478c49 documentation: Add documentation for RCU's major data structures

The media images changed a little bit more, but due to the recent
documentation efforts. Usually, it takes years for someone to touch
them. If you look on it at Kernel v4.7, for example, even the media
images didn't have any changes, except due to dir renames or when
the files got encoded with base64:

$ git log --oneline -- v4.7 ./Documentation/DocBook/media/v4l/subdev-image-processing-full.svg
59ef29cc86af [media] v4l: Add subdev selections documentation: svg and dia files
$ git checkout v4.7
$ git log --oneline --follow ./Documentation/DocBook/media/v4l/fieldseq_bt.pdf
4266129964b8 [media] DocBook: Move all media docbook stuff into its own directory
8e080c2e6cad V4L/DVB (12761): DocBook: add media API specs
$ git log --oneline --follow ./Documentation/DocBook/media/v4l/*.gif
bd7319dc325a [media] DocBook: Use base64 for gif/png files
4266129964b8 [media] DocBook: Move all media docbook stuff into its own directory
$ git log --oneline --follow ./Documentation/DocBook/media/bayer.png.b64
bd7319dc325a [media] DocBook: Use base64 for gif/png files

> >> I had, in the past, problems with binary contents on either Mercurial
> >> or git (before migrating to git, we used Mercurial for a while).
> >> So, before Kernel 4.8, those .pdf, .png (and .gif) images were uuencoded,
> >> in order to avoid troubles handling patches with them.
> >> 
> >> Nowadays, I don't see any issue handling binary images via e-mail or via git.  
> >
> >
> >  
> >> Btw, with that regards, SVG images are a lot worse to handle, as a single
> >> line can easily have more than 998 characters, with makes some email
> >> servers to reject patches with them. So, at the version 3 of my patch 
> >> series, I had to use inkscape to ungroup some images, and to rewrite their
> >> files, as otherwise, two patches were silently rejected by the VGER 
> >> server.  
> >
> > Ok, good to know.
> >  
> >> [1] The reason to convert to PNG is that it means one less format to be
> >> concerned with. Also, it doesn't make much sense to use two different
> >> formats for bitmap images at the documentation.  
> >
> > I just tried converting all the .gif and .png files to .pnm. This would
> > make the files patchable but also add around 25MB to the uncompressed
> > kernel source tree (118kb compressed, compared to 113kb for the .gif and
> > .png files). This is certainly worse than the uuencoded files you
> > had before

There's also another drawback: PNM doesn't allow transparent background.
Some images have transparent backgrounds. So, such conversion would lose
it. Also, PNM is not supported on Sphinx, so it would require external
conversion, just like svg.

IMHO, if we're willing to make easier to use patch, the best is to use
uuencode (or base64). In that case, It could make sense to use it for svg 
too, in order to solve the warn of patches that contain lines longer than
998 characters (with is a violation to IETF rfc 2821).

The drawback of uuencode/base64 is that it makes harder to edit the files.
So, IMHO, I would keep them in binary format.

Thanks,
Mauro
