Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f184.google.com ([209.85.210.184]:43105 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbZGWShJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jul 2009 14:37:09 -0400
Received: by yxe14 with SMTP id 14so757081yxe.33
        for <linux-media@vger.kernel.org>; Thu, 23 Jul 2009 11:37:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <bb6641fe0907231132g3e744632x181fc44910f35ecf@mail.gmail.com>
References: <bb6641fe0907231132g3e744632x181fc44910f35ecf@mail.gmail.com>
Date: Thu, 23 Jul 2009 14:37:08 -0400
Message-ID: <829197380907231137o3b449e15s27c21e7cb090a857@mail.gmail.com>
Subject: Re: [linux-dvb] DVB-T support for Pinnacle PCTV Hybrid Pro Stick
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 23, 2009 at 2:32 PM, Angelo Fontana<fonta72@gmail.com> wrote:
> Hi,
> I'm trying to use my USB PTCV with linux (Debian Lenny).
> After compiling, installing the latest version of v4l-dvb drivers and
> loading em28xx-dvb module i can't use DVB features of the device.
>
> This is the output of dmesg:
<snip>
> Something wrong in my configuration?
> Is there any plan for a support of Pinnacle PCTV Hybrid Stick Pro in linux?
>
> Thanks and regards.
> Angelo Fontana.

The 330e is on the list of devices I am actively working on and I hope
to have something committed in the next couple of weeks (the DVB side
is known to not be working currently).

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
