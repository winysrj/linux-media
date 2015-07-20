Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:34298 "EHLO
	mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbbGTTE7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 15:04:59 -0400
Received: by qkfc129 with SMTP id c129so75616733qkf.1
        for <linux-media@vger.kernel.org>; Mon, 20 Jul 2015 12:04:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55AD2FA5.6000309@iki.fi>
References: <CALzAhNXQe7AtkwymcUeakVouMBmw7pG79-TeEjBMiK5ysXze_g@mail.gmail.com>
	<55AD0617.7060007@iki.fi>
	<CALzAhNVFBgEBJ8448h1WL3iDZ4zkR_k5And0-mtJ6vu97RZLTQ@mail.gmail.com>
	<55AD234E.5010904@iki.fi>
	<CAGoCfiy5Fy26EJzRPYEk_kgH0YESTXiR-E=83Rur6PWZjyi8jQ@mail.gmail.com>
	<55AD27E0.6080102@iki.fi>
	<CALzAhNV6mq6V-jYdjjwrYqtwkKQTgvAFOUhxBvHuAK0jAXZ7gQ@mail.gmail.com>
	<55AD2FA5.6000309@iki.fi>
Date: Mon, 20 Jul 2015 15:04:58 -0400
Message-ID: <CALzAhNWZPCF+0FAJkjEsqhNc3iowYWc0PdnCJZ9r-3VHxbSCbQ@mail.gmail.com>
Subject: Re: Adding support for three new Hauppauge HVR-1275 variants -
 testers reqd.
From: Steven Toth <stoth@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	tonyc@wincomm.com.tw, Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> We can agree or disagree about whether a part should be tri-stated in
>> init/sleep() and under what circumstances, but why bother when someone
>> has gone to the trouble of declaring a perfectly good tr-state
>> interface in dvb-core, taht automatically asserts and de-asserts any
>> dvb_frontend device from the bus, optionally.
>
>
> Because I simply don't want to any new demod users for that callback unless
> needed for some strange reason.

I see, I understand your concern, perhaps you should have raised this
in your first response. Are you the maintainer for dvb-core now?

So two options come to mind:

1. The si2168_init() brings the part onto the bus, and _sleep() takes
the device off the bus, regardless? Any by default, the device is not
on the bus after attach takes place.

2. The bridge specifically calls ts_bus_control() on the si2168 fe
ops, as and when the bridge requires it? This feels like a reasonable
middle-ground approach.

Your thoughts?

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
