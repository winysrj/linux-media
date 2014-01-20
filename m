Return-path: <linux-media-owner@vger.kernel.org>
Received: from avasout05.plus.net ([84.93.230.250]:45442 "EHLO
	avasout05.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaATS0U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jan 2014 13:26:20 -0500
Message-ID: <52DD6A48.8000003@fnxweb.com>
Date: Mon, 20 Jan 2014 18:26:16 +0000
From: Neil Bird <gnome@fnxweb.com>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>
CC: Linux-Media <linux-media@vger.kernel.org>
Subject: Re: Problem getting sensible video out of Hauppauge HVR-1100 composite
References: <52DC04E8.8020406@fnxweb.com> <CALzAhNWjweoydgDHpU+nJRQYYTRGkreE2v0ZYBgNS3a-yGYY8A@mail.gmail.com>
In-Reply-To: <CALzAhNWjweoydgDHpU+nJRQYYTRGkreE2v0ZYBgNS3a-yGYY8A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Around about 19/01/14 17:54, Steven Toth scribbled ...
> It doesn't have a MPEG hardware compressor like the 350, you are
> reading raw pixel data (160Mbps) from the device node.
> Use an application that renders raw video data, such as TVTime.

   Ah, OK, thanks, I managed to miss that.

   I can get a picture out of it by using vlc's open-device.  So it's 
working.

   But, flip me, it's spewing 800 MB+ for a minute's worth of video. 
That'd be ~48GB for an hour's TV (the intention is to use this for a 
MythTV PVR).

   Am I likely to be able to do anything about that?  Even with 
post-transcoding that's going to be an excessive amount of filing to 
deal with :-(

-- 
[phoenix@fnx ~]# rm -f .signature
[phoenix@fnx ~]# ls -l .signature
ls: .signature: No such file or directory
[phoenix@fnx ~]# exit
