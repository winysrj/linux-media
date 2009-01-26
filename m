Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:43060 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbZAZPjt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jan 2009 10:39:49 -0500
Received: by yx-out-2324.google.com with SMTP id 8so2576906yxm.1
        for <linux-media@vger.kernel.org>; Mon, 26 Jan 2009 07:39:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <640929.18092.qm@web23204.mail.ird.yahoo.com>
References: <640929.18092.qm@web23204.mail.ird.yahoo.com>
Date: Mon, 26 Jan 2009 15:39:48 +0000
Message-ID: <157f4a8c0901260739p424a74f6rcca2d84df04737b9@mail.gmail.com>
Subject: Re: [linux-dvb] Technotrend Budget S2-3200 Digital artefacts on
	HDchannels
From: Chris Silva <2manybills@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 26, 2009 at 2:40 PM, Newsy Paper
<newspaperman_germany@yahoo.com> wrote:
> the transponders you don't get lock are problem transponders of s2-3200.
> The driver is still not able to lock on dvb-s2 30000 3/4 transponders :(
>
> Which software do you use to play HD content?
> you need either xine-lib 1.2 with external ffmpeg (recent developer's version).
> or xine-vdpau (if you have a NVIDIA graka that supports h264 hw acceleration).
>
> regards
>
> Newsy

I can confirm this. I use S30W (Hispasat) and one of the providers,
Meo, broadcasts everything on DVB-S2 30000 3/4.
I can't get a lock on any of the transponders/channels. And to make
matters worse, not even scan-s2 can get a really usable channel list.
I had to build the list by hand, according to
http://pt.kingofsat.net/pack-meo.php page.

And it still doesn't work.

I use vdr-xine and xineliboutput with vdr 1.7.0 and up, plus
xine-vdpau to no avail.

What's the point of having a DVB-S2 card if we can't tune to those
channels? What's missing in the S2-3200 drivers?

Chris
