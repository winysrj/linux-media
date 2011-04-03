Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38640 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab1DCPlx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Apr 2011 11:41:53 -0400
Received: by wya21 with SMTP id 21so4086407wya.19
        for <linux-media@vger.kernel.org>; Sun, 03 Apr 2011 08:41:52 -0700 (PDT)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Steffen Barszus <steffenbpunkt@googlemail.com>
Subject: Re: Skystar 2 2.6 broken in kernel 2.6.38
Date: Sun, 3 Apr 2011 17:41:42 +0200
Cc: linux-media@vger.kernel.org
References: <20110402213053.716d0de7@grobi>
In-Reply-To: <20110402213053.716d0de7@grobi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201104031741.42930.pboettcher@kernellabs.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On Saturday 02 April 2011 21:30:53 Steffen Barszus wrote:
> Hi
> 
> I just installed natty and found that one of the drivers i use is
> broken. Is this a known issue ?
> 
> 
> [    6.115925] ------------[ cut here ]------------
> [    6.115931] WARNING: at
> /build/buildd/linux-2.6.38/fs/proc/generic.c:323
> __xlate_proc_name+0xbb/0xd0() [    6.115933] Hardware name: EP45T-UD3LR

Actually the driver is not broken as it still works. This is a warning 
issued by the core because the driver is using a bad string. There have been 
a lot of attempts to fix it in the past, but they have been lost somewhere on 
the road. 

I hope this time it will make it.

best regards,
--
Patrick Boettcher - KernelLabs
http://www.kernellabs.com/
