Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36278 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab1JUUle (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Oct 2011 16:41:34 -0400
Received: by ywf7 with SMTP id 7so4230728ywf.19
        for <linux-media@vger.kernel.org>; Fri, 21 Oct 2011 13:41:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAO-Op+EdkOftaPrsvFwo++S_+j9W=MoJSAnJfV+n2mhtKZ2xBQ@mail.gmail.com>
References: <4DF9BCAA.3030301@holzeisen.de>
	<4DF9EA62.2040008@killerhippy.de>
	<4DFA7748.6000704@hoogenraad.net>
	<4DFFC82B.10402@iki.fi>
	<1308649292.3635.2.camel@maxim-laptop>
	<4E006BDB.8060000@hoogenraad.net>
	<4E17CA94.8030307@iki.fi>
	<4E3B2EB3.6030501@iki.fi>
	<CAO-Op+FBtPm9fdB4bskq3Hv_GorLuUUb6VFx7W+2JBxoCGwnYg@mail.gmail.com>
	<CAO-Op+FY9KVPQFgF1ykNz_BqJu653yM2-1oj5BZotUOhLtKGVw@mail.gmail.com>
	<4E403E1B.3020806@iki.fi>
	<CAO-Op+EdkOftaPrsvFwo++S_+j9W=MoJSAnJfV+n2mhtKZ2xBQ@mail.gmail.com>
Date: Fri, 21 Oct 2011 21:41:33 +0100
Message-ID: <CAO-Op+E3Q=AKNigL4fNUxVrdTZM9p=FEBfL7wgCnYZ2rne9t8A@mail.gmail.com>
Subject: Re: RTL2831U driver updates
From: Alistair Buxton <a.j.buxton@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org,
	Jan Hoogenraad <jan-conceptronic@hoogenraad.net>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	=?UTF-8?Q?Sascha_W=C3=BCstemann?= <sascha@killerhippy.de>,
	Thomas Holzeisen <thomas@holzeisen.de>, stybla@turnovfree.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 9 August 2011 14:22, Alistair Buxton <a.j.buxton@gmail.com> wrote:

> After a couple of days the card locked up again just like before

I have found something new about this. It turns out my MythTV tuning
was incorrect as some channels had changed frequency due to the
analogue switch-off. The card would freeze up when tuning to one of
these channels. For some reason, this would prevent any further tuning
on it. So after MythTV tried to record from one of these channels, it
would prevent anything from being recorded on any channel.

I have retuned and I haven't experienced any more lock-ups since about 1 week.

-- 
Alistair Buxton
a.j.buxton@gmail.com
