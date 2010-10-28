Return-path: <mchehab@pedra>
Received: from mailgate.plextek.co.uk ([62.254.222.163]:24004 "EHLO
	mailgate.plextek.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab0J1KWn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Oct 2010 06:22:43 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: Changing frame size on the fly in SOC module
Date: Thu, 28 Oct 2010 11:12:53 +0100
Message-ID: <8C9A6B7580601F4FBDC0ED4C1D6A9B1D02AF331B@plextek3.plextek.lan>
From: "Adam Sutton" <aps@plextek.co.uk>
To: <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

Sometime ago I developed an SOC based camera driver for my platform
(ov7675 on iMX25), for the most part it seems to be working well however
at the time I couldn't manage to change the frame size on the fly
(without closing / re-opening the device).

The current problem I have is that my application needs to display a
320x240 preview image on screen, but to capture a static image at
640x480. I can do this as long as I close the device in between,
unfortunately for power consumption reasons the camera device is put
into a low power state whenever the device is released. This means that
the image capture takes approx 1.5s (the requirement I have to meet is
1s).

Now I could cheat and simply subsample (in software) the 640x480 image,
but that puts additional burden on an already overworked MCU.

Having been through the soc_camera and videobuf code and as far as I can
tell this inability to change the frame size without closing the camera
device appears to be a design decision.

What I'm really after is confirmation one way of the other. If it's not,
what is the correct process to achieve the frame change without closing
the device. And if it is, does anybody have any suggestions of possible
workarounds?

Thanks
Adam


Plextek Limited
Registered Address: London Road, Great Chesterford, Essex, CB10 1NY, UK Company Registration No. 2305889
VAT Registration No. GB 918 4425 15
Tel: +44 1799 533 200. Fax: +44 1799 533 201 Web:http://www.plextek.com 
Electronics Design and Consultancy

