Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f171.google.com ([209.85.216.171]:61711 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaATSem (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jan 2014 13:34:42 -0500
Received: by mail-qc0-f171.google.com with SMTP id n7so6324700qcx.30
        for <linux-media@vger.kernel.org>; Mon, 20 Jan 2014 10:34:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52DD6A48.8000003@fnxweb.com>
References: <52DC04E8.8020406@fnxweb.com>
	<CALzAhNWjweoydgDHpU+nJRQYYTRGkreE2v0ZYBgNS3a-yGYY8A@mail.gmail.com>
	<52DD6A48.8000003@fnxweb.com>
Date: Mon, 20 Jan 2014 13:34:42 -0500
Message-ID: <CALzAhNVY9SSB_7c57RuN5ZSo6hqfMiq1tBVLzBmvznY9h7dd6g@mail.gmail.com>
Subject: Re: Problem getting sensible video out of Hauppauge HVR-1100 composite
From: Steven Toth <stoth@kernellabs.com>
To: Neil Bird <gnome@fnxweb.com>
Cc: Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> It doesn't have a MPEG hardware compressor like the 350, you are
>> reading raw pixel data (160Mbps) from the device node.
>> Use an application that renders raw video data, such as TVTime.
>
>
>   Ah, OK, thanks, I managed to miss that.
>
>   I can get a picture out of it by using vlc's open-device.  So it's
> working.
>
>   But, flip me, it's spewing 800 MB+ for a minute's worth of video. That'd
> be ~48GB for an hour's TV (the intention is to use this for a MythTV PVR).
>
>   Am I likely to be able to do anything about that?  Even with
> post-transcoding that's going to be an excessive amount of filing to deal
> with :-(

Generally not a good idea to do what you're doing. Generally a good
idea to use a card with hardware compression features for a myth DVR.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
