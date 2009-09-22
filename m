Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49288 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbZIVV3D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2009 17:29:03 -0400
Date: Tue, 22 Sep 2009 18:28:27 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org
Subject: Re: docbooks fatal build error (v4l & dvb)
Message-ID: <20090922182827.3d844748@pedra.chehab.org>
In-Reply-To: <20090922124248.59e57b55.randy.dunlap@oracle.com>
References: <20090922124248.59e57b55.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Randy,

Em Tue, 22 Sep 2009 12:42:48 -0700
Randy Dunlap <randy.dunlap@oracle.com> escreveu:

> 2.6.31-git11:  this prevents other docbooks from being built.
> 
> mkdir -p /linux-2.6.31-git11/Documentation/DocBook/media/
> cp /linux-2.6.31-git11/Documentation/DocBook/dvb/*.png /linux-2.6.31-git11/Documentation/DocBook/v4l/*.gif /linux-2.6.31-git11/Documentation/DocBook/media/
> cp: cannot stat `/linux-2.6.31-git11/Documentation/DocBook/dvb/*.png': No such file or directory
> cp: cannot stat `/linux-2.6.31-git11/Documentation/DocBook/v4l/*.gif': No such file or directory
> make[1]: *** [media] Error 1


Hmm... here, it is working fine. I've did it on a newer tree, cloned from Linus
one. This is the last patch on it:

commit 7fa07729e439a6184bd824746d06a49cca553f15
Merge: 991d79b a8f90e9
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue Sep 22 08:11:04 2009 -0700


$ make htmldocs
mkdir -p /home/v4l/tokernel/wrk/linux-2.6/Documentation/DocBook/media/
cp /home/v4l/tokernel/wrk/linux-2.6/Documentation/DocBook/dvb/*.png /home/v4l/tokernel/wrk/linux-2.6/Documentation/DocBook/v4l/*.gif /home/v4l/tokernel/wrk/linux-2.6/Documentation/DocBook/media/
rm -rf Documentation/DocBook/index.html && echo '<h1>Linux Kernel HTML
Documentation</h1>' >> Documentation/DocBook/index.html && echo '<h2>Kernel
Version: 2.6.31</h2>' >> Documentation/DocBook/index.html && cat
Documentation/DocBook/alsa-driver-api.html
Documentation/DocBook/debugobjects.html
Documentation/DocBook/device-drivers.html
Documentation/DocBook/deviceiobook.html Documentation/DocBook/filesystems.html
Documentation/DocBook/gadget.html Documentation/DocBook/genericirq.html
Documentation/DocBook/kernel-api.html Documentation/DocBook/kernel-hacking.html
Documentation/DocBook/kernel-locking.html Documentation/DocBook/kgdb.html
Documentation/DocBook/libata.html Documentation/DocBook/librs.html
Documentation/DocBook/lsm.html Documentation/DocBook/mac80211.html
Documentation/DocBook/mcabook.html Documentation/DocBook/media.html
Documentation/DocBook/mtdnand.html Documentation/DocBook/networking.html
Documentation/DocBook/procfs-guide.html Documentation/DocBook/rapidio.html
Documentation/DocBook/regulator.html Documentation/DocBook/s390-drivers.html
Documentation/DocBook/scsi.html Documentation/DocBook/sh.html
Documentation/DocBook/tracepoint.html Documentation/DocBook/uio-howto.html
Documentation/DocBook/usb.html
Documentation/DocBook/writing-an-alsa-driver.html
Documentation/DocBook/writing_usb_driver.html
Documentation/DocBook/z8530book.html >> Documentation/DocBook/index.html

I also double checked that the files are there:

$ git log Documentation/DocBook/v4l/fieldseq_bt.gif
commit 8e080c2e6cadada82a6b520e0c23a1cb974822d5
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Sun Sep 13 22:16:04 2009 -0300

    V4L/DVB (12761): DocBook: add media API specs

    The V4L and DVB API's are there for a long time. however, up to now,
    no efforts were done to merge them to kernel DocBook.

    This patch adds the current versions of the specs as an unique compendium.

    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>





Cheers,
Mauro
