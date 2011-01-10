Return-path: <mchehab@pedra>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:4301 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab1AJSD1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 13:03:27 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Daniel Drake" <dsd@laptop.org>
Subject: Re: [RFCv2 PATCH 0/5] Use control framework in cafe_ccic and s_config removal
Date: Mon, 10 Jan 2011 19:03:08 +0100
Cc: "Jonathan Corbet" <corbet@lwn.net>, linux-media@vger.kernel.org,
	"Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
References: <1294484508-14820-1-git-send-email-hverkuil@xs4all.nl> <AANLkTi=9jZPTin=0TCrfPeiO9koE69pQLkqFjHOhLMZA@mail.gmail.com> <7be530a8d14997437511b57e7504785a.squirrel@webmail.xs4all.nl>
In-Reply-To: <7be530a8d14997437511b57e7504785a.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101101903.08675.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday, January 10, 2011 12:08:42 Hans Verkuil wrote:
> > Hi,
> >
> >>> Another reason why s_config is a bad idea.
> >
> > Thanks a lot for working on this. I had a quick look and don't have
> > any objections.
> >
> >>> This has been extensively tested on my humble OLPC laptop (and it took
> >>> me 4-5
> >>> hours just to get the damn thing up and running with these drivers).
> >
> > In future, come into irc.oftc.net #olpc-devel and talk to me (dsd) or
> > cjb (Chris Ball), we'll get you up and running in less time!
> 
> If you have a link to some instructions on how to get the latest kernel up
> and running for olpc, then that would be handy :-)
> 
> > I'll test the via-camera patch unless Jon beats me too it, but won't
> > be immediately. If you are ever interested in doing more in-depth work
> > on that driver, please drop me a mail and we will send you a XO-1.5.
> 
> It's just for ongoing V4L2 maintenance (such as this sort of work).
> 
> >
> > Also, perhaps you are interested in working on this bug, which is
> > probably reproducible with cafe_ccic too:
> > http://www.mail-archive.com/linux-media@vger.kernel.org/msg23841.html
> 
> I'll see if I can reproduce this with cafe_ccic. Weird that I haven't seen
> this before. The code looks fishy: my first guess is that sd->flags should
> be put in a local variable before it is being tested.
> 
> I must have missed that bug report the first time around.

I'm pretty sure that this simple patch will fix it:

diff --git a/drivers/media/video/v4l2-device.c b/drivers/media/video/v4l2-device.c
index 7fe6f92..83a2e69 100644
--- a/drivers/media/video/v4l2-device.c
+++ b/drivers/media/video/v4l2-device.c
@@ -100,6 +100,7 @@ void v4l2_device_unregister(struct v4l2_device *v4l2_dev)
 			   is a platform bus, then it is never deleted. */
 			if (client)
 				i2c_unregister_device(client);
+			continue;
 		}
 #endif
 #if defined(CONFIG_SPI)
@@ -108,6 +109,7 @@ void v4l2_device_unregister(struct v4l2_device *v4l2_dev)
 
 			if (spi)
 				spi_unregister_device(spi);
+			continue;
 		}
 #endif
 	}


If you have time, then I'd appreciate it if you could check that this fixes it
for via_camera. I'll try to test with on cafe_ccic as well some time this week.

This bug is only triggered when a i2c module is unloaded on a platform i2c bus.

This doesn't happen on PCI/USB i2c busses, which is the reason why I never saw
it.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
