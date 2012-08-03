Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:49942 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab2HCU2b (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2012 16:28:31 -0400
Message-ID: <501C346C.9000204@gmail.com>
Date: Fri, 03 Aug 2012 22:28:28 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Mike Dyer <mike.dyer@md-soft.co.uk>
CC: LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc@vger.kernel.org
Subject: Re: s5p-fimc capturing interlaced BT656
References: <1343911731.4113.5.camel@edge> <501C23D7.3020307@gmail.com> <1344024117.1907.8.camel@edge.config>
In-Reply-To: <1344024117.1907.8.camel@edge.config>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/03/2012 10:01 PM, Mike Dyer wrote:
> I have indeed tried setting that, but with no effect.  However, checking
> through the datasheet for the FIMC I discovered a DMA output (CIOCTRL)
> register bit called 'Weave_Out'. The description is:
> 
> "Even and Odd fields can be weaved together and combined to form a
> complete progressive frame by hardware. This field is useful for
> interlace DMA output mode (Interlace_out or CAM_INTERLACE). Even field
> address (1st frame start address) is used weave address. Odd fields
> address (2nd frame start address) is ignored."
> 
> This does produce full sized frames, but I still seem to only be getting
> one field per frame, with a blank line inserted between each real line.
> Setting both interlace and weave doesn't seem to help. So, something
> still missing...
> 
> I wonder if the irq handler is getting called for each field, maybe we
> need to wait for two interrupts before dequeing the frame?

Hmm, might be worth to try. But I'm wondering if the output DMA handling
doesn't need to be reworked for that. According to the datasheet (Figure 
2-20 Frame Buffer Control), even fields are written to DMA buffer with 
even index (e.g. 0) and odd fields are written to DMA buffer with odd 
index (e.g. 1). So possibly, if we set same address at two DMA buffer 
start address registers (e.g. FIMC_REG_CIOYSA(0), FIMC_REG_CIOYSA(1)) 
then even and odd frame will be written to proper memory location ?

This might not be very difficult to implement.

--

Regards,
Sylwester
