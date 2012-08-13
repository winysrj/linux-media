Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:61772 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab2HMNUr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 09:20:47 -0400
Received: by qcro28 with SMTP id o28so2176361qcr.19
        for <linux-media@vger.kernel.org>; Mon, 13 Aug 2012 06:20:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5028CC8C.3060907@bmat.es>
References: <5028CC8C.3060907@bmat.es>
Date: Mon, 13 Aug 2012 09:20:46 -0400
Message-ID: <CALzAhNXim6t=w-49+TmzKr5sGu6uwgisc6O3oqVkUShYpu+PJQ@mail.gmail.com>
Subject: Re: Question Hauppauge Nova-S-Plus.
From: Steven Toth <stoth@kernellabs.com>
To: mark@bmat.es
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I've been working for some time with those devices, and recently I have
> a problem which I've never seen before. The point is that I tune
> properly frequency and I start watching all channels, but after some
> time  one or 2 tuners stops, and you cannot tune again any frequency
> until you reboot all server.

Interesting. If it was previously working fine, and very reliably,
then what has changed in your software stack or environment?

What happens if you rmmod and modprobe the driver? Does this help?

>
> One thing very strange there is that always are the same tuners which
> fails. Signal is OK.

Do you mean it's always the same physical card that fails, or any of
your nova-s-plus cards fail in the same way?

>
> I don't have any error on syslog nor dmesg. And once you reboot it works
> again.
>
> Have anyone seen this problem before and can help me please?

I haven't seen this before.


-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
