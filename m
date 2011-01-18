Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63451 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab1ARBFL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jan 2011 20:05:11 -0500
Received: by eye27 with SMTP id 27so2958607eye.19
        for <linux-media@vger.kernel.org>; Mon, 17 Jan 2011 17:05:09 -0800 (PST)
Subject: Re: How to help with RTL2832U based TV?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Keld =?ISO-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <20110116105535.GA17461@www2.open-std.org>
References: <20110116105535.GA17461@www2.open-std.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Jan 2011 03:05:04 +0200
Message-ID: <1295312704.3156.3.camel@maxim-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 2011-01-16 at 11:55 +0100, Keld Jørn Simonsen wrote:
> Antti Palosaari wrote Thu, 03 Dec 2009 13:48:01 -0800
> 
> > On 12/03/2009 10:09 PM, Peter Rasmussen wrote:
> > 
> >     as mentioned in the welcome email of this list, but it isn't
> > apparent to
> >     me what the status in Linux of using a device based on this chip is?
> > 
> > I have got today device having this chip (thanks to verkkokauppa.com for
> > sponsoring) and I am going to implement the driver. I am in hope I can
> > share some code from the old RTL2831U chip driver. I haven't looked
> > driver code yet nor taken any sniffs. I will do that during next week.
> 
> OK, what is the status of this now?
> It seems from the status page that it is not finished.
> 
> > Anyhow, there is Realtek released driver spreading over the net for that
> > chip, you can use it.
> 
> I tried to find this but without luck.
> Do you know where it can be found?
> 
> Anyway, I got the dongle to work via the following receipt:
> http://www.linuxin.dk/node/15583 (in Danish, but I think Google can
> translate it).
> 
> I would appreciate that this be in the kernel tree proper

I am doing a driver rewrite.
Don't know when I finish it though.
Could you tell me what tuner you have, and does your card also support
DVB-C?
(some Realtek cards also support Chinese DTMB, but even if yours does,
you probably won't be able to test it (unless you live there).

Best regards,
	Maxim Levitsky

