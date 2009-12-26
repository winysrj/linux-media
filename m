Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f192.google.com ([209.85.212.192]:37065 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbZLZHqZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Dec 2009 02:46:25 -0500
Received: by vws30 with SMTP id 30so3049352vws.33
        for <linux-media@vger.kernel.org>; Fri, 25 Dec 2009 23:46:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091226012943.tdopjls1wg80g80c@webmail.iol.pt>
References: <20091226012943.tdopjls1wg80g80c@webmail.iol.pt>
Date: Fri, 25 Dec 2009 23:46:23 -0800
Message-ID: <a3ef07920912252346i431f6351q36e0561da8143fce@mail.gmail.com>
Subject: Re: Linux Server (without GUI) streaming skystar chanel to TV through
	graphic card
From: VDR User <user.vdr@gmail.com>
To: valenzuela@iol.pt
Cc: linux-media@vger.kernel.org, linuxtv@irc.freenode.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 25, 2009 at 5:29 PM,  <valenzuela@iol.pt> wrote:
> Dear all,
>
> I would like to transmit/stream a channel from skystar (on a Ubuntu Linux
> server) to a TV through ATI X300 SE (128MB) graphic card (s-video
> interface).
>
> It is possible to do transmit the channel without a gui (gnome, for
> instance) in the server? What I really want is to redirect the output from
> skystar to graphic card (connected to a TV through s-video or VGA).

I do that using VDR.  I use dvb cards in a Debian linux box.  Then I
run VDR (http://www.tvdr.de) with the vdr-xine plugin, and have my
output going to an Nvidia video card.  I use a DVI->HDMI cable going
from the video card to a 60" tv.  I've also connected my mainboard
SPDIF-OUT to the video card SPDIF-IN so both audio and video are
transmitted on the DVI-HDMI cable.  The reason for using the Nvidia
video card was mainly to take advantage of vdpau which offloads the
mpeg 2/4 decoding to the gpu instead of cpu (ie: allowing you to do
HDTV on a slow/low power cpu).
