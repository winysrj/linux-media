Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f165.google.com ([209.85.217.165]:58456 "EHLO
	mail-gx0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162AbZCPSSQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 14:18:16 -0400
Received: by gxk9 with SMTP id 9so2065301gxk.13
        for <linux-media@vger.kernel.org>; Mon, 16 Mar 2009 11:18:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <164695.77575.qm@web56903.mail.re3.yahoo.com>
References: <164695.77575.qm@web56903.mail.re3.yahoo.com>
Date: Mon, 16 Mar 2009 14:18:13 -0400
Message-ID: <412bdbff0903161118o2d038bdetc4d52851e35451df@mail.gmail.com>
Subject: Re: Problems with Hauppauge HVR 1600 and cx18 driver
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Corey Taylor <johnfivealive@yahoo.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 16, 2009 at 2:10 PM, Corey Taylor <johnfivealive@yahoo.com> wrote:
>
> Hi, I just recently bought a Hauppauge Win TV HVR-1600 card and am using it with MythTV running on Ubuntu Intrepid 8.10 64-bit edition.
>
> My hardware is an Asus A8N VM-CSM Motherboard with an Athlon 64 single core CPU.
>
> I'm using the cx18 driver compiled from Mercurial (as of last weekend) and download the latest firmware files available from Hauppauge.
>
> The card is working and I'm able to tune in clear QAM channels on Comcast Cable in Boston.
>
> The
> problem is that when recording HD content I see excessive tearing in
> the recorded video. I thought it might be my on-board video causing
> this but I transferred a recording over to another machine and the
> video plays back with the same artifacts and tearing as when I play it
> on the machine that recorded the video.
>
> I previously had the KWorld ATSC 110 running in the same machine and it recorded HD content with no noticeable visual artifacts on the same cable line.
>
> I've tried tweaking many different settings both in MythTV and in X11 and nothing has made the problem go away.
>
> Is this card perhaps more sensistive to signal disruptions in my cable line perhaps?
>
> If
> no, I was thinking that the problem could be due to driver problems in
> the current development code. Are there any workaround for this problem
> or should I give up and switch back to my KWorld card?
>
> Thanks very much!

Corey,

As far as I know, with ATSC/QAM you typically won't see the same sort
of "tearing" artifacts with a digital source, as those sorts of
distortions are usually a product of analog transmission.  When you
encounter these issues with digital sources, it's usually some product
of the video card/X11 during playback.

Perhaps you should make a small clip of MPEG available on a public
HTTP server, so people can take a look and offer an opinion.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
