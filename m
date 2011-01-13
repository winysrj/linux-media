Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59504 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756794Ab1AMOMy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jan 2011 09:12:54 -0500
Received: by eye27 with SMTP id 27so819095eye.19
        for <linux-media@vger.kernel.org>; Thu, 13 Jan 2011 06:12:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110113142144.662d54e0@endymion.delvare>
References: <1293587067.3098.10.camel@localhost>
	<1293587390.3098.16.camel@localhost>
	<20110105154553.546998bf@endymion.delvare>
	<1294274780.9672.93.camel@morgan.silverblock.net>
	<20110113142144.662d54e0@endymion.delvare>
Date: Thu, 13 Jan 2011 09:12:51 -0500
Message-ID: <AANLkTi=YNf3m6zpmvMC=djN9poWBxqLEg-K369L1+k9P@mail.gmail.com>
Subject: Re: [PATCH 3/3] lirc_zilog: Remove use of deprecated struct
 i2c_adapter.id field
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org,
	Jarod Wilson <jarod@redhat.com>, Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Jan 13, 2011 at 8:21 AM, Jean Delvare <khali@linux-fr.org> wrote:
> My bet is that register at 0x00 is a control register, and writing bit
> 7 (value 0x80) makes the chip busy enough that it can't process I2C
> requests at the same time. The following naks would be until the
> chip is operational again.

Correct.  Poking bit 7 of 0xE0:00 triggers the "send" for all the
bytes that were previously loaded into the device.  It puts the chip
into a busy state, doing an i2c clock stretch until it is available
again.  During that time it cannot see any i2c traffic, which is why
you are getting NAKs.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
