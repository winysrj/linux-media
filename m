Return-path: <linux-media-owner@vger.kernel.org>
Received: from fallback.mail.timico.net ([62.121.11.168]:45380 "EHLO
	fallback.mail.timico.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab1ITGaO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Sep 2011 02:30:14 -0400
Received: from [62.121.20.91] (helo=relay.timico.net)
	by fallback.mail.timico.net with esmtp (Exim 4.69)
	(envelope-from <Jon.Povey@racelogic.co.uk>)
	id 1R5tWs-0003hH-Cy
	for linux-media@vger.kernel.org; Tue, 20 Sep 2011 07:10:02 +0100
From: Jon Povey <Jon.Povey@racelogic.co.uk>
To: Manjunath Hadli <manjunath.hadli@ti.com>,
	LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>
Content-Class: urn:content-classes:message
Date: Tue, 20 Sep 2011 07:09:54 +0100
Subject: RE: [PATCH RESEND 2/4] davinci vpbe: add dm365 VPBE display driver
 changes
Message-ID: <70E876B0EA86DD4BAF101844BC814DFE0BF22415C3@Cloud.RL.local>
In-Reply-To: <1316410529-14744-3-git-send-email-manjunath.hadli@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

davinci-linux-open-source-bounces@linux.davincidsp.com wrote:
> This patch implements the core additions to the display driver,
> mainly controlling the VENC and other encoders for dm365.
> This patch also includes addition of amplifier subdevice to the
> vpbe driver and interfacing with venc subdevice.

One small nit.
Sorry about the probably broken quoting to follow.

> @@ -704,6 +717,39 @@ static int vpbe_initialize(struct device
> *dev, struct vpbe_device *vpbe_dev)
> +                         v4l2_warn(&vpbe_dev->v4l2_dev, "non-i2c amplifiers"
> +                         " currently not supported");
> +             }
> +     } else
> +         vpbe_dev->amp = NULL;

iirc this is not kernel style, if the "then" side of an if needs braces
then the "else" side must have them too.

--
Jon Povey
jon.povey@racelogic.co.uk

Racelogic is a limited company registered in England. Registered number 2743719 .
Registered Office Unit 10, Swan Business Centre, Osier Way, Buckingham, Bucks, MK18 1TB .

The information contained in this electronic mail transmission is intended by Racelogic Ltd for the use of the named individual or entity to which it is directed and may contain information that is confidential or privileged. If you have received this electronic mail transmission in error, please delete it from your system without copying or forwarding it, and notify the sender of the error by reply email so that the sender's address records can be corrected. The views expressed by the sender of this communication do not necessarily represent those of Racelogic Ltd. Please note that Racelogic reserves the right to monitor e-mail communications passing through its network


