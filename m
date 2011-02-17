Return-path: <mchehab@pedra>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44011 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab1BQLY2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Feb 2011 06:24:28 -0500
Received: by vws16 with SMTP id 16so1018982vws.19
        for <linux-media@vger.kernel.org>; Thu, 17 Feb 2011 03:24:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=1j25xwsC5ks5sEUniyUmVMCK2fKFR-gtEaHC+@mail.gmail.com>
References: <AANLkTi=jkLGgZDH6XytL1MEE7w5SckZjXoGPhFSCo40b@mail.gmail.com>
	<20110215220433.GA3327@redhat.com>
	<20110215221857.GB3327@redhat.com>
	<AANLkTinxCddEK2Ce3k42O3105fi8WqjzV3TDFqDO6WaR@mail.gmail.com>
	<AANLkTikdeg4q9fN7RrO+bYbMjfU-g=id_Y8F=c0TstNj@mail.gmail.com>
	<AANLkTi=1j25xwsC5ks5sEUniyUmVMCK2fKFR-gtEaHC+@mail.gmail.com>
Date: Thu, 17 Feb 2011 09:24:27 -0200
Message-ID: <AANLkTikkK38w-6uEvG+shT9Vv=n+NsF4enpv7T2N=A1=@mail.gmail.com>
Subject: Re: IR for remote control not working for Hauppauge WinTV-HVR-1150 (SAA7134)
From: Fernando Laudares Camargos <fernando.laudares.camargos@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Ok, Devin.

I'm not sure about how it would went but if you think it would be
worth trying to get info about the components of the 1150 directly
from Hauppauge, I can give them a call and see what happens. I've just
ordered 20 of those boards for a project that initially wouldn't relly
on RC but since the IR seems to be there. I'm not saying they would
help, it would be just a try if you think it could help...

Regards,

Fernando

On Wed, Feb 16, 2011 at 3:03 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Wed, Feb 16, 2011 at 11:54 AM, Fernando Laudares Camargos
> <fernando.laudares.camargos@gmail.com> wrote:
>> Thanks, Jarod, for re-directing the message and explaining why the fix
>> from Mauro's wouldn't suffice here.
>>
>> Devin: I was hoping they (Hauppauge) had used the same componentry as
>> of the predecessor board (HVR-1120) for the IR, looks that's not the
>> case. I would like to help to get the card supported but unless
>> there's a procedure documented somewhere showing what to do I guess I
>> don't qualify for the job (don't even understand what you meant by
>> "TLC"). But if I can help somehow, I would be glad to do it.
>
> It is the same layout as the 1120 (I cheated and just looked at the
> schematic), but despite some user having submitted the patch, it
> wasn't working at least for me.  Hence, the fact that you see code in
> the driver referencing the 1120 doesn't mean it actually works.
>
> There is no real documented procedure for adding this sort of support.
>  It needs to be investigated by an actual driver developer familiar
> with the underlying hardware design.  "TLC" is just an English
> expression for "Tender Love and Care", an expression that is
> synonymous with "giving something the requisite attention".
>
> I've got the board, but just need to find a few hours to debug the IRQ handler.
>
> Devin
>
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
>
