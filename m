Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:38993 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932121Ab0CDTj3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Mar 2010 14:39:29 -0500
Received: by fxm19 with SMTP id 19so3244003fxm.21
        for <linux-media@vger.kernel.org>; Thu, 04 Mar 2010 11:39:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <74fd948d1003040314y2fc911f2k97b1d6fb66bdc0b9@mail.gmail.com>
References: <74fd948d1003031535r1785b36dq4cece00f349975af@mail.gmail.com>
	 <829197381003031548n703f0bf9sb44ce3527501c5c0@mail.gmail.com>
	 <74fd948d1003031700h187dbfd0v3f54800e652569b@mail.gmail.com>
	 <829197381003031706g1011f442hcc4be40ae2e79a47@mail.gmail.com>
	 <4B8F347E.2010206@gmail.com>
	 <74fd948d1003040314y2fc911f2k97b1d6fb66bdc0b9@mail.gmail.com>
Date: Thu, 4 Mar 2010 14:39:27 -0500
Message-ID: <829197381003041139j7300bc7cg1281aff59e5a60b@mail.gmail.com>
Subject: Re: Excessive rc polling interval in dvb_usb_dib0700 causes
	interference with USB soundcard
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Pedro Ribeiro <pedrib@gmail.com>
Cc: Mauro Carvalho Chehab <maurochehab@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 4, 2010 at 6:14 AM, Pedro Ribeiro <pedrib@gmail.com> wrote:
> Devin, I noticed that your solution does not alter the remote query
> interval from 50 msec. It works, but it is not as effective as my hard
> hack because I still get interference every once in a while when the
> DVB adapter is connected.
>
> I can't tell you exactly when and how it happens, because it seems
> rather random - but it is much better than previously though.

Well, the printk() line is a little misleading, since the code change
results in *zero* polling.  Basically the driver now registers a bulk
URB handler, so whenever a message is delivered on the bulk pipe it is
handled immediately.  Hence, no polling at all.

That said, I should probably find a way to get rid of that line from
the dmesg output when the device is in that mode (the issue is that
portion of the code is shared with drivers other than the dib0700).

If you are still seeing issues, then it is unlikely to have anything
to do with the dib0700 RC support.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
