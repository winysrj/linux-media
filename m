Return-path: <linux-media-owner@vger.kernel.org>
Received: from web244.extendcp.co.uk ([79.170.40.244]:36885 "EHLO
	web244.extendcp.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab1LCXbI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Dec 2011 18:31:08 -0500
To: VDR User <user.vdr@gmail.com>
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver because of
 worrying about possible =?UTF-8?Q?misusage=3F?=
MIME-Version: 1.0
Date: Sat, 03 Dec 2011 23:30:49 +0000
From: Walter Van Eetvelt <walter@van.eetvelt.be>
Cc: Andreas Oberritter <obi@linuxtv.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, HoP <jpetrous@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	<linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: <CAA7C2qjfWW8=kePZDO4nYR913RyuP-t+u8P9LV4mDh9bANr3=Q@mail.gmail.com>
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com> <4ED6C5B8.8040803@linuxtv.org> <4ED75F53.30709@redhat.com> <CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com> <20111202231909.1ca311e2@lxorguk.ukuu.org.uk> <4EDA4AB4.90303@linuxtv.org> <CAA7C2qjfWW8=kePZDO4nYR913RyuP-t+u8P9LV4mDh9bANr3=Q@mail.gmail.com>
Message-ID: <aff8302dd6c3eb047c39d3a2d1fd2382@mail.eetvelt.be>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 3 Dec 2011 09:21:23 -0800, VDR User <user.vdr@gmail.com> wrote:
...
> So you could finally use VDR as a server/client setup using vtuner,
> right? With full OSD, timer, etc? Yes, I'm aware that streamdev
> exists. It was horrible when I tried it last (a long time ago) and I
> understand it's gotten better. But it's not a suitable replacement for
> a real server/client setup. It sounds like using vtuner, this would
> finally be possible and since Klaus has no intention of ever
> modernizing VDR into server/client (that I'm aware of), it's also the
> only suitable option as well.
> 
> Or am I wrong about anything?  If not, I know several users who would
> like to use this, myself included.

This is the question on how you provide (live)tv content to multiple users
and devices.  
And I think this goes beyond the simple "second PC in the house" where you
want to watch TV or recordings.  How can you watch streams from your DVB
device on your small screen Mobile phone/tablet?  Or stream over the
internet and watch your last night recording when commuting in the train?
Some commercial solutions are already available for some scenario's.  Also
free software solutions support for some scenario's, but I think still too
limited.  

With that in mind, for me the future is for a client server combination
that can do proper live TV and recording streaming.  
And technically, a virtual driver is not bringing better user experience
in the long term I think.  On the contrary, some users would use the
vtunerc to fill in some of their needs.  This could bring developers to
work less on client/server application supporting a broader range of use
cases.  

Walter
