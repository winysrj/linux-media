Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f42.google.com ([209.85.212.42]:43446 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaATSdA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jan 2014 13:33:00 -0500
Received: by mail-vb0-f42.google.com with SMTP id i3so2588062vbh.15
        for <linux-media@vger.kernel.org>; Mon, 20 Jan 2014 10:33:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52DD6A48.8000003@fnxweb.com>
References: <52DC04E8.8020406@fnxweb.com>
	<CALzAhNWjweoydgDHpU+nJRQYYTRGkreE2v0ZYBgNS3a-yGYY8A@mail.gmail.com>
	<52DD6A48.8000003@fnxweb.com>
Date: Mon, 20 Jan 2014 13:33:00 -0500
Message-ID: <CAGoCfiwG0PDUF24138+38SU0T3BiSNmeqqXW7-9vmUwnGgEuPQ@mail.gmail.com>
Subject: Re: Problem getting sensible video out of Hauppauge HVR-1100 composite
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Neil Bird <gnome@fnxweb.com>
Cc: Steven Toth <stoth@kernellabs.com>,
	Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 20, 2014 at 1:26 PM, Neil Bird <gnome@fnxweb.com> wrote:
>   But, flip me, it's spewing 800 MB+ for a minute's worth of video. That'd
> be ~48GB for an hour's TV (the intention is to use this for a MythTV PVR).
>
>   Am I likely to be able to do anything about that?  Even with
> post-transcoding that's going to be an excessive amount of filing to deal
> with :-(

The device doesn't have an MPEG encoder - you're getting raw
uncompressed video.  You would either have to buy a different device
that has an encoder or do software encoding in real-time to MPEG2 or
H.264 if your goal is to store the video.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
