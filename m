Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:48156 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931Ab0ANKox (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2010 05:44:53 -0500
Received: by fxm25 with SMTP id 25so330476fxm.21
        for <linux-media@vger.kernel.org>; Thu, 14 Jan 2010 02:44:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1a297b361001140238m2019861fh9e0a6d0f972ed48e@mail.gmail.com>
References: <f74f98341001132335p562b189duda4478cb62a7549a@mail.gmail.com>
	 <1a297b361001140115l3dc56802r985b0fd9f8f83c16@mail.gmail.com>
	 <3a11f97d6e44a5cd64c4378c51706ff4.squirrel@webmail.xs4all.nl>
	 <1a297b361001140144s3518ed59o14b0784de9fd828@mail.gmail.com>
	 <b9869b35004c5f383c2e76791b91a20d.squirrel@webmail.xs4all.nl>
	 <1a297b361001140238m2019861fh9e0a6d0f972ed48e@mail.gmail.com>
Date: Thu, 14 Jan 2010 11:44:49 +0100
Message-ID: <846899811001140244w54b209c6s484918d26a01cdfe@mail.gmail.com>
Subject: Re: About driver architecture
From: HoP <jpetrous@gmail.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> The STi7109 also has a frame buffer approach, currently the
> framebuffer is not implemented in this specific case.
> http://osdir.com/ml/linux.fbdev.user/2008-07/msg00004.html
>

When you use stb7109 as main cpu for system (like is done
for many linux or os21-based set-top-boxes already), then
you can use FB driver from stlinux, what is STM's port
of linux for theirs STB7xxx SOCs. See more on www.stlinux.com.

Even more, there is already flying around full source code
for such SOCs, which allows you to make full-featured box.

I have a dream that sometimes those drivers come to mainline
similar like TI chips are comming these days.

/Honza
