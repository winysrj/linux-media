Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64066 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758091Ab1D3BTf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2011 21:19:35 -0400
Received: by iyb14 with SMTP id 14so3462853iyb.19
        for <linux-media@vger.kernel.org>; Fri, 29 Apr 2011 18:19:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201104260853.03817.hverkuil@xs4all.nl>
References: <BANLkTim7AONexeEm-E8iLQA5+TMDRUy36w@mail.gmail.com>
	<201104231256.25263.hverkuil@xs4all.nl>
	<BANLkTikneMOMVUQ07mLBZZTDYrKTJ1dfPw@mail.gmail.com>
	<201104260853.03817.hverkuil@xs4all.nl>
Date: Fri, 29 Apr 2011 19:19:34 -0600
Message-ID: <BANLkTikRtZTpDZTe93q08-WFSKRAuv29WQ@mail.gmail.com>
Subject: Re: Regression with suspend from "msp3400: convert to the new control framework"
From: Jesse Allen <the3dfxdude@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Apr 26, 2011 at 12:53 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> OK, whatever is causing the problems is *not* msp3400 since your card does not
> have one :-)
>
> This card uses gpio to handle audio.
>
>> i2c-core: driver [tuner] using legacy suspend method
>> i2c-core: driver [tuner] using legacy resume method
>> tuner 0-0061: chip found @ 0xc2 (bt878 #0 [sw])
>> tuner-simple 0-0061: creating new instance
>> tuner-simple 0-0061: type set to 2 (Philips NTSC (FI1236,FM1236 and
>> compatibles))
>
> It is more likely to be the tuner driver. But I would have expected to see
> more bug reports since this is a bog-standard tuner so I have my doubts there
> as well.
>
> Regards,
>
>        Hans
>


After today, basically I have proved that the issue only happens if
both the radeon and the bttv drivers are both loaded at suspend. If I
boot without radeon, but load bttv, I can suspend and resume the tv
card just fine. If I load radeon and when going to suspend unload
bttv, I can then resume and load bttv just fine. This behavior started
sometime after v2.6.36. It will be hard to pin point a problem in
either since both have problems in 2.6.37-rc, where bttv has multiple
issues during that time frame that cause oopses, and in other places
loading radeon causes a lockup. So I think this will take me a
different direction now, and it would be nice to know what changed
related to all this.

Jesse
