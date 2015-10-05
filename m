Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:33057 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbbJEPcI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Oct 2015 11:32:08 -0400
Received: by igbkq10 with SMTP id kq10so65551026igb.0
        for <linux-media@vger.kernel.org>; Mon, 05 Oct 2015 08:32:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <561296A8.7000302@tresar-electronics.com.au>
References: <5610B12B.8090201@tresar-electronics.com.au>
	<CALzAhNWuOhQNQFu-baXy6QzhV3AxCknh7XeKOBjp943nz66Qyw@mail.gmail.com>
	<5611D97B.9020101@tresar-electronics.com.au>
	<CALzAhNVVipTAE3T9Hpmi8_CT=ZS5Wd04W5LfMaf-X5QP2d0sQw@mail.gmail.com>
	<56128AA6.8010106@tresar-electronics.com.au>
	<CALzAhNVDYgBbCfW5XSwVXJKqm7CgB23=xpsf25Y2Z0yY=tEKBQ@mail.gmail.com>
	<561296A8.7000302@tresar-electronics.com.au>
Date: Mon, 5 Oct 2015 11:32:07 -0400
Message-ID: <CALzAhNV06W4z4pw28iWuZje66oBS4Mkc2YjmMsvWd_oPF3U=Ow@mail.gmail.com>
Subject: Re: Hauppauge WinTV-HVR2205 driver feedback
From: Steven Toth <stoth@kernellabs.com>
To: Richard Tresidder <rtresidd@tresar-electronics.com.au>
Cc: Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 5, 2015 at 11:26 AM, Richard Tresidder
<rtresidd@tresar-electronics.com.au> wrote:
> stage 1..
> Yep it works with accessing src directly.. had to reboot to verify that one.
> Well at least the download says it worked and the image booted successfully.
>
> excuse my manual diff method..
> git and I don't agree... not sure how to get it to diff the media_build repo
> I pulled the code from..
> my brain is stuck in subversion mode..
>
> Still rebuilding the kernel to check the i2c Mux issue..

Good, that's the patch I had in mind. Thanks.

Yes, you'd need to issue a complete PCIe reset (warm or cold boot) for
the risc processor to reset, and for it to require a firmware to be
loaded again. So, your comments make sense.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
