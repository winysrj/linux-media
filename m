Return-path: <mchehab@pedra>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46228 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254Ab1ATLfY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jan 2011 06:35:24 -0500
Received: by qyj19 with SMTP id 19so1799596qyj.19
        for <linux-media@vger.kernel.org>; Thu, 20 Jan 2011 03:35:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201101182345.17725.hverkuil@xs4all.nl>
References: <AANLkTi=bv+NkwS+ASUDeAjbpNht8+YJaPRKYF7TTZDes@mail.gmail.com>
	<201101182345.17725.hverkuil@xs4all.nl>
Date: Thu, 20 Jan 2011 12:35:23 +0100
Message-ID: <AANLkTikrXyqr8ZS7bbeJe5yPxdyxE-X-pwk=5MaLOy4N@mail.gmail.com>
Subject: Re: Upstreaming syntek driver
From: Luca Tettamanti <kronos.it@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Nicolas VIVIEN <progweb@free.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Jan 18, 2011 at 11:45 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
[...]
> After a quick scan through the sources in svn I found the following (in no
> particular order):
>
> - Supports easycap model with ID 05e1:0408: a driver for this model is now
>  in driver/staging/easycap.

Can you elaborate? Is this the same hardware?

> - format conversion must be moved to libv4lconvert (if that can't already be
>  used out of the box). Ditto for software brightness correction.
>
> - kill off the sysfs bits
>
> - kill off V4L1
>
> - use the new control framework for the control handling
>
> - use video_ioctl2 instead of the current ioctl function
>
> - use unlocked_ioctl instead of ioctl

Ok, major surgery then :)

> But probably the first step should be to see if this can't be made part of the
> gspca driver. I can't help thinking that that would be the best approach. But
> I guess the gspca developers can give a better idea of how hard that is.

I've looked at the framework provided by gspca, it would probably
allow to drop most of the USB support code from the driver. I'm
looking into frame handling.

Luca
