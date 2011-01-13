Return-path: <mchehab@pedra>
Received: from zone0.gcu-squad.org ([212.85.147.21]:17887 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757028Ab1AMRUN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jan 2011 12:20:13 -0500
Date: Thu, 13 Jan 2011 18:19:22 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org,
	Jarod Wilson <jarod@redhat.com>, Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 3/3] lirc_zilog: Remove use of deprecated struct
 i2c_adapter.id field
Message-ID: <20110113181922.792e44a1@endymion.delvare>
In-Reply-To: <AANLkTim0Q8AxYZDCPZeV0+je6Us==yPFce3-zQ0ELh6e@mail.gmail.com>
References: <euouknkdsi5amcy6dha8ycx7.1294936482595@email.android.com>
	<20110113174814.12c2ea5d@endymion.delvare>
	<AANLkTim0Q8AxYZDCPZeV0+je6Us==yPFce3-zQ0ELh6e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, 13 Jan 2011 12:07:34 -0500, Devin Heitmueller wrote:
> On Thu, Jan 13, 2011 at 11:48 AM, Jean Delvare <khali@linux-fr.org> wrote:
> > On Thu, 13 Jan 2011 11:34:42 -0500, Andy Walls wrote:
> >> How should clock stretches by slaves be handled using i2c-algo-bit?
> >
> > It is already handled. But hdpvr-i2c doesn't use i2c-algo-bit. I2C
> > support is done with USB commands instead. Maybe the hardware
> > implementation doesn't support clock stretching by slaves. Apparently
> > it doesn't support repeated start conditions either, so it wouldn't
> > surprise me.
> 
> The hardware implementation does support clock stretching, or else it
> wouldn't be working under Windows.

I think your conclusion is too fast and possibly incorrect. The traces
Andy pointed us too earlier suggest that the windows driver is also
"polling" the Zilog after the send operation to figure out when it is
available again. If the Zilog was stretching the clock and the master
was seeing that, it wouldn't return until the clock is released, so no
polling would be necessary.

So, either the Zilog isn't stretching the clock in the standard way, or
the master doesn't notice.

> That said, it's possible that the
> driver for the i2c master isn't checking the proper bits to detect the
> clock stretch.  I haven't personally looked at the code for the i2c
> master, so I cannot say one way or the other.

If you're talking about hdpvr-i2c, it's sending USB commands, so it
doesn't seem like we have much control over what happens behind the
scene. If there is any way to improve its reliability, that will
require external knowledge.

-- 
Jean Delvare
