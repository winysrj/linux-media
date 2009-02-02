Return-path: <linux-media-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.187]:39310 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbZBBMen (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2009 07:34:43 -0500
Received: by mu-out-0910.google.com with SMTP id g7so1029212muf.1
        for <linux-media@vger.kernel.org>; Mon, 02 Feb 2009 04:34:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0902012344400.17985@axis700.grange>
References: <7951d5d30901311346i162ce575j76fd660fa0b0e176@mail.gmail.com>
	 <7951d5d30901311349l769195b7x9202b78970b6b8b5@mail.gmail.com>
	 <Pine.LNX.4.64.0902012344400.17985@axis700.grange>
Date: Mon, 2 Feb 2009 13:34:41 +0100
Message-ID: <7951d5d30902020434l123b69b1vf4334701cbfa9e58@mail.gmail.com>
Subject: Re: PXA Quick capture interface with HV7131RP-Camera
From: Bennet Fischer <bennetfischer@googlemail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

struct pxacamera_platform_data gumstix_pxacamera_platform_data = {
	.init	= gumstix_pxacamera_init,
	.flags  = PXA_CAMERA_MASTER | PXA_CAMERA_DATAWIDTH_8 |
		PXA_CAMERA_PCLK_EN | PXA_CAMERA_MCLK_EN | PXA_CAMERA_PCP,
	.mclk_10khz = 1000,
};

^^ some register values are overwritten by my driver, so the more
interesting part are the register values of the quick capture
interface.

Here are the register values taken at the end of the capture:

CICR0: 900003FF
- DMAEN = 1
- ENB = 1
- All interrupts masked

CICR1: 13F8012
- DW = 2 (8 Bit)
- COLOR_SP = 2 (YCbCr)
- PPL = 639

CICR2: 0

CICR3: 1DF
- LPF = 479

CICR4: D80005
- DIV = 5
- MCLK_EN = 1
- VSP = 1
- PCP = 1
- PCLK_EN = 1

CISR: 0
^^ No interrupt flag is set

CITOR: 0

CIFR: 0 (even by enabling the fifos with 7 it doesn't work)


So according to the registers it should work. I even checked if the
PCLK, FV and LV signals arrive at the CPU by reading the according
pins as GPIOs.



2009/2/1 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> On Sat, 31 Jan 2009, Bennet Fischer wrote:
>
>> Hi
>>
>>
>> I am trying to get a camera to work together with an PXA270 processor.
>> My system has the following specs:
>>
>> Platform: Gumstix Verdex Pro
>> Camera: HV7131RP
>> OS: Linux 2.6.28
>>
>> I wrote a simple driver for the camera which omits all the i2c-stuff
>> because the camera starts already in a default configuration which
>> works fine for me.
>> A V4L2-device is generated and everything looks fine. But when i start
>> to capture, no data arrives BUT the Quick Capture Interface outputs a
>> MCLK and the camera responds with a PCLK, LV and FV (and data of
>> couse).
>> For getting a bit closer to the origin of the problem I disabled DMA
>> in pxa_camera.c and enabled all Interrupts in the CICR0 register. No
>> interrupt is generated. Even by disabling DMA and IRQ and looking into
>> CISR nothing happens.
>> I checked all the CIF registers bitwise. The polarity of the LV and FV
>> is correct, the alternate pin functions are correct, the interrupt bit
>> is non-masked, the size of the pixel matrix is correct. I'm a bit
>> desperate because at the moment I have no idea what to do next. I
>> would be thankful for any hint.
>
> Maybe you could post your platform data, i.e., your struct
> pxacamera_platform_data?
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
>
