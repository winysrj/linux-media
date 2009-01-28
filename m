Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.work.de ([212.12.32.20]:43781 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbZA1PSF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jan 2009 10:18:05 -0500
Message-ID: <49807720.2020808@gmail.com>
Date: Wed, 28 Jan 2009 19:17:52 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: darav@gmx.de
CC: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] S2API (pctv452e) artefacts in video stream
References: <496204D8.6090602@okg-computer.de><20090105130757.GW12059@titan.makhutov-it.de>	<49620916.7060704@dark-green.com> <8CB3D7E10E304E0-1674-1438@WEBMAIL-MY25.sysops.aol.com> <496B3494.4030500@okg-computer.de> <6940F926-0668-4B88-BF78-32C69EE51919@gmx.de> <158C8110-E256-44A4-9418-E45A94855F62@gmx.de>
In-Reply-To: <158C8110-E256-44A4-9418-E45A94855F62@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

darav@gmx.de wrote:
> Hi again,
> 
> has anybody an idea what's going wrong here?
> I'm still having this problem.
> Is there anything I can do to help here?
> 
> Thanks in advance,
> darav
> 
> P.S.: now posting on the new mailinglist. Sorry for double-post.
> 
> Jan 28 12:03:09 vdr ttusb2: i2c transfer failed.
> Jan 28 12:03:11 vdr dvb-usb: bulk message failed: -110 (9/0)
> Jan 28 12:03:11 vdr ttusb2: there might have been an error during
> control message transfer. (rlen = 3, was 0)
> Jan 28 12:03:11 vdr ttusb2: i2c transfer failed.
> Jan 28 12:03:13 vdr dvb-usb: bulk message failed: -110 (9/0)
> Jan 28 12:03:13 vdr ttusb2: there might have been an error during
> control message transfer. (rlen = 3, was 0)
> Jan 28 12:03:13 vdr ttusb2: i2c transfer failed.


Looks like the demodulator did not respond at all, maybe it went
bad. Does your device work in a windows environment ?

Regards,
Manu
