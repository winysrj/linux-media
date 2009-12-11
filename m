Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:46311 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbZLKQ4T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2009 11:56:19 -0500
Received: by yxe17 with SMTP id 17so948364yxe.33
        for <linux-media@vger.kernel.org>; Fri, 11 Dec 2009 08:56:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <37367b3a0912080842h601be618tdc4151ba226bbb60@mail.gmail.com>
References: <37367b3a0912071113y41efc736h20a6fe203244811d@mail.gmail.com>
	 <Pine.LNX.4.64.0912072052030.8481@axis700.grange>
	 <37367b3a0912080842h601be618tdc4151ba226bbb60@mail.gmail.com>
Date: Fri, 11 Dec 2009 14:56:25 -0200
Message-ID: <37367b3a0912110856p24462203q481d6c330380c665@mail.gmail.com>
Subject: Re: soc_camera: OV2640
From: Alan Carvalho de Assis <acassis@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 12/8/09, Alan Carvalho de Assis <acassis@gmail.com> wrote:
> Hi Guennadi,
...
>>> I am trying to use an OV2640 camera with soc_camera.
>>>
>>> I'm using ov772x driver as base, but it needs too much modification to
>>> work with ov2640.
>>
>> I don't know that sensor specifically, but they can be quite different.
>>
>
> Yes, in fact ov2640 appears quite different compared to ov772x and ov9640.
>
>>> The OV2640 chip remaps all registers when register 0xFF is 1 or when it
>>> is
>>> 0.
>>
>> This is not unusual. There are a few ways to implement this, for example,
>> drivers/media/video/rj54n1cb0c.c uses 16-bit addresses, and decodes them
>> to bank:register pairs in its reg_read() and reg_write() routines.
>>
>
> Ok, I will try to implement it this way, case nobody suggests me a
> better approach.
>

I got mx27_camera from pengutronix tree and modified it to work with
kernel 2.6.32 (few modifications). I added platform data/device on my
board using pcm970-baseboard.c as example.

In the kernel config I selected:
CONFIG_VIDEO_MX27
CONFIG_SOC_CAMERA_OV9640


I noticed a strange behavior: the ov9640 driver is called before mx27_camera:

Linux video capture interface: v2.00
>>> Probe OK until now, going to ProbeVideo <<<
>>> Probing OV9640 <<<
Parent missing or invalid!
Driver for 1-wire Dallas network protocol.
i.MX SDHC driver
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
oprofile: using timer interrupt.
TCP cubic registered
NET: Registered protocol family 17
mx27-camera mx27-camera.0: initialising
>>> mx27_camera: IRQ request OK!
>>> mx27_camera: pcdev OK!
>>> mx27_camera: clk_csi OK!
mx27-camera mx27-camera.0: Camera clock frequency: 26600000
>>> mx27_camera: DMA request OK!
mx27-camera mx27-camera.0: Using EMMA
>>> mx27_camera: probe OK until now!
mx27-camera mx27-camera.0: Non-NULL drvdata on register
>>> mx27_camera: soc_camera_host_register returned 0!

Then ov9640 returns error because icd->dev.parent doesn't exist.

Did you already see this issue?

Best Regards,

Alan
