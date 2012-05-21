Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:61141 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757080Ab2EUCmm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 May 2012 22:42:42 -0400
Received: by gglu4 with SMTP id u4so3964595ggl.19
        for <linux-media@vger.kernel.org>; Sun, 20 May 2012 19:42:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FB9A6D9.8020603@iki.fi>
References: <4FB95A3B.9070800@iki.fi>
	<CAA7C2qiDQJ33OTfq9WxtAgqm0+iaLANoNVKSrvbZ3JpCD=ZGrA@mail.gmail.com>
	<CAGoCfiz_LpOet3qDpW1H6M=1oEdzKGuXVd6zD_ZprNKkZQgs+g@mail.gmail.com>
	<CAA7C2qiTesB+bZ0pzPvWTmO7p=_3oaoR+egw_WpEmiowidAD4g@mail.gmail.com>
	<4FB9A6D9.8020603@iki.fi>
Date: Sun, 20 May 2012 19:42:41 -0700
Message-ID: <CAA7C2qhoxSrT7od6OrXyANGYtnw0cuez+tSGHMq-mzrWPHBjLA@mail.gmail.com>
Subject: Re: [RFCv1] DVB-USB improvements [alternative 2]
From: VDR User <user.vdr@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media <linux-media@vger.kernel.org>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, May 20, 2012 at 7:22 PM, Antti Palosaari <crope@iki.fi> wrote:
>> So you think that it makes more sense to ignore existing issues rather
>> than fix them. Isn't fixing issues&  flaws the whole point of an
>> overhaul/redesign? Yes, it is. I do get the point you're trying to
>> make -- there are bigger fish to fry. But this is not an urgent
>> project and I disagree with the attitude to just disregard whatever
>> you deem unimportant. If you're going to do it, do it right.
>
> I am not sure what you trying to say. Do you mean I should try to get remote
> controller totally optional module which can be left out?

I am saying it's a dependency that is currently forced onto every usb
device whether the device even supports rc or not. This is clearly
poor design. For that matter, the whole usb handling must be poor
design if it needs to be overhauled.

> How much memory will be saved if remote can be left out as unloaded?

I don't know. I'm merely pointing out just one of the issues that
should be resolved if the idea is to fix things that are wrong with
usb handling. If nobody cares, doesn't think it matters, or simply
doesn't want to bother, so be it. I guess I'm crazy but when I'm
facing an overhaul, especially when there's no rush, I compile a list
of _everything_ that's wrong and make sure the overhaul fixes it all.
I guess there's quite a difference between my idea of what an overhaul
should be, and other peoples.

If you really want, there's probably people who deal with embedded
systems where every wasted byte counts, that would agree cleaning up
the waste is a good idea.

Since nobody thinks it should be fixed, just pretend I didn't even
bring it up. Problem solved.
