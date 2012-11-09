Return-path: <linux-media-owner@vger.kernel.org>
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:17383
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753914Ab2KIP6H convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Nov 2012 10:58:07 -0500
From: Florian Neuhaus <florian.neuhaus@reberinformatik.ch>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"sakari.ailus@iki.fi" <sakari.ailus@iki.fi>,
	"dacohen@gmail.com" <dacohen@gmail.com>
Subject: AW: [omap3-isp-live] Autofocus buffer interpretation of H3A engine
Date: Fri, 9 Nov 2012 15:57:58 +0000
Message-ID: <6EE9CD707FBED24483D4CB0162E854671008F9FD@AM2PRD0710MB375.eurprd07.prod.outlook.com>
References: <6EE9CD707FBED24483D4CB0162E854671007E05D@AM2PRD0710MB375.eurprd07.prod.outlook.com>
 <1588578.t5rbryooTj@avalon>
In-Reply-To: <1588578.t5rbryooTj@avalon>
Content-Language: de-DE
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote on 2012-11-04:

> The AD5821 is similar to the AD5820, for which I have a driver that I need to
> clean up and post. Would you be interested in that ?
Yes, you can send me the driver. Just as a note:
I (probably) found an error in the current ad5398 and ad5821 driver 
http://lxr.free-electrons.com/source/drivers/regulator/ad5398.c
It seems that the enable and disable functions are switched
(at least for the ad5821). Also it's not possible to set the maximum current.
I've done a patch but didn't have the time to submit it. Is this the right place
for it?

> Even though that buffer structure is pretty simple, I'm afraid I can't provide
> that information as it's covered by an NDA.
I have written the TI-support and here's the answer:
START QUOTE
" After checking it seems that we unfortunately do not make the DM37x H3A documention available. 
Implementing Autofocus is quite complexe and the documentation is likely not going to provide enough help. 
A lot of experience is required to handle the mecanics and control loop aspect for the Autofocus.

We have partners that do have experience with the H3A module and that might be able to help. 
For example MMS that mentionned is the below document:
     http://www.ti.com/lit/ml/swpt052/swpt052.pdf
Also Leopard Imaging has experience on the H3A:
    https://www.leopardimaging.com/Services.html
END QUOTE

It's sad that they can't provide any further information, because we are not that far
to get this stuff working...

> could try to figure it out ourselves. Looking at the FCam project, I've
> found
> 
> http://vcs.maemo.org/svn/fcam/fcam-
> dev/tags/1.1.0/src/N900/V4L2Sensor.cpp
> 
> Does that help figuring out what the buffer contains ?

That helps a lot! Thank you. I found also a little info here:
http://www.mail-archive.com/davinci-linux-open-source@linux.davincidsp.com/msg18438.html

> I haven't started, and it's currently not on my to-do list I'm afraid.
That's too bad, as your help is always appreciated. Have you already seen my patch for the
rotation in your omap3-isp-live program? I have seen also another little issue, if you are
interested (snapshot_init should be after aewb as the output format changes during
snapshot-init).

I am now off for 3 weeks (annual refresher course in the Swiss armed forces).

Regards,
Florian



