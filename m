Return-path: <linux-media-owner@vger.kernel.org>
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:1646 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753649Ab3FKKBt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jun 2013 06:01:49 -0400
From: Florian Neuhaus <florian.neuhaus@reberinformatik.ch>
To: "a.andreyanau@sam-solutions.com" <a.andreyanau@sam-solutions.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: mt9p031 shows purple coloured capture
Date: Tue, 11 Jun 2013 10:01:31 +0000
Message-ID: <6EE9CD707FBED24483D4CB0162E8546745F30330@AMSPRD0711MB532.eurprd07.prod.outlook.com>
Content-Language: de-DE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrei,

Your post helped me a lot!
My environment:
beagleboard-xm
mt9p031 @96Mhz (adapted power-supply)
linux-omap 3.7.10
omap3isp-live

I have two similiar issues with the mt9p031, that has probably the same cause:

If I use omap3isp-live to capture a stream on my beagleboard, the first time I start the app,
the picture has always a green taint. The second time I start the app, the picture is good. As the camera is reset by a gpio upon device open, probably the CCDC or previewer is not 
initialized correctly?
@Laurent: As I am unable to test it with another cam, does this also happen with your hardware
or is it a problem specific to the mt9p031?

The second problem is similiar to your problem:
omap3isp-live has (thanks to Laurent) a built in snapshot-mode. So I am doing the following:
1. Streaming video, picture looks good on the second start
2. Taking a snapshot: The video stream will turn off, the isp-pipe reconfigured. Then the stream
will be turned back on and the captured image will be written to memory.
3. The captured image will now be displayed, but the image is corrupted: Wrong colors and cut in half: https://www.dropbox.com/s/ijk1nq8nrhlobfd/bad-snapshot.jpg
4. It doesn't help to skip a few buffers, also the 3rd buffer looks bad.
5. Additional problem: The CCDC can't be stopped properly (omap3isp omap3isp: Unable to stop OMAP3 ISP CCDC) and sometimes the isp locks up completely.

> So I used the register 0x0B (Restart), bit 0 (abandon the current frame and
> restart from the first row) set to 1 each time the function s_stream is called.

The finding so far: If I do a frame-restart (the register 0x0b on mt9p031) upon stream-on, the CCDC can be stopped properly and the snapshot looks pretty good. BUT the colors are still messed up. If I then switch to streaming again, the colors sometimes turn to good but sometimes the picture is purple tainted.
@Andrei: What have you done to get good colors? 

>> Wrong clock or *sync polarity selection? Which leads to random
>> start-of-frame misplacement?
>> 
> Do you mean pixel clock polarity? If so, I checked it - with it being inverted -
> the image capture goes well (purple color also appears from time to time),
> but in the case it is not inverted I see a noise on the screen.

Inverted the pixel-clock on the mt9p031 side (register 0x0a, bit 15)? I inverted the clock, but then the streaming had a purple taint.

Regards,
Florian


