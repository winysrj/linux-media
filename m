Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46334 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab1KMQQr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Nov 2011 11:16:47 -0500
Received: by vcbf1 with SMTP id f1so4513714vcb.19
        for <linux-media@vger.kernel.org>; Sun, 13 Nov 2011 08:16:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EBFE427.9010605@lockie.ca>
References: <CAA7M+FBvP0A7L6o-Fw4CQ2xR2CYqu233L+83BGGOcLooK0bk7w@mail.gmail.com>
	<CAGoCfiw+yy3Hz=7yvGTYrYQn5VfNh3CrabS_Kxx7G88jcwt9aQ@mail.gmail.com>
	<20111112141403.53708f28@hana.gusto>
	<CAGoCfiwnOTv=yhFeAsjQ+=5vrsUfy5b8HqtXGiFuimXe2M-+Bw@mail.gmail.com>
	<CAA7M+FAi517fUjLUxLsVSMr99N+2gpuhJMoiTbsuxyKGuf7-Kw@mail.gmail.com>
	<CAA7M+FCWHwRvX4UYGOqnN2yd+SyUDhbs7sn9djVy=Px0EMw6eg@mail.gmail.com>
	<4EBFE427.9010605@lockie.ca>
Date: Sun, 13 Nov 2011 16:16:46 +0000
Message-ID: <CAA7M+FBKQ+uk-D9-ZZbvXW7-w3yfZ0sftpjLgd4xU7Ce2uRYFw@mail.gmail.com>
Subject: Re: HVR-4000 may be broken in kernel mods (again) ?
From: "jonathanjstevens@gmail.com" <jonathanjstevens@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks all for your feedback.

I've been investigating the Xen angle as well and there seem to be
quite a few reports of DVB cards not working in Xen at the moment.

The culprit "appears" to be something to do with DMA, although whether
it's Xen or the drivers remains to be seen
.
>From what I can tell, the card tunes OK but then when the driver tries
to access the datastream (via DMA) things go bad.

If anyone knows of a good way to look deeper into this area - please
let me know!

Anyway, I'm going to go and hassle the Xen developers to see if they
can shed some more light on this.

I'll also have a play with vlc.

>
> Try mplayer (or VLC) directly.
> Kaffeine uses a pipe from mplayer.
> I use VLC to open my channels.conf (I forget which file format, mplayer format?) which works.
> Mplayer doesn't work very well on my system but vlc does.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
