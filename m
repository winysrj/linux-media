Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33842 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab1KLStc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Nov 2011 13:49:32 -0500
Received: by wyh15 with SMTP id 15so4767400wyh.19
        for <linux-media@vger.kernel.org>; Sat, 12 Nov 2011 10:49:31 -0800 (PST)
Message-ID: <4ebebfba.5b6be30a.26ea.ffffaa15@mx.google.com>
Subject: Re: [PATCH 3/7] af9015/af9013 full pid filtering
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Date: Sat, 12 Nov 2011 18:49:25 +0000
In-Reply-To: <4EBE9E0F.3060707@iki.fi>
References: <4ebe96f4.6359b40a.5cac.3970@mx.google.com>
	 <4EBE9E0F.3060707@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2011-11-12 at 18:25 +0200, Antti Palosaari wrote:
> On 11/12/2011 05:55 PM, Malcolm Priestley wrote:
> > Allowing the pid to be enabled seems to suppress corrupted stream packets
> > from the first frontend.  This is mainly caused by other high speed devices
> > on the usb bus.
> >
> > Full pid filtering on all frontends.
> > no_pid is defaulted to on.
> > TS frame size it limited to 21, this because if we are only filtering
> > pid 0000, it takes too long to fill up the buffer when tuning or
> > scanning.
> 
> Could you explain that?

Pid 0 transport stream id on some channels is not transmitted very
often.

It needs to be transmitted at least 84 times to fill the devices buffer
up which is typically 5 or 6 seconds, enough for a time out.

The pid packet size is reduced to 21 bring it back in tolerance of most
applications.
 

> PID filter should not be used unless there is no USB1.1 or it is forced 
> using DVB USB module param. PID filter is controlled by DVB USB.
Why?

It can't be module controlled?

> 
> Logic about PID-filtering was done way that it disables 2nd FE when 
> USB1.1 is used since I did not see way to set PID filtering for FE1 and 
> without filtering stream is too wide for USB1.1.
The second frontend is still disabled in USB1.1

> 
> Does that patch force PID filter always on or what?

Yes, and why not?

Pid filtering has it uses in usb 2.0 and works very well. Low power and
low bus usage.

Regards


Malcolm

