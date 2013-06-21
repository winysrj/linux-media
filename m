Return-path: <linux-media-owner@vger.kernel.org>
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:12934
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423210Ab3FUPX7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 11:23:59 -0400
From: Florian Neuhaus <florian.neuhaus@reberinformatik.ch>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "a.andreyanau@sam-solutions.com" <a.andreyanau@sam-solutions.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: AW: mt9p031 shows purple coloured capture
Date: Fri, 21 Jun 2013 15:23:53 +0000
Message-ID: <6EE9CD707FBED24483D4CB0162E8546745F4216D@AMSPRD0711MB532.eurprd07.prod.outlook.com>
References: <6EE9CD707FBED24483D4CB0162E8546745F30330@AMSPRD0711MB532.eurprd07.prod.outlook.com>
 <3299481.jsSH8LsWuG@avalon>
In-Reply-To: <3299481.jsSH8LsWuG@avalon>
Content-Language: de-DE
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote on 2013-06-18:

>> If I use omap3isp-live to capture a stream on my beagleboard, the first
>> time I start the app, the picture has always a green taint. The second
>> time I start the app, the picture is good. As the camera is reset by a
>> gpio upon device open, probably the CCDC or previewer is not
>> initialized correctly? @Laurent: As I am unable to test it with another
>> cam, does this also happen with your hardware or is it a problem
>> specific to the mt9p031?
> 
> Last time I've tested my MT9P031 sensor with the Beagleboard-xM there
> was no such issue.
If I test it with yavta, it works also from the very first start. So there
must be an issue in my (adapted) omap3-isp-live.

> 
>> The second problem is similiar to your problem:
>> omap3isp-live has (thanks to Laurent) a built in snapshot-mode. So I
>> am doing the following:
>> 1. Streaming video, picture looks good on the second start 2. Taking a
>> snapshot: The video stream will turn off, the isp-pipe reconfigured.
>> Then the stream will be turned back on and the captured image will be
>> written to memory.
>> 3. The captured image will now be displayed, but the image is corrupted:
>> Wrong colors and cut in half:
>> https://www.dropbox.com/s/ijk1nq8nrhlobfd/bad-snapshot.jpg
>> 4. It doesn't help to skip a few buffers, also the 3rd buffer looks bad.
>> 5. Additional problem: The CCDC can't be stopped properly (omap3isp
>> omap3isp: Unable to stop OMAP3 ISP CCDC) and sometimes the isp locks
>> up completely.
>> 
>>> So I used the register 0x0B (Restart), bit 0 (abandon the current
>>> frame and restart from the first row) set to 1 each time the
>>> function s_stream is called.
>> 
>> The finding so far: If I do a frame-restart (the register 0x0b on
>> mt9p031) upon stream-on, the CCDC can be stopped properly and the
>> snapshot looks pretty good. BUT the colors are still messed up. If I
>> then switch to streaming again, the colors sometimes turn to good but
>> sometimes the picture is purple tainted. @Andrei: What have you done to
>> get good colors?
The color problem goes away nearly completely, if I do a power-off and 
on in the mt9p031_s_stream function. It then happens only 
1 out of 10 times. At least an improvement ;)
I have the feeling, that the CCDC doesn't get all data on a stream restart
and that causes a buffer corruption. Probably the sensor doesn't
start outputting from the beginning (even with a frame restart).
Any ideas on this?

Regards,
Florian


