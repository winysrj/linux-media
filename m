Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:50358 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752910Ab2GNL3s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jul 2012 07:29:48 -0400
Message-ID: <1342265363.2362.12.camel@tbastian-desktop.localdomain>
Subject: libv4l2: error dequeuing buf: Resource temporarily unavailable
From: "llarevo@gmx.net" <llarevo@gmx.net>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Sat, 14 Jul 2012 13:29:23 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm not sure, if this is the right list, if I'm wrong here, a hint for a
appropriate place for my questions would be very appreciated.

I have a problem with an analog Terratec Cinergy 400 TV. When I try to
capture with ffmpeg, 

ffmpeg -f video4linux2 -i /dev/video0 out.mpg

I get the error

libv4l2: error dequeuing buf: Resource temporarily unavailable

I'm using Fedora F17. 

The behavior seems to be pretty strange to me, because xawtv, mencoder,
mplayer and tvtime don't have a problem with the hardware at all, ffmpeg
has got this problem only with the hardware mentioned above, with a
Terratec Cinergy XS, ffmpeg captures without problems.

Why reports libv4l2 "Resource temporarily unavailable"? What are common
reasons for that message? What can be a reason that creates the message
only on specific hardware (Terratec Cinergy 400 TV)?

Thanks a lot in advance. 

--
Felix


