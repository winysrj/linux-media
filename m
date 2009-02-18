Return-path: <linux-media-owner@vger.kernel.org>
Received: from web32108.mail.mud.yahoo.com ([68.142.207.122]:35925 "HELO
	web32108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754621AbZBRPQi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 10:16:38 -0500
References: <50561.11594.qm@web32108.mail.mud.yahoo.com> <499B2A60.9080009@epfl.ch> <alpine.DEB.2.00.0902180044120.6986@axis700.grange> <alpine.DEB.2.00.0902180049580.6986@axis700.grange>
Date: Wed, 18 Feb 2009 07:09:55 -0800 (PST)
From: Agustin <gatoguan-os@yahoo.com>
Subject: Re: [PATCH/RFC 1/4] ipu_idmac: code clean-up and robustness improvements
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Valentin Longchamp <valentin.longchamp@epfl.ch>
Cc: Linux Arm Kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Dan Williams <dan.j.williams@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <951330.963.qm@web32108.mail.mud.yahoo.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi,
> Guennadi Liakhovetski wrote:
> 
> From: Guennadi Liakhovetski 
> 
> General code clean-up: remove superfluous semicolons, update comments.
> Robustness improvements: add DMA error handling to the ISR, move common code
> fragments to functions, fix scatter-gather element queuing in the ISR, survive
> channel freeing and re-allocation in a quick succession.
> 
> Signed-off-by: Guennadi Liakhovetski 
> ---
> 
> As mentioned in PATCH 0/4 this one is only for completeness / testing 
> here, will be submitted separately to the dmaengine queue. Dan, would be 
> good if you could review it here to save time.
> 
> drivers/dma/ipu/ipu_idmac.c |  300 ++++++++++++++++++++++++++++---------------
> 1 files changed, 196 insertions(+), 104 deletions(-)
> 
> diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
> index 1f154d0..91e6e4e 100644
> --- a/drivers/dma/ipu/ipu_idmac.c
> +++ b/drivers/dma/ipu/ipu_idmac.c
> @@ -28,6 +28,9 @@
> #define FS_VF_IN_VALID    0x00000002
> #define FS_ENC_IN_VALID    0x00000001
> 
> +static int ipu_disable_channel(struct idmac *idmac, struct idmac_channel 
> *ichan,
> +                   bool wait_for_stop);
> +
> /*
> ...

Thanks a lot for the patchset!

I am having some stoopid trouble while trying to apply this patch to 'mxc-master':
$ patch -p1 --dry-run < p1
patching file drivers/dma/ipu/ipu_idmac.c
patch: **** malformed patch at line 29: /*

Looks like your patches lost their format while on their way, specially every single line with a starting space has had it removed. Or is it my e-mail reader? I am trying to fix it manually, no luck.

