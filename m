Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59399 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab1CCOvX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2011 09:51:23 -0500
Received: by eyx24 with SMTP id 24so364554eyx.19
        for <linux-media@vger.kernel.org>; Thu, 03 Mar 2011 06:51:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTik=GeFXP-aXtO513ojq2=nqir1QdarBs=RRVU+c@mail.gmail.com>
References: <AANLkTi=jkLGgZDH6XytL1MEE7w5SckZjXoGPhFSCo40b@mail.gmail.com>
	<20110215220433.GA3327@redhat.com>
	<20110215221857.GB3327@redhat.com>
	<AANLkTinxCddEK2Ce3k42O3105fi8WqjzV3TDFqDO6WaR@mail.gmail.com>
	<AANLkTikdeg4q9fN7RrO+bYbMjfU-g=id_Y8F=c0TstNj@mail.gmail.com>
	<AANLkTi=1j25xwsC5ks5sEUniyUmVMCK2fKFR-gtEaHC+@mail.gmail.com>
	<AANLkTikkK38w-6uEvG+shT9Vv=n+NsF4enpv7T2N=A1=@mail.gmail.com>
	<20110217141849.GA19291@redhat.com>
	<AANLkTik=GeFXP-aXtO513ojq2=nqir1QdarBs=RRVU+c@mail.gmail.com>
Date: Thu, 3 Mar 2011 09:51:19 -0500
Message-ID: <AANLkTin7G1fp0Eeud1y7jGjJpAY+ZMcfgOubuSbJFQpX@mail.gmail.com>
Subject: Re: IR for remote control not working for Hauppauge WinTV-HVR-1150 (SAA7134)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Fernando Laudares Camargos <fernando.laudares.camargos@gmail.com>
Cc: Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Mar 3, 2011 at 8:51 AM, Fernando Laudares Camargos
<fernando.laudares.camargos@gmail.com> wrote:
> Of course, it did not worked since the device is probably not a i2c
> remote as was HVR-1110. That makes me wondering what have changed at
> the IR level from the HVR-1110 to 1120 and then to 1150 and if the
> remote control is working for anybody having the 1120 board.

>From a design standpoint, it is identical to the 1120 (IR receiver
diode tied directly to a GPIO).  But as I said in my previous email, I
believe that the code is broken for the 1120 as well.

So the upside is that once you fix it for the 1150, the 1120 should
start working properly again as well.  The downside is that you will
have to actually debug the IRQ handler for the GPIO edge timing to
find the underlying bug.  This isn't something as easy as just adding
a couple of lines somewhere for the board profile.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
