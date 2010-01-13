Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f194.google.com ([209.85.221.194]:33566 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072Ab0AMVu6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2010 16:50:58 -0500
Received: by qyk32 with SMTP id 32so3377501qyk.4
        for <linux-media@vger.kernel.org>; Wed, 13 Jan 2010 13:50:57 -0800 (PST)
Message-ID: <4B4E4062.9050808@gmail.com>
Date: Wed, 13 Jan 2010 16:51:30 -0500
From: TJ <one.timothy.jones@gmail.com>
MIME-Version: 1.0
To: Pete Eberlein <pete@sensoray.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: go7007 driver -- which program you use for capture
References: <4B47828B.9050000@gmail.com> <1263339987.4697.36.camel@pete-desktop>
In-Reply-To: <1263339987.4697.36.camel@pete-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pete Eberlein wrote:
> On Fri, 2010-01-08 at 14:07 -0500, TJ wrote:
>> Pete and anybody else out there with go7007 devices, what do you use for capture?
> 
> I used a modified capture.c, based on
> http://v4l2spec.bytesex.org/v4l2spec/capture.c 
OK good.

>> Without GO7007 ioctls, I was only able to get vlc to capture in MJPEG format.
> 
> Does VLC try to change video parameters after starting the stream?  The
> driver currently doesn't allow that.  I think I've seen xawtv try to do
> that too.

I haven't messed with it much, but I think it just uses default driver settings.
When I went to Advanced settings in vlc and tried to change some stuff, it
didn't work at all. I ended up just hacking up gorecord from the original driver
package and got it working that way.

I would probably be worthwhile getting vlc to work with go7007. What do you think?

-TJ
