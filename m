Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:41542 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755343Ab2DWOgY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 10:36:24 -0400
Received: by qcsq13 with SMTP id q13so9106547qcs.17
        for <linux-media@vger.kernel.org>; Mon, 23 Apr 2012 07:36:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120420204242.GM5356@valkosipuli.localdomain>
References: <414D8776B339BF44ADF9839A98A591A0046B8C63@EUDUCEX3.europe.ad.flextronics.com>
 <20120420204242.GM5356@valkosipuli.localdomain>
From: "Aguirre, Sergio" <saaguirre@ti.com>
Date: Mon, 23 Apr 2012 09:36:01 -0500
Message-ID: <CAKnK67R6mZuDBwU5rM20zPjpcUcqdTZ6DPSUzVdq=fkX_A0Tog@mail.gmail.com>
Subject: Re: Mipi csi2 driver for Omap4
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Steve Lindell <Steve.Lindell@se.flextronics.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve, Sakari,

On Fri, Apr 20, 2012 at 3:42 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Steve,
>
> On Fri, Apr 20, 2012 at 12:11:38PM +0200, Steve Lindell wrote:
>> Hi! I'm developing a mipi csi2 receiver for test purpose and need some
>> help of how to capture the data stream from a camera module. I'm using a
>> phytec board with a Omap4430 processor running Linux kernel 3.0.9.
>> Connected to the MIPI lanes I have a camera module (soled on a flexfilm)
>> The camera follows the Mipi csi2 specs and is controlled via an external
>> I2C controller. I have activated the camera and its now transmitting a
>> test pattern on the Mipi lines (4 line connection).
>>
>> I need to capture the stream and store it as a Raw Bayer snapshot. Is this
>> possible use Omap4430 and does Linux have the necessary drivers to capture
>> the stream. If this driver exists are there any documentation of how to
>> implement the driver?
>>
>> Is it possible to get some help of how to get started?
>
> Sergio Aguirre has posted the patches for the Omap 4 Iss to this list some
> time ago. I believe you'll also be able to find them here:
>
> <URL:https://gitorious.org/omap4-v4l2-camera/pages/Home>

Thanks Sakari for the reference.

>
> I guess you'd be also better off using a newer kernel than that.
>
> Hope this helps... Cc Sergio.

Steve,

I think it'll be easier for you to consider my code as a reference, and
follow as a reference the pandaboard implementation i've been maintaining.

Take a look specially at the "devel" branch, and to these files:

# Board file
arch/arm/mach-omap2/board-omap4panda-camera.c

# OV5650 Sensor file (which is RAW10)
drivers/media/video/ov5650.c

Please let me know any questions you might have.

I can help you out on getting what you need.

Regards,
Sergio

>
> Regards,
>
> --
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi     jabber/XMPP/Gmail: sailus@retiisi.org.uk
