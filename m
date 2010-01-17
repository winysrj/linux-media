Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:42534 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab0AQPnW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jan 2010 10:43:22 -0500
Received: by bwz27 with SMTP id 27so1577459bwz.21
        for <linux-media@vger.kernel.org>; Sun, 17 Jan 2010 07:43:20 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: joep admiraal <joep@groovytunes.nl>
Subject: Re: prof 7300
Date: Sun, 17 Jan 2010 17:42:53 +0200
Cc: V4L Mailing List <linux-media@vger.kernel.org>
References: <201001171542.27314.joep@groovytunes.nl>
In-Reply-To: <201001171542.27314.joep@groovytunes.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="koi8-r"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201001171742.54145.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17 января 2010 16:42:27 joep admiraal wrote:
> I had some troubles with a prof 7300 dvb s-2 card.
> I am running OpenSuse 11.2 with a recent hg copy of the v4l-dvb repository.
> It was detected as a Hauppauge WinTV instead of a prof 7300.
> After some runs with info_printk statements I found a problem in
> linux/drivers/media/video/cx88.c
> As far as I can understand the code I would say card[core->nr] will always
> be smaller than ARRAY_SIZE(cx88_boards).
> Therefore core->boardnr is never looked up from the cx88_subids array.
> After I removed the check with ARRAY_SIZE the correct card is detected and
> I can watch tv with both my prof 7300 cards.
> Can someone confirm if the patch I made is correct or explain what the
> purpose is of the ARRAY_SIZE check?
>
>
> For search references:
> I was getting this error in dmesg:
> cx88[1]/2: dvb_register failed (err = -22)
> cx88[1]/2: cx8802 probe failed, err = -22
>
> Regards,
> Joep Admiraal
Do/did you have another TV tuner?
Please check file /etc/modprobe.conf or files in /etc/modprobe.d/ for line like this
	options cx88xx card=n
Then remove the line

You can try to check your card
	modprobe cx88xx card=75

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
