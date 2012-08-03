Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35909 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab2HCUCA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2012 16:02:00 -0400
Received: by wibhr14 with SMTP id hr14so992415wib.1
        for <linux-media@vger.kernel.org>; Fri, 03 Aug 2012 13:01:59 -0700 (PDT)
Message-ID: <1344024117.1907.8.camel@edge.config>
Subject: Re: s5p-fimc capturing interlaced BT656
From: Mike Dyer <mike.dyer@md-soft.co.uk>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>
Date: Fri, 03 Aug 2012 21:01:57 +0100
In-Reply-To: <501C23D7.3020307@gmail.com>
References: <1343911731.4113.5.camel@edge> <501C23D7.3020307@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Fri, 2012-08-03 at 21:17 +0200, Sylwester Nawrocki wrote:
> Hi Mike,
> 
> On 08/02/2012 02:48 PM, Mike Dyer wrote:
> > Hi All,
> > 
> > I'm using the S5PV210 camera IF and capturing BT656 video from a TVP5150
> > video decoder.
> > 
> > I notice that the capture driver ignores the field interlace flags
> > reported by the 'sensor' and always uses 'V4L2_FIELD_NONE'.  It also
> > seems each field ends up in it's own frame, using only half the height.
> 
> s5p-fimc driver doesn't support the interlaced video capture, as we had
> no such use case yet. Patches adding it are welcome.
>  
> > What would need to be done to store both fields in a single frame, for
> > example in a V4L2_FIELD_INTERLACE_TB/BT format?
> 
> Firstly, it would good to figure out FIMC register settings that would
> allow storing both fields in a single frame. I _suspect_ it's as simple
> as setting CAM_INTERLACE bit in CIGCTRL register. Have you perhaps tried
> it already ?
> 
> For a quick test a patch as below might be sufficient.
> 
> 
> diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c b/drivers/media/video/s5p-fimc/fimc-reg.c
> index 1fc4ce8..19afa1a 100644
> --- a/drivers/media/video/s5p-fimc/fimc-reg.c
> +++ b/drivers/media/video/s5p-fimc/fimc-reg.c
> @@ -576,6 +576,8 @@ int fimc_hw_set_camera_polarity(struct fimc_dev *fimc,
>  	if (cam->flags & V4L2_MBUS_FIELD_EVEN_LOW)
>  		cfg |= FIMC_REG_CIGCTRL_INVPOLFIELD;
>  
> +	cfg |= FIMC_REG_CIGCTRL_INTERLACE;
> +
>  	writel(cfg, fimc->regs + FIMC_REG_CIGCTRL);
>  
>  	return 0;
> 
> 
> --
> 
> Thanks,
> Sylwester

I have indeed tried setting that, but with no effect.  However, checking
through the datasheet for the FIMC I discovered a DMA output (CIOCTRL)
register bit called 'Weave_Out'. The description is:

"Even and Odd fields can be weaved together and combined to form a
complete progressive frame by hardware. This field is useful for
interlace DMA output mode (Interlace_out or CAM_INTERLACE). Even field
address (1st frame start address) is used weave address. Odd fields
address (2nd frame start address) is ignored."

This does produce full sized frames, but I still seem to only be getting
one field per frame, with a blank line inserted between each real line.
Setting both interlace and weave doesn't seem to help. So, something
still missing...  

I wonder if the irq handler is getting called for each field, maybe we
need to wait for two interrupts before dequeing the frame?

Cheers,
Mike

