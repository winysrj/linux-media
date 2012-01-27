Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46607 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897Ab2A0NgZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jan 2012 08:36:25 -0500
Received: by vcbgb30 with SMTP id gb30so1161044vcb.19
        for <linux-media@vger.kernel.org>; Fri, 27 Jan 2012 05:36:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201201270821.49381.hverkuil@xs4all.nl>
References: <201201270821.49381.hverkuil@xs4all.nl>
Date: Fri, 27 Jan 2012 08:36:24 -0500
Message-ID: <CAGoCfiynca-oSRnunwsa_y9xamD3Bn6Xnr40LUsmVcbmo6jkhA@mail.gmail.com>
Subject: Re: RFC: removal of video/radio/vbi_nr module options?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 27, 2012 at 2:21 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi all,
>
> I'm working on cleaning up some old radio drivers and while doing that I
> started wondering about the usefulness of the radio_nr module option (and
> the corresponding video_nr/vbi_nr module options for video devices).
>
> Is that really still needed? It originates from pre-udev times, but it seems
> fairly useless to me these days.

I can tell you from lurking in the mythtv-users IRC channel, that
there are still many, many users of video_nr.  Yes, they can in theory
accomplish the same thing through udev, but they aren't today, and if
you remove the functionality you'll have lots of users scambling to
figure out why stuff that previously worked is now broken.  This tends
to be more an issue with tuner cards than uvc devices, presumably
because MythTV starts up unattended and you're more likely to have
more than one capture device.

My hope is that once the media controller interface becomes more
mature (including adoption by userland applications such as Myth) that
it will eliminate the need for these sorts of hacks entirely.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
