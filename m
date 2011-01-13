Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49656 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757028Ab1AMREf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jan 2011 12:04:35 -0500
Received: by eye27 with SMTP id 27so950599eye.19
        for <linux-media@vger.kernel.org>; Thu, 13 Jan 2011 09:04:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <euouknkdsi5amcy6dha8ycx7.1294936482595@email.android.com>
References: <euouknkdsi5amcy6dha8ycx7.1294936482595@email.android.com>
Date: Thu, 13 Jan 2011 12:04:33 -0500
Message-ID: <AANLkTi=_Wd-2Y86CGdabMeDGBTBmBFf1MToYbiYGyMUf@mail.gmail.com>
Subject: Re: [PATCH 3/3] lirc_zilog: Remove use of deprecated struct
 i2c_adapter.id field
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Jean Delvare <khali@linux-fr.org>, linux-media@vger.kernel.org,
	Jarod Wilson <jarod@redhat.com>, Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Jan 13, 2011 at 11:34 AM, Andy Walls <awalls@md.metrocast.net> wrote:
> Devin,
>
> You've seen the clock stretch with your I2C analyzer?

The Beagle I was using when I did the captures doesn't show clock
stretch.  My "Logic" logic analyzer does, but I wasn't using that at
the time.

That said, I can say with some authority that the Zilog does put the
bus into a busy state after certain operations (such as setting the
send bit).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
