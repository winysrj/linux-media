Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64607 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266Ab2AZXXl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jan 2012 18:23:41 -0500
Received: by dadi2 with SMTP id i2so891664dad.19
        for <linux-media@vger.kernel.org>; Thu, 26 Jan 2012 15:23:41 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 27 Jan 2012 00:23:41 +0100
Message-ID: <CAOjJLeBa8AZ8sRWCCQPzXXHi6JeTpDWB1sUaZxPyx_JrnxV=Mw@mail.gmail.com>
Subject: Terratex dvb size wrong
From: andrea zambon <zamby.ing@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I own a tv usb key (dvb-t), Slackware 13.37, kernel 3.0.18:

dvb-usb: found a 'Terratec Cinergy T USB XXS (HD) / T3' in cold state, will
try to load a firmware
dvb-usb: downloading firmware from file 'dvb-usb-dib0700 1.20.fw'
dvb-usb: found a 'Terratec Cinergy T USB XXS (HD) / T3' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software
demuxer.
dvb-usb: Terratec Cinergy T USB XXS (HD) / T3 successfully initialized and
connected.
usbcore: registered new interface driver dvb_usb_dib0700

I have created the configuration file of the channels. When I use:

mplayer dvb://channel -demuxer mpegts -vf pp=lp

I get a video with size wrong.
The X window is 16:9 but the image is 4:3 in the center of the window
with black
bars on the sides.

With Fedora 16 or Ubuntu, the video is correct 16:9.

Where is the problem?

Thank you.
