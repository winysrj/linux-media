Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51684 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757Ab0FZTEx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jun 2010 15:04:53 -0400
Received: by ewy7 with SMTP id 7so40565ewy.19
        for <linux-media@vger.kernel.org>; Sat, 26 Jun 2010 12:04:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201006262051.52754.hverkuil@xs4all.nl>
References: <AANLkTim9TfITmvy7nEuSVJnCxRwCkpbmgRc2FIIIWHGF@mail.gmail.com>
	<201006262051.52754.hverkuil@xs4all.nl>
Date: Sat, 26 Jun 2010 15:04:51 -0400
Message-ID: <AANLkTikPKv6iCQmV14JSiR61AUMswsOoTB7i-eSHAwH4@mail.gmail.com>
Subject: Re: Correct way to do s_ctrl ioctl taking into account subdev
	framework?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 26, 2010 at 2:51 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> There really is no good way at the moment to handle cases like this, or at
> least not without a lot of work.

Ok, it's good to know I'm not missing something obvious.

> The plan is to have the framework merged in time for 2.6.36. My last patch
> series for the framework already converts a bunch of subdevs to use it. Your
> best bet is to take the patch series and convert any remaining subdevs used
> by em28xx and em28xx itself. I'd be happy to add those patches to my patch
> series, so that when I get the go ahead the em28xx driver will be fixed
> automatically.
>
> It would be useful for me anyway to have someone else use it: it's a good
> check whether my documentation is complete.

Sure, could you please point me to the tree in question and I'll take a look?

Given I've got applications failing, for the short term I will likely
just submit a patch which makes the s_ctrl always return zero
regardless of the subdev response, instead of returning 1.

Thanks,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
