Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47835 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab1BNO3J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 09:29:09 -0500
Received: by ewy5 with SMTP id 5so2241313ewy.19
        for <linux-media@vger.kernel.org>; Mon, 14 Feb 2011 06:29:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1297642614.19186.38.camel@localhost>
References: <20101207190753.GA21666@io.frii.com>
	<20110212152954.GA20838@io.frii.com>
	<20110213144758.GA79915@io.frii.com>
	<AANLkTik5iYsS5UNQQv6OxTyC0X9nEYvsOEtA6mBLQ-Jq@mail.gmail.com>
	<20110213202644.GA15282@io.frii.com>
	<1297632410.2401.6.camel@localhost>
	<1297642614.19186.38.camel@localhost>
Date: Mon, 14 Feb 2011 09:29:06 -0500
Message-ID: <AANLkTi=Ke-FFvBAxriTkkt0wJADH5jCj9oafPCNCd8a0@mail.gmail.com>
Subject: Re: [corrected get-bisect results]: DViCO FusionHDTV7 Dual Express
 I2C write failed
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Mark Zimmerman <markzimm@frii.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, Feb 13, 2011 at 7:16 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> Devin,
>
> I just checked.  The CX23885 driver *is* setting up to allow slaves to
> stretch the clock.
>
> By analysis, I have confirmed that Jean's sugguested patch that I moved
> forward was wrong for the hardware's behavior.  When the cx23885 I2C
> routines decide to set the I2C_EXTEND flag (and maybe the I2C_NOSTOP
> flag), we most certainly should *not* be expecting an ACK from the
> particular hardware register.  The original commit should certainly be
> reverted.
>
> Checking for slave ACK/NAK will need to be done with a little more care;
> so for now, I'll settle for ignoring them.

Ok, that makes sense.  I just threw out the possibility of it being
related to clock stretch because I've seen that with other bridges and
the xc5000.  I haven't really reviewed the code in question or the
cx23885 datasheet.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
