Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40872 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbaEMQeS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 May 2014 12:34:18 -0400
Date: Tue, 13 May 2014 13:34:11 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v3.16] saa7134 fixes and vb2 conversion
Message-ID: <20140513133411.2fecdd2f@recife.lan>
In-Reply-To: <5357C532.4030206@xs4all.nl>
References: <5357C532.4030206@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 23 Apr 2014 15:50:42 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Hi Mauro,
> 
> I have attempted to split up the saa7134 vb2 conversion a bit more, but I don't
> see how I can reduce it further, except by disabling parts of the driver, then
> converting each part and enabling it again (i.e., disable dvb & empress, convert
> just video/vbi to vb2, then empress, then dvb).
> 
> But I think that's rather ugly since a bisect might end up with a partially
> crippled driver.
> 
> It's the same as what I posted a week ago, except rebased to the latest master
> branch:
> 
> http://www.spinics.net/lists/linux-media/msg75893.html
> 
> If you still want more changes, then please see if you can at least merge the
> first 9 patches.
> 
> Regards,
> 
> 	Hans
> 
> The following changes since commit ce9c22443e77594531be84ba8d523f4148ba09fe:
> 
>   [media] vb2: fix compiler warning (2014-04-23 10:13:57 -0300)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git for-v3.16c
> 
> for you to fetch changes up to e37d96689c22fd547ed4153ae8a67c26c54ae679:
> 
>   saa7134: add saa7134_userptr module option to enable USERPTR (2014-04-23 15:42:45 +0200)
> 
> ----------------------------------------------------------------
> Hans Verkuil (11):
>       saa7134: fix regression with tvtime
>       saa7134: coding style cleanups.
>       saa7134: drop abuse of low-level videobuf functions
>       saa7134: swap ts_init_encoder and ts_reset_encoder
>       saa7134: store VBI hlen/vlen globally
>       saa7134: remove fmt from saa7134_buf
>       saa7134: rename empress_tsq to empress_vbq
>       saa7134: rename vbi/cap to vbi_vbq/cap_vbq

This one broke git bisectability:

drivers/media/pci/saa7134/saa7134-video.c: In function 'video_release':
drivers/media/pci/saa7134/saa7134-video.c:1244:22: error: 'struct saa7134_dev' has no member named 'cap'
   INIT_LIST_HEAD(&dev->cap.stream);
                      ^
drivers/media/pci/saa7134/saa7134-video.c:1256:22: error: 'struct saa7134_dev' has no member named 'vbi'
   INIT_LIST_HEAD(&dev->vbi.stream);
                      ^

I'll push upstream the patches before it.

PS.: I'm currently without access to my main email account.

>       saa7134: move saa7134_pgtable to saa7134_dmaqueue
>       saa7134: convert to vb2
>       saa7134: add saa7134_userptr module option to enable USERPTR
> 
>  drivers/media/pci/saa7134/Kconfig           |   4 +-
>  drivers/media/pci/saa7134/saa7134-alsa.c    | 106 +++++++++++--
>  drivers/media/pci/saa7134/saa7134-core.c    | 130 ++++++++--------
>  drivers/media/pci/saa7134/saa7134-dvb.c     |  50 ++++---
>  drivers/media/pci/saa7134/saa7134-empress.c | 186 +++++++++--------------
>  drivers/media/pci/saa7134/saa7134-i2c.c     |   7 -
>  drivers/media/pci/saa7134/saa7134-reg.h     |   7 -
>  drivers/media/pci/saa7134/saa7134-ts.c      | 191 +++++++++++++-----------
>  drivers/media/pci/saa7134/saa7134-tvaudio.c |   7 -
>  drivers/media/pci/saa7134/saa7134-vbi.c     | 175 ++++++++++------------
>  drivers/media/pci/saa7134/saa7134-video.c   | 652 +++++++++++++++++++++++++++++---------------------------------------------------
>  drivers/media/pci/saa7134/saa7134.h         | 107 +++++++------
>  12 files changed, 732 insertions(+), 890 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
