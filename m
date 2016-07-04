Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:46469 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753671AbcGDUUB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 16:20:01 -0400
Date: Mon, 4 Jul 2016 21:19:59 +0100
From: Sean Young <sean@mess.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v4.8] Various dvb/rc fixes/improvements
Message-ID: <20160704201959.GB28620@gofer.mess.org>
References: <118e026f-ebc0-a540-195c-44434f40ae46@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <118e026f-ebc0-a540-195c-44434f40ae46@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 04, 2016 at 01:54:56PM +0200, Hans Verkuil wrote:
> Mauro,
> 
> As requested, I'm helping out with reducing the backlog.
> 
> Regards,
> 
> 	Hans
> 
> The following changes since commit ab46f6d24bf57ddac0f5abe2f546a78af57b476c:
> 
>   [media] videodev2.h: Fix V4L2_PIX_FMT_YUV411P description (2016-06-28 11:54:52 -0300)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git for-v4.8f
> 
> for you to fetch changes up to 920be8ec8843d42ef3181f9a9fb988c49481b165:
> 
>   media: rc: nuvoton: remove two unused elements in struct nvt_dev (2016-07-04 13:26:37 +0200)
> 
> ----------------------------------------------------------------
> Antti Palosaari (14):
>       si2168: add support for newer firmwares
>       si2168: do not allow driver unbind
>       si2157: do not allow driver unbind
>       m88ds3103: remove useless most significant bit clear
>       m88ds3103: calculate DiSEqC message sending time
>       m88ds3103: improve ts clock setting
>       m88ds3103: use Hz instead of kHz on calculations
>       m88ds3103: refactor firmware download
>       af9033: move statistics to read_status()
>       af9033: do not allow driver unbind
>       it913x: do not allow driver unbind
>       rtl2830: do not allow driver unbind
>       rtl2830: move statistics to read_status()
>       rtl2832: do not allow driver unbind
> 
> Heiner Kallweit (12):
>       media: rc: make fifo size for raw events configurable via rc_dev
>       media: rc: nuvoton: decrease size of raw event fifo

I might be wrong but I think these last two changes are broken, see my last
message to the list on this.


Sean
