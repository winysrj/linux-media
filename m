Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44309 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab1DCSTf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Apr 2011 14:19:35 -0400
Received: by fxm17 with SMTP id 17so3496916fxm.19
        for <linux-media@vger.kernel.org>; Sun, 03 Apr 2011 11:19:34 -0700 (PDT)
Date: Sun, 3 Apr 2011 20:15:17 +0200
From: Steffen Barszus <steffenbpunkt@googlemail.com>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Skystar 2 2.6 broken in kernel 2.6.38
Message-ID: <20110403201517.21756097@grobi>
In-Reply-To: <201104031741.42930.pboettcher@kernellabs.com>
References: <20110402213053.716d0de7@grobi>
	<201104031741.42930.pboettcher@kernellabs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 3 Apr 2011 17:41:42 +0200
Patrick Boettcher <pboettcher@kernellabs.com> wrote:

> Hi,
> 
> On Saturday 02 April 2011 21:30:53 Steffen Barszus wrote:
> > Hi
> > 
> > I just installed natty and found that one of the drivers i use is
> > broken. Is this a known issue ?
> > 
> > 
> > [    6.115925] ------------[ cut here ]------------
> > [    6.115931] WARNING: at
> > /build/buildd/linux-2.6.38/fs/proc/generic.c:323
> > __xlate_proc_name+0xbb/0xd0() [    6.115933] Hardware name:
> > EP45T-UD3LR
> 
> Actually the driver is not broken as it still works. This is a
> warning issued by the core because the driver is using a bad string.
> There have been a lot of attempts to fix it in the past, but they
> have been lost somewhere on the road. 
> 
> I hope this time it will make it.

Cool, thx, so its not as bad as i thought :) Also have seen your pull
request. Thanks for taking care !

Kind Regards

Steffen
