Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:58960 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754948AbZGOVwB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jul 2009 17:52:01 -0400
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: John Sarman <johnsarman@gmail.com>,
	"sakari.ailus@nokia.com" <sakari.ailus@nokia.com>,
	Tuukka Toivonen <tuukka.o.toivonen@nokia.com>,
	linux-media <linux-media@vger.kernel.org>
Date: Wed, 15 Jul 2009 16:51:50 -0500
Subject: RE: Help bringing up a sensor driver for isp omap34xx.c
Message-ID: <A24693684029E5489D1D202277BE894449E14132@dlee02.ent.ti.com>
References: <bb2708720907151444l3a93bcb3y75d227c4828ec311@mail.gmail.com>
In-Reply-To: <bb2708720907151444l3a93bcb3y75d227c4828ec311@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(Unlooping Sameer and Mohit, as they don't longer maintain the driver)

Hi John,

> -----Original Message-----
> From: John Sarman [mailto:johnsarman@gmail.com]
> Sent: Wednesday, July 15, 2009 4:45 PM
> To: sakari.ailus@nokia.com; Venkatraman, Sameer; Mohit Jalori; Aguirre
> Rodriguez, Sergio Alberto; Tuukka Toivonen; linux-media
> Subject: Help bringing up a sensor driver for isp omap34xx.c
> 
> Hello,
>    I am having a problem deciphering what is wrong with my sensor
> driver.  It seems that everything operates on the driver but that I am
> getting buffer overflows.  I have fully tested the image sensor and it
> is set to operate in 640x480 mode. currently it is like 648x 487 for
> the dummy pixels and lines.  I have enabled all the debugging #defines
> in the latest code from the gitorious repository.

Can you specify the gitorious repository URL you're using?

  I also had to edit
> a few debug statements because they cause the compile to fail. Those
> failures were due to the resizer rewrite and since the #defines were
> commented out that code was never compiled.  Anyways here is my dmesg
> after I open and select the /dev/video0.
> 
> I have been banging my head against a wall for 2 weeks now.
> 
> Thanks,
> 

<snip>

> ISPCTRL: <1>isp_buf_queue: queue 0 vb 0, mmu 000a4000
> ISPCTRL: <1>isp_buf_queue: queue 1 vb 1, mmu 0013a000
> ISPCTRL: <1>isp_buf_queue: queue 2 vb 2, mmu 001d0000
> ISPCTRL: <1>isp_buf_queue: queue 3 vb 3, mmu 00266000
> ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
> ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
> ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
> ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:

Seems that you're getting an overflow in the SBL (Shared Buffer Logic) component, which is the one that manages to save/load the buffers from memory.

It could happen because the SBL is writing pretty slow to memory...

Is it possible that you share your patches to integrate this sensor driver + boardfile changes you did?

That way I can help you more.

Regards,
Sergio

