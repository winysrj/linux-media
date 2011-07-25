Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63930 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab1GYKYG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jul 2011 06:24:06 -0400
Received: by ewy4 with SMTP id 4so2345805ewy.19
        for <linux-media@vger.kernel.org>; Mon, 25 Jul 2011 03:24:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <73512a61-63b5-4e42-bbda-26e33ec8ec35@cnxthub2.bbnet.ad>
References: <CAGoCfiyp4TB6RvF75WFrFLkTxha0-XKrXnR8L13BwJu938PaHg@mail.gmail.com>
	<4E2C16B5.5010703@redhat.com>
	<73512a61-63b5-4e42-bbda-26e33ec8ec35@cnxthub2.bbnet.ad>
Date: Mon, 25 Jul 2011 06:24:03 -0400
Message-ID: <CAGoCfizcdGFPyPC6zYBKPcVJxr5PC4TWG7Kt4iNzQaCiKiiCnA@mail.gmail.com>
Subject: Re: [PATCH] Fix regression introduced which broke the Hauppauge
 USBLive 2
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Palash Bandyopadhyay <Palash.Bandyopadhyay@conexant.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Sri Deevi <Srinivasa.Deevi@conexant.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 25, 2011 at 1:48 AM, Palash Bandyopadhyay
<Palash.Bandyopadhyay@conexant.com> wrote:
> Mauro/Devin,
>
>  Can someone give steps to reproduce the problem? Also if we need any particular h/w board to reproduce this problem. I dont seem to recall any delay requirement on the chip at power up/cycle time. Any I also dont recall seeing any problems with the Conexant evk boards. Mauro, have you been able to see this issue with a Conexant board?

Hello Palash,

The problem occurs if the kernel is configured for CONFIG_HZ to 1000
and on the Hauppauge USBLIve 2 hardware design.  I'm assuming it's
tied to two factors:

1.  Some aspect of the power supply tied to the Mako core being a
little slow to startup.  I haven't compared the schematic to the EVK,
but I could do that if we *really* think that is a worthwhile
exercise.
2.  On typical kernels which have CONFIG_HZ set to 100, a call to
msleep(5) will actually take approximately 10ms (due to the clock
resolution).  However, if you have CONFIG_HZ set to 1000 then the call
*actually* takes 5ms which is too short for this design.  In other
words, you would be unlikely to notice the issue unless you had
CONFIG_HZ set to a high enough resolution for the msleep(5) to
actually take 5ms.

The changed as proposed should be very low impact.  For users who have
CONFIG_HZ set to 100 (which is typical), there will be no visible
increase in time (since the call was already taking 10ms).  For users
who have CONFIG_HZ set to 1000, the net effect is that it takes an
extra 20ms to switch hardware modes (since the #define in question is
used at most four times in sequence).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
