Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:50066 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab3KYOBn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Nov 2013 09:01:43 -0500
Date: Mon, 25 Nov 2013 15:00:55 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Henrik Kurelid <henke@kurelid.se>
Cc: Jean Delvare <khali@linux-fr.org>,
	Manu Abraham <abraham.manu@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>,
	Chris Lee <updatelee@gmail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH 2/3] femon: Display SNR in dB
Message-ID: <20131125150055.076e60be@stein>
In-Reply-To: <20131125144317.330c7a03@stein>
References: <20130603171607.73d0b856@endymion.delvare>
	<20130603172150.1aaf1904@endymion.delvare>
	<CAHFNz9LX0WzmO1zvn51Ge8VQkfiPrao3AQVLprhqrp1V-0h=fQ@mail.gmail.com>
	<20131125102345.4b654435@endymion.delvare>
	<20131125144317.330c7a03@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Nov 25 Stefan Richter wrote:
> On Nov 25 Jean Delvare wrote:
> > Hi Manu,
> > 
> > On Sun, 24 Nov 2013 22:51:33 +0530, Manu Abraham wrote:
> > > Sorry, that I came upon this patch quite late.
> > 
> > No problem, better late than never! :)
> > 
> > > On Mon, Jun 3, 2013 at 8:51 PM, Jean Delvare <khali@linux-fr.org> wrote:
> > > > SNR is supposed to be reported by the frontend drivers in dB, so print
> > > > it that way for drivers which implement it properly.
> > > 
> > > Not all frontends do report report the SNR in dB. Well, You can say quite
> > > some frontends do report it that way.
> > 
> > Last time I discussed this, I was told that this was the preferred way
> > for frontends to report the SNR. I also referred to this document:
> >   http://palosaari.fi/linux/v4l-dvb/snr_2012-05-21.txt
> > I don't know now up-to-date it is by now, but back then it showed a
> > significant number of frontends reporting in .1 dB already, including
> > the ones I'm using right now (drx-3916k and drx-3913k.) With the
> > current version of femon, "femon -H" reports it as 0%, which is quite
> > useless. Thus my patch.
> [...]
> 
> Hi,
> 
> I inherited this in drivers/media/firewire/firedtv-fe.c:
> 
> static int fdtv_read_snr(struct dvb_frontend *fe, u16 *snr)
> {
> 	struct firedtv *fdtv = fe->sec_priv;
> 	struct firedtv_tuner_status stat;
> 
> 	if (avc_tuner_status(fdtv, &stat))
> 		return -EINVAL;
> 
> 	/* C/N[dB] = -10 * log10(snr / 65535) */
> 	*snr = stat.carrier_noise_ratio * 257;
> 	return 0;
> }
> 
> As far as I understand, the comment should have been written with a "FIXME"
> prefix.
> 
> I have no documentation and no personal manufacturer contact (and the
> devices are EOL).  All I know from the driver source is that we do get a 16
> bits wide carrier_noise_ratio.  So it appears to be something on a scale
> from 0x0000 to 0xffff, and the comment makes it look like being on a linear
> scale originally.

Or I got it wrong and all the comment tries to tell that the value to be
returned in the snr argument is meant to be linear on a scale of 0...ffff,
and the code tells that we get a linear value on a scale of 0...255 from
the firmware.  (Cc'ing Henrik who added the code and the comment.)

> I could cross-check with a Windows based TV viewer application what signal
> strength value is presented there to the user with DVB-T and DVB-S2
> incarnations of FireDTV devices.  Right now I don't remember how that
> application presents it (i.e. as percentage or dB or whatever...).
> When I looked at that application and at kaffeine some years ago, they
> displayed grossly different values.  I did not research back then whether
> the Linux driver or kaffeine or both treated it wrong.
> 
> Any advice for the quoted kernel driver code?
> 
> Thanks,

-- 
Stefan Richter
-=====-===-= =-== ==--=
http://arcgraph.de/sr/
