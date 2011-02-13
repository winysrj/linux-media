Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:36386 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab1BMOw1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Feb 2011 09:52:27 -0500
Received: by ewy5 with SMTP id 5so1954833ewy.19
        for <linux-media@vger.kernel.org>; Sun, 13 Feb 2011 06:52:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110213144758.GA79915@io.frii.com>
References: <20101207190753.GA21666@io.frii.com>
	<20110212152954.GA20838@io.frii.com>
	<20110213144758.GA79915@io.frii.com>
Date: Sun, 13 Feb 2011 09:52:25 -0500
Message-ID: <AANLkTik5iYsS5UNQQv6OxTyC0X9nEYvsOEtA6mBLQ-Jq@mail.gmail.com>
Subject: Re: [corrected get-bisect results]: DViCO FusionHDTV7 Dual Express
 I2C write failed
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mark Zimmerman <markzimm@frii.com>
Cc: linux-media@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
	Andy Walls <awalls@md.metrocast.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, Feb 13, 2011 at 9:47 AM, Mark Zimmerman <markzimm@frii.com> wrote:
> Clearly my previous bisection went astray; I think I have a more
> sensible result this time.
>
> qpc$ git bisect good
> 44835f197bf1e3f57464f23dfb239fef06cf89be is the first bad commit
> commit 44835f197bf1e3f57464f23dfb239fef06cf89be
> Author: Jean Delvare <khali@linux-fr.org>
> Date:   Sun Jul 18 16:52:05 2010 -0300
>
>    V4L/DVB: cx23885: Check for slave nack on all transactions
>
>    Don't just check for nacks on zero-length transactions. Check on
>    other transactions too.

This could be a combination of the xc5000 doing clock stretching and
the cx23885 i2c master not properly implementing clock stretch.  In
the past I've seen i2c masters broken in their handling of clock
stretching where they treat it as a NAK.

The xc5000 being one of the few devices that actually does i2c clock
stretching often exposes cases where it is improperly implemented in
the i2c master driver (I've had to fix this with several bridges).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
