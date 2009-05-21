Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:53353 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754723AbZEUWd7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2009 18:33:59 -0400
Subject: Re: [SAA713X TESTERS WANTED] Fix i2c quirk, may affect saa713x +
	mt352 combo
From: hermann pitton <hermann-pitton@arcor.de>
To: Michael Krufky <mkrufky@kernellabs.com>
Cc: Oldrich Jedlicka <oldium.pro@seznam.cz>,
	linux-media <linux-media@vger.kernel.org>
In-Reply-To: <37219a840905210553p1461154m50aa8b31a9a32d59@mail.gmail.com>
References: <37219a840905201257l4673ac7fkc035f3d6656ed26f@mail.gmail.com>
	 <200905210844.31053.oldium.pro@seznam.cz>
	 <303a8ee30905210551r10e976d8ve9ebf9fd1107086c@mail.gmail.com>
	 <37219a840905210553p1461154m50aa8b31a9a32d59@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 22 May 2009 00:30:58 +0200
Message-Id: <1242945058.4474.47.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Donnerstag, den 21.05.2009, 08:53 -0400 schrieb Michael Krufky:
> On Thu, May 21, 2009 at 8:51 AM, Michael Krufky <mkrufky@kernellabs.com> wrote:
> > On Thu, May 21, 2009 at 2:44 AM, Oldrich Jedlicka <oldium.pro@seznam.cz>
> > wrote:
> >>
> >> Hi Mike,
> >>
> >> On Wednesday 20 of May 2009 at 21:57:15, Michael Krufky wrote:
> >> > I have discovered a bug in the saa7134 driver inside the function,
> >> > "saa7134_i2c_xfer"
> >> >
> >> > In order to communicate with certain i2c clients on the saa713x i2c
> >> > bus, a quirk was implemented to prevent failures during read
> >> > transactions.
> >> >
> >> > The quirk forces an i2c write/read to a bogus address that is unlikely
> >> > to be used by any i2c client.
> >> >
> >> > However, this quirk is not functioning properly.  The reason for the
> >> > malfunction is that the i2c address chosen to use as the quirk address
> >> > was 0xfd.
> >> >
> >> > The address 0xfd is indeed an i2c address unlikely to be used by any
> >> > real i2c client, however, the address itself is invalid!  The address,
> >> > 0xfd, has the read bit set -- this is problematic for the hardware,
> >> > and causes the quirk workaround to fail.
> >> >
> >> > It's a wonder that nobody else has complained up to this point.
> >>
> >> I had a problem with 0xfd quirk already (the presence caused the device
> >> not to
> >> respond), this is why there is an exception
> >>
> >>        msgs[i].addr != 0x40
> >>
> >> I can check if it works with your version (0xfe), but the device behind
> >> the
> >> address 0x40 (remote control) is very stupid, so I don't think so.
> >>
> >> I think that better approach would be to use the quirk only for devices
> >> (addresses) that really need it, not for all.
> >>
> >> Cheers,
> >> Oldrich.
> >>
> >> > I am asking for testers, just to make sure that this doesn't cause any
> >> > other strange errors to occur as a side effect.  I don't expect any
> >> > new problems, but its always better to be safe than sorry :-)
> >> >
> >> > This change should not fix any of the other issues currently being
> >> > discussed with the saa7134 driver -- all I am asking is for people to
> >> > test and indicate that the change does not incur any NEW bugs or
> >> > unwanted behavior.
> >> >
> >> > Please test the following repository, and send in your feedback as a
> >> > reply to this thread.  Please remember to keep the mailing list in cc.
> >> >
> >> > http://kernellabs.com/hg/~mk/saa7134
> >> >
> >> > Thanks,
> >> >
> >> > Mike Krufky
> >> > --
> >> > To unsubscribe from this list: send the line "unsubscribe linux-media"
> >> > in
> >> > the body of a message to majordomo@vger.kernel.org
> >> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> >>
> >
> >
> >
> > Thanks for the feedback, guys.  Just to reiterate my original point:
> >
> > I am not questioning the i2c quirk itself -- this is already in the driver,
> > and cards are working already as is.  I am just saying that there is a bug
> > based on the address used.  Consider 7-bit i2c addresses --   0xfd is an
> > 8-bit address, when converted to a 7-bit address and then back to an 8-bit
> > address becomes 0xfc.  I don't know how to explain this properly, but it's
> > invalid.  This is a bug in the saa7131 silicon that requires a write to a
> > valid i2c address to occur before a read transaction, in order to prevent a
> > situation where a read transaction results in no ack from the client.
> >
> > This is a known errata of the NXP silicon.
> >
> > The HVR1110r3 cannot perform successful i2c read transactions from the DVB-T
> > demodulator without this i2c workaround in place, using a valid address.
> >
> > And yes, I am aware of David Wong's situation -- I have a changeset in one
> > of my repositories that will allow us to disable this i2c quirk on a card by
> > card basis, but so far I haven't heard of any card that needs this other
> > than his board.
> >
> > http://linuxtv.org/hg/~mkrufky/dmbth/rev/781ffa6c43d3
> >
> > We can certainly merge that changeset if required.
> >
> > All I am asking is for you to test your boards against this tree and confirm
> > that this changeset does not cause any *new* problems.
> >
> > Thanks go out to Hermann and Oldrich so far, as both of you seem to indicate
> > that this tree did not cause any new problem on your hardware.
> >
> > Thanks again for the feedback.
> >
> > Regards,
> >
> > Mike
> >
> 
> (apologies for the double post -- first one got rejected by vger, again)
> 
> Thanks for the feedback, guys.  Just to reiterate my original point:
> 
> I am not questioning the i2c quirk itself -- this is already in the
> driver, and cards are working already as is.  I am just saying that
> there is a bug based on the address used.  Consider 7-bit i2c
> addresses --   0xfd is an 8-bit address, when converted to a 7-bit
> address and then back to an 8-bit address becomes 0xfc.  I don't know
> how to explain this properly, but it's invalid.  This is a bug in the
> saa7131 silicon that requires a write to a valid i2c address to occur
> before a read transaction, in order to prevent a situation where a
> read transaction results in no ack from the client.
> 
> This is a known errata of the NXP silicon.
> 
> The HVR1110r3 cannot perform successful i2c read transactions from the
> DVB-T demodulator without this i2c workaround in place, using a valid
> address.
> 
> And yes, I am aware of David Wong's situation -- I have a changeset in
> one of my repositories that will allow us to disable this i2c quirk on
> a card by card basis, but so far I haven't heard of any card that
> needs this other than his board.
> 
> 
> http://linuxtv.org/hg/~mkrufky/dmbth/rev/781ffa6c43d3
> 
> We can certainly merge that changeset if required.
> 
> All I am asking is for you to test your boards against this tree and
> confirm that this changeset does not cause any *new* problems.
> 
> Thanks go out to Hermann and Oldrich so far, as both of you seem to
> indicate that this tree did not cause any new problem on your
> hardware.
> 
> Thanks again for the feedback.
> 
> Regards,
> 
> Mike

previously I reported only that i did test on my stuff with disabled
quirk, like it was before the 300i appeared and also my recent cards did
still work.

Now, bad weather came up ;)
and I tested also your repo with the 0xfe change on three different
machines.

With cards like two Medion Quad, CTX948 triple and CTX953. These fail on
2.6.29 for DVB-T without visible i2c errors and there was a report for a
Tiger Hybrid LNA config 2 too. All fine like on anything else except
2.6.29.

Also the Asus Tiger 3in1 LNA config 2, no problems and it had no
problems on 2.6.29 with it. LNA is set to high gain with 0x22, 0x01 to
0x96 and for sure works.

Also tested Asus P7131 Dual, Asus Tiger Rev:1.0.0 and some of the md7134
hybrid devices with FMD1216ME MK3 like CTX917 and CTX946.

As far I know they all follow Philips/NXP reference designs and use
Philips drivers under windows.

For the 300i reports exist, that it works better when it is hot
enough :) You likely need feedback from such problematic cards.

But we of course honor the pioneers in hardware and software.

Strange, that you see now an even improved quirk is needed for
Philips/NXP chips under each other. If NXP confirms the problem, nothing
to discuss, else also not I think.

Cheers,
Hermann

(please try LNA config 1 if you get some time)









