Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44760 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab1BPRDe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Feb 2011 12:03:34 -0500
Received: by eye27 with SMTP id 27so918051eye.19
        for <linux-media@vger.kernel.org>; Wed, 16 Feb 2011 09:03:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikdeg4q9fN7RrO+bYbMjfU-g=id_Y8F=c0TstNj@mail.gmail.com>
References: <AANLkTi=jkLGgZDH6XytL1MEE7w5SckZjXoGPhFSCo40b@mail.gmail.com>
	<20110215220433.GA3327@redhat.com>
	<20110215221857.GB3327@redhat.com>
	<AANLkTinxCddEK2Ce3k42O3105fi8WqjzV3TDFqDO6WaR@mail.gmail.com>
	<AANLkTikdeg4q9fN7RrO+bYbMjfU-g=id_Y8F=c0TstNj@mail.gmail.com>
Date: Wed, 16 Feb 2011 12:03:32 -0500
Message-ID: <AANLkTi=1j25xwsC5ks5sEUniyUmVMCK2fKFR-gtEaHC+@mail.gmail.com>
Subject: Re: IR for remote control not working for Hauppauge WinTV-HVR-1150 (SAA7134)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Fernando Laudares Camargos <fernando.laudares.camargos@gmail.com>
Cc: Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Feb 16, 2011 at 11:54 AM, Fernando Laudares Camargos
<fernando.laudares.camargos@gmail.com> wrote:
> Thanks, Jarod, for re-directing the message and explaining why the fix
> from Mauro's wouldn't suffice here.
>
> Devin: I was hoping they (Hauppauge) had used the same componentry as
> of the predecessor board (HVR-1120) for the IR, looks that's not the
> case. I would like to help to get the card supported but unless
> there's a procedure documented somewhere showing what to do I guess I
> don't qualify for the job (don't even understand what you meant by
> "TLC"). But if I can help somehow, I would be glad to do it.

It is the same layout as the 1120 (I cheated and just looked at the
schematic), but despite some user having submitted the patch, it
wasn't working at least for me.  Hence, the fact that you see code in
the driver referencing the 1120 doesn't mean it actually works.

There is no real documented procedure for adding this sort of support.
 It needs to be investigated by an actual driver developer familiar
with the underlying hardware design.  "TLC" is just an English
expression for "Tender Love and Care", an expression that is
synonymous with "giving something the requisite attention".

I've got the board, but just need to find a few hours to debug the IRQ handler.

Devin


-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
