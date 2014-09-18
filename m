Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40195 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbaIRIZV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Sep 2014 04:25:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sriram V <vshrirama@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: OMAP3 Multiple camera support
Date: Thu, 18 Sep 2014 11:25:25 +0300
Message-ID: <25198985.8uoHdSYb8S@avalon>
In-Reply-To: <CAH9_wRM_wd_GkS=j-7pkYTFRg4U1oN=NO+Wfhp56vKturYb+cg@mail.gmail.com>
References: <CAH9_wRM_wd_GkS=j-7pkYTFRg4U1oN=NO+Wfhp56vKturYb+cg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sriram,

On Wednesday 17 September 2014 23:06:42 Sriram V wrote:
> Hi
> 
> Does OMAP3 camera driver support multiple cameras at the same time.
> 
> As i understand - You can have simultaneous YUV422 (Directly to memory)
> and another one passing through camera controller ISP?
> 
> I Also, wanted to check if anyone has tried having multiple cameras on omap3
> with the existing driver.

The driver does support capturing from multiple cameras at the same time, 
provided one of them is connected to the CSI2A receiver. You can then capture 
raw frames from the CSI2A receiver output while processing frames from the 
other camera (connected to CSI1/CCP2, CSI2C or parallel interface) using the 
whole ISP pipeline.

Please note that the consumer OMAP3 variants are documented by TI as not 
including the CSI receivers. However, several developers have reported that 
the receivers are present and usable at least in some of the chips.

-- 
Regards,

Laurent Pinchart

