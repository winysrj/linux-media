Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgate.thermoteknix.com ([188.223.91.156]:40584 "EHLO
	mailgate.thermoteknix.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab2JPQqI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Oct 2012 12:46:08 -0400
Message-ID: <507D8536.9060303@thermoteknix.com>
Date: Tue, 16 Oct 2012 17:03:02 +0100
From: Adam Pledger <a.pledger@thermoteknix.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Omap3 ISP Recovering from SBL Overflow
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Laurent / everyone,

I have an intermittent issue with the ISP driver, where occasionally I 
encounter an SBL overflow.
Specifically the ISPSBL_PCR_CCDC_WBL_OVF bit is asserted.

My hardware configuration uses the tvp5150 decoder chip in bt656 mode 
connected to DM3730 Silicon.
The ISP is configured so that I am capturing frames directly from the 
CCDC output, without using any other ISP modules.

 From my digging so far, the SBL overflow seems to occur when closing 
the pipeline.

The strange thing is that once the overflow occurs, I can no longer get 
any valid frames from the CCDC output, even on subsequent capture 
attempts using yavta / GStreamer.

I can see the ISP interrupts occurring as normal and have verified that 
the decoder is indeed providing video correctly, however all of the 
buffers are marked with the error state and I just see endless 
"omap3isp: SBL Overflow (PCR = 0x00800000)" messages in the kernel log.

I have tried increasing the CCDC buffer memory allocation, but this 
doesn't appear to make any difference to the frequency of the 
occurrence. The TRM recommends that the SBL status bit is written back 
as a 1 to clear the error (which the ISP driver does indeed do), however 
it remains asserted and all I receive are blank buffers in the capture.

I suspect the overflow is caused by the decoder running on during / 
after the stream off call, which causes the overflow.
This isn't a major issue in itself, provided that the ISP can recover 
from the event.

I am a little short on ideas as to how to prevent this state latch up 
from occurring, other than to reset the entire ISP when it occurs, which 
seems a little crude.

Any further ideas or tips as to where I should be looking would be 
appreciated.

Many Thanks

Adam
