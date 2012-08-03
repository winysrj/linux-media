Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58502 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab2HCTRr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2012 15:17:47 -0400
Message-ID: <501C23D7.3020307@gmail.com>
Date: Fri, 03 Aug 2012 21:17:43 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Mike Dyer <mike.dyer@md-soft.co.uk>
CC: LMML <linux-media@vger.kernel.org>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: s5p-fimc capturing interlaced BT656
References: <1343911731.4113.5.camel@edge>
In-Reply-To: <1343911731.4113.5.camel@edge>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mike,

On 08/02/2012 02:48 PM, Mike Dyer wrote:
> Hi All,
> 
> I'm using the S5PV210 camera IF and capturing BT656 video from a TVP5150
> video decoder.
> 
> I notice that the capture driver ignores the field interlace flags
> reported by the 'sensor' and always uses 'V4L2_FIELD_NONE'.  It also
> seems each field ends up in it's own frame, using only half the height.

s5p-fimc driver doesn't support the interlaced video capture, as we had
no such use case yet. Patches adding it are welcome.
 
> What would need to be done to store both fields in a single frame, for
> example in a V4L2_FIELD_INTERLACE_TB/BT format?

Firstly, it would good to figure out FIMC register settings that would
allow storing both fields in a single frame. I _suspect_ it's as simple
as setting CAM_INTERLACE bit in CIGCTRL register. Have you perhaps tried
it already ?

For a quick test a patch as below might be sufficient.


diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c b/drivers/media/video/s5p-fimc/fimc-reg.c
index 1fc4ce8..19afa1a 100644
--- a/drivers/media/video/s5p-fimc/fimc-reg.c
+++ b/drivers/media/video/s5p-fimc/fimc-reg.c
@@ -576,6 +576,8 @@ int fimc_hw_set_camera_polarity(struct fimc_dev *fimc,
 	if (cam->flags & V4L2_MBUS_FIELD_EVEN_LOW)
 		cfg |= FIMC_REG_CIGCTRL_INVPOLFIELD;
 
+	cfg |= FIMC_REG_CIGCTRL_INTERLACE;
+
 	writel(cfg, fimc->regs + FIMC_REG_CIGCTRL);
 
 	return 0;


--

Thanks,
Sylwester
