Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:49552 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934831Ab0HDU5X (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Aug 2010 16:57:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Lane Brooks <lane@brooks.nu>
Subject: Re: OMAP3 Bridge Problems
Date: Wed, 4 Aug 2010 22:57:12 +0200
Cc: linux-media@vger.kernel.org
References: <4C583538.8060504@gmail.com>
In-Reply-To: <4C583538.8060504@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008042257.13290.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lane,

On Tuesday 03 August 2010 17:26:48 Lane Brooks wrote:
> Laurent and team,

Could you please CC me when sending a mail that requires my attention ? I 
follow the linux-media mailing list, but sometimes mails can slip by.

> I am using the OMAP3 ISP code from the devel branch on gitorious that I
> back ported to a 2.6.31 kernel. Raw bayer streaming to the CCDC output
> works fine. I am using parallel input with the bridge disabled in that
> mode.
> 
> I am having a problem when I switch the sensor to output YUV422 data.
> The YUV422 stream is a 8x2. If I only switch the sensor to YUV422 mode,
> then I can get the YUV422 data at the CCDC output, but the CCDC pads an
> extra zero byte in there and I only get half the image. So that works as
> expected. I was then hoping all I would have to do is enable the bridge
> to get the YUV422_8x2 data packed into the YUV422_16x1 automatically,
> but instead I get select timeouts.
> 
> My question:
> 
> - Are there other things I need to when I enable the parallel bridge?
> For example, do I need to change a clock rate somewhere? From the TRM,
> it seems like it should just work without any changes, but maybe I am
> missing something.

Good question. ISP bridge and YUV modes support are not implemented in the 
driver, but you're probably already aware of that.

I unfortunately have no straightforward answer. Try tracing the ISP interrupts 
and monitoring the CCDC SBL busy bits to see if the CCDC writes images to 
memory correctly.

-- 
Regards,

Laurent Pinchart
