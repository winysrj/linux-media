Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.seznam.cz ([77.75.72.43]:48033 "EHLO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683AbZEVRKj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2009 13:10:39 -0400
From: Oldrich Jedlicka <oldium.pro@seznam.cz>
To: Michael Krufky <mkrufky@kernellabs.com>
Subject: Re: [SAA713X TESTERS WANTED] Fix i2c quirk, may affect saa713x + mt352 combo
Date: Fri, 22 May 2009 19:10:29 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <37219a840905201257l4673ac7fkc035f3d6656ed26f@mail.gmail.com> <303a8ee30905210551r10e976d8ve9ebf9fd1107086c@mail.gmail.com> <37219a840905210553p1461154m50aa8b31a9a32d59@mail.gmail.com>
In-Reply-To: <37219a840905210553p1461154m50aa8b31a9a32d59@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905221910.29894.oldium.pro@seznam.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 21 of May 2009 at 14:53:00, Michael Krufky wrote:
> On Thu, May 21, 2009 at 8:51 AM, Michael Krufky <mkrufky@kernellabs.com> 
wrote:
> > On Thu, May 21, 2009 at 2:44 AM, Oldrich Jedlicka <oldium.pro@seznam.cz>
> >
> > wrote:
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
> >> > However, this quirk is not functioning properly.  The reason for the
> >> > malfunction is that the i2c address chosen to use as the quirk address
> >> > was 0xfd.
> >> >
> >> > The address 0xfd is indeed an i2c address unlikely to be used by any
> >> > real i2c client, however, the address itself is invalid!  The address,
> >> > 0xfd, has the read bit set -- this is problematic for the hardware,
> >> > and causes the quirk workaround to fail.
> >> >
> >> > It's a wonder that nobody else has complained up to this point.
> >>
> >> I had a problem with 0xfd quirk already (the presence caused the device
> >> not to
> >> respond), this is why there is an exception
> >>
> >>        msgs[i].addr != 0x40
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
> >> > other strange errors to occur as a side effect.  I don't expect any
> >> > new problems, but its always better to be safe than sorry :-)
> >> >
> >> > This change should not fix any of the other issues currently being
> >> > discussed with the saa7134 driver -- all I am asking is for people to
> >> > test and indicate that the change does not incur any NEW bugs or
> >> > unwanted behavior.
> >> >
> >> > Please test the following repository, and send in your feedback as a
> >> > reply to this thread.  Please remember to keep the mailing list in cc.
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
> >> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> > Thanks for the feedback, guys.  Just to reiterate my original point:
> >
> > I am not questioning the i2c quirk itself -- this is already in the
> > driver, and cards are working already as is.  I am just saying that there
> > is a bug based on the address used.  Consider 7-bit i2c addresses --  
> > 0xfd is an 8-bit address, when converted to a 7-bit address and then back
> > to an 8-bit address becomes 0xfc.  I don't know how to explain this
> > properly, but it's invalid.  This is a bug in the saa7131 silicon that
> > requires a write to a valid i2c address to occur before a read
> > transaction, in order to prevent a situation where a read transaction
> > results in no ack from the client.
> >
> > This is a known errata of the NXP silicon.
> >
> > The HVR1110r3 cannot perform successful i2c read transactions from the
> > DVB-T demodulator without this i2c workaround in place, using a valid
> > address.
> >
> > And yes, I am aware of David Wong's situation -- I have a changeset in
> > one of my repositories that will allow us to disable this i2c quirk on a
> > card by card basis, but so far I haven't heard of any card that needs
> > this other than his board.
> >
> > http://linuxtv.org/hg/~mkrufky/dmbth/rev/781ffa6c43d3
> >
> > We can certainly merge that changeset if required.
> >
> > All I am asking is for you to test your boards against this tree and
> > confirm that this changeset does not cause any *new* problems.
> >
> > Thanks go out to Hermann and Oldrich so far, as both of you seem to
> > indicate that this tree did not cause any new problem on your hardware.
> >
> > Thanks again for the feedback.
> >
> > Regards,
> >
> > Mike
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

Mike,

I've just said that my remote control doesn't like the quirk. Anyway, I've 
experimented with the current master branch and my card definitely needs the 
quirk (AverMedia Carbus Hybrid E506R, it has SAA7133 according to dmesg) and 
it makes no difference if the byte value is 0xfd or 0xfe. My remote control 
doesn't like any quirk, so the exception for 0x40 has to be there.

The site kernellabs.com doesn't work now, so I'm not able to verify if you 
were using the i2c_recv_byte() in the quirk in your patch. I kept it there 
during my experiments.

About the I2C address - address byte values from 0xf8 upwords (7-bit address 
1111 1XX plus the R/~W bit) are reserved for future use, so it cannot reach 
any device.

Cheers,
Oldrich.

> Thanks again for the feedback.
>
> Regards,
>
> Mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


