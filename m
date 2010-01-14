Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:50210 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439Ab0ANKr1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2010 05:47:27 -0500
Received: by fxm25 with SMTP id 25so332417fxm.21
        for <linux-media@vger.kernel.org>; Thu, 14 Jan 2010 02:47:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <846899811001140244w54b209c6s484918d26a01cdfe@mail.gmail.com>
References: <f74f98341001132335p562b189duda4478cb62a7549a@mail.gmail.com>
	 <1a297b361001140115l3dc56802r985b0fd9f8f83c16@mail.gmail.com>
	 <3a11f97d6e44a5cd64c4378c51706ff4.squirrel@webmail.xs4all.nl>
	 <1a297b361001140144s3518ed59o14b0784de9fd828@mail.gmail.com>
	 <b9869b35004c5f383c2e76791b91a20d.squirrel@webmail.xs4all.nl>
	 <1a297b361001140238m2019861fh9e0a6d0f972ed48e@mail.gmail.com>
	 <846899811001140244w54b209c6s484918d26a01cdfe@mail.gmail.com>
Date: Thu, 14 Jan 2010 14:47:24 +0400
Message-ID: <1a297b361001140247q4a7b3614i12cccc6109b2e760@mail.gmail.com>
Subject: Re: About driver architecture
From: Manu Abraham <abraham.manu@gmail.com>
To: HoP <jpetrous@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 14, 2010 at 2:44 PM, HoP <jpetrous@gmail.com> wrote:
>> The STi7109 also has a frame buffer approach, currently the
>> framebuffer is not implemented in this specific case.
>> http://osdir.com/ml/linux.fbdev.user/2008-07/msg00004.html
>>
>
> When you use stb7109 as main cpu for system (like is done
> for many linux or os21-based set-top-boxes already), then
> you can use FB driver from stlinux, what is STM's port
> of linux for theirs STB7xxx SOCs. See more on www.stlinux.com.

Yes, I am aware of it.

> Even more, there is already flying around full source code
> for such SOCs, which allows you to make full-featured box.
>
> I have a dream that sometimes those drivers come to mainline
> similar like TI chips are comming these days.


Yes indeed, it will sometime soon. Have been expecting things to move
for around > 18 months now.

Regards,
Manu
