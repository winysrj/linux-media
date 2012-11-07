Return-path: <linux-media-owner@vger.kernel.org>
Received: from co202.xi-lite.net ([149.6.83.202]:38126 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492Ab2KGKjl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Nov 2012 05:39:41 -0500
Message-ID: <509A39F0.3090202@parrot.com>
Date: Wed, 7 Nov 2012 11:37:36 +0100
From: Julien BERAUD <julien.beraud@parrot.com>
MIME-Version: 1.0
To: "laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: omap3isp-bt656 stopping issue
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I have been working on a platform based on an omap3630 with a tvp5151 in 
bt656 mode and I have iommu translation faults when starting and 
stopping capture in a loop a certain number of times.
I think I have identified the problem and though my working branch is 
not exactly the same as yours, I think that you have the same issue.

When stopping ccdc capture(ccdc_set_stream), function ccdc_disable is 
called which clears the bit  ISPCCDC_PCR_EN (__ccdc_disable) and waits 
for the current frame to finish.
In progressive mode, the next vd0_isr will call ccdc_isr_buffer which 
will wait for the ccdc pcr busy flag to go off and then call function 
__ccdc_handle_stopping which will set the flags that will allow the 
stopping process to go on.

The problem seems to be that in interlaced mode, if the next vd0_isr is 
received for the first half of the frame(odd field), the ccdc_isr_buffer 
routine is not called,  __ccdc_handle_stopping is called and sets the 
flags that will allow the stopping process to go on without waiting for 
the frame to finish like it should be the case, or like it is the case 
if the next vd0_isr is received for the second part of the frame(even 
field).

Calling ccdc_isr_buffer in case ccdc->stopping & CCDC_STOP_REQUEST != 0 
makes that the flags are set only after the busy signal goes off and it 
fixes the issue I have.

By the way, I haven't seen anything in the omap3630 trm that tells me 
that in case we are in progressive mode, the busy flag goes off after 
the current field(half frame) is finished instead of the whole frame but 
I noticed this is the case.

If there is something I missed, or if the behaviour of the ccdc isn't 
supposed to be like that, could you explain what I got wrong?

Best Regards,
Julien BERAUD

