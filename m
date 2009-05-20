Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:60949 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754261AbZETXiF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2009 19:38:05 -0400
Subject: Re: [SAA713X TESTERS WANTED] Fix i2c quirk, may affect saa713x +
	mt352 combo
From: hermann pitton <hermann-pitton@arcor.de>
To: Michael Krufky <mkrufky@kernellabs.com>
Cc: linux-media <linux-media@vger.kernel.org>
In-Reply-To: <37219a840905201257l4673ac7fkc035f3d6656ed26f@mail.gmail.com>
References: <37219a840905201257l4673ac7fkc035f3d6656ed26f@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 21 May 2009 01:36:30 +0200
Message-Id: <1242862590.3728.14.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mike,

Am Mittwoch, den 20.05.2009, 15:57 -0400 schrieb Michael Krufky:
> I have discovered a bug in the saa7134 driver inside the function,
> "saa7134_i2c_xfer"
> 
> In order to communicate with certain i2c clients on the saa713x i2c
> bus, a quirk was implemented to prevent failures during read
> transactions.
> 
> The quirk forces an i2c write/read to a bogus address that is unlikely
> to be used by any i2c client.
> 
> However, this quirk is not functioning properly.  The reason for the
> malfunction is that the i2c address chosen to use as the quirk address
> was 0xfd.
> 
> The address 0xfd is indeed an i2c address unlikely to be used by any
> real i2c client, however, the address itself is invalid!  The address,
> 0xfd, has the read bit set -- this is problematic for the hardware,
> and causes the quirk workaround to fail.
> 
> It's a wonder that nobody else has complained up to this point.
> 
> I am asking for testers, just to make sure that this doesn't cause any
> other strange errors to occur as a side effect.  I don't expect any
> new problems, but its always better to be safe than sorry :-)
> 
> This change should not fix any of the other issues currently being
> discussed with the saa7134 driver -- all I am asking is for people to
> test and indicate that the change does not incur any NEW bugs or
> unwanted behavior.
> 
> Please test the following repository, and send in your feedback as a
> reply to this thread.  Please remember to keep the mailing list in cc.
> 
> http://kernellabs.com/hg/~mk/saa7134
> 
> Thanks,
> 
> Mike Krufky

it did it not make to any of the archives, but in this mail to Henry
Wong I reported that I did test with disabled quirk on some saa7131e and
saa7134 without problems.

On the 300i Gerd got the hint from Pinnacle tech people after having
trouble for quite some time on that first saa7134 DVB device.

On the other LNA config = 1 stuff, buffer 0x22 goes already to 0x96 with
Hartmut latest repo we have. Just tested on a 2.6.25 faking a HVR-1110.
I don't know if you can test anything, but thought at least for analog.

Cheers,
Hermann

copy of the mail about quirk testing.
----------------------------------

                               Von: 
hermann pitton
<hermann-pitton@arcor.de>
                                An: 
David Wong <davidtlwong@gmail.com>
                             Kopie: 
Mauro Carvalho Chehab
<mchehab@infradead.org>,
ramsoft@virgilio.it,
linux-media@vger.kernel.org
                           Betreff: 
Re: Kernel 2.6.29 breaks DVB-T
ASUSTeK Tiger LNA Hybrid Capture
Device
                             Datum: 
        Fri, 24 Apr 2009 01:37:29
+0200


Hi David and all interested,

[snip]
> 
> Sorry for interrupt.
> Would your saa7134 i2c problem is due to the i2c quirk?
> I have problem on the saa7134 i2c quirk that I have to totally disable
> it on my work-in-progress card.
> Just a little suggestion that trying disable the i2c quirk like this
change set:
> http://linuxtv.org/hg/~mkrufky/dmbth/rev/781ffa6c43d3
> 
> David.

I cross post this in for the record.

Commenting the i2c quirk does not help at all on these card, as already
assumed.

And I also can't see any pattern yet, which should cause this from
within v4l-dvb.

At least, but who has hardware to test on all cases, the i2c quirk Gerd
needed for the first saa7134 DVB card ever, the Pinnacle 300i, seems not
to be needed for a few other cards I could test on only for now with
saa7134 and saa7131e.

So, Jean likely is right, that we should have it the other way round and
this might help you and Mike with a decision still to make.

Since 2.6.28 did work for those cards and 2.6.30-rc2-git4 seems to work
within limited usability in my user environment, it seems to be
something in between and might not even be the same.

Cheers,
Hermann

