Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422809Ab3DFNiQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Apr 2013 09:38:16 -0400
Date: Sat, 6 Apr 2013 10:37:52 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: Adam Sampson <ats@offog.org>, linux-media@vger.kernel.org,
	jdonog01@eircom.net, bugzilla-kernel@tcnnet.com
Subject: Re: Hauppauge Nova-S-Plus DVB-S works for one channel, but cannot
 tune in others
Message-ID: <20130406103752.30ed1408@redhat.com>
In-Reply-To: <2164572.6O2J60F4uN@xrated>
References: <1463242.ms8FUp7FVg@xrated>
	<y2ar4ipcggy.fsf@cartman.at.offog.org>
	<20130405131854.6512bad6@redhat.com>
	<2164572.6O2J60F4uN@xrated>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 06 Apr 2013 12:20:41 +0200
Hans-Peter Jansen <hpj@urpla.net> escreveu:

> Dear Mauro,
> 
> first of all, thank you for providing a proper fix that quickly.
> 
> On Freitag, 5. April 2013 13:18:54 Mauro Carvalho Chehab wrote:
> > Em Fri, 05 Apr 2013 13:25:01 +0100
> > 
> > Adam Sampson <ats@offog.org> escreveu:
> > > Hans-Peter Jansen <hpj@urpla.net> writes:
> > > > In one of my systems, I've used a
> > > > Hauppauge Nova-S-Plus DVB-S card successfully, but after a system
> > > > upgrade to openSUSE 12.2, it cannot tune in all but one channel.
> > > 
> > > [...]
> > > 
> > > > initial transponder 12551500 V 22000000 5
> > > > 
> > > >>>> tune to: 12551:v:0:22000
> > > > 
> > > > DVB-S IF freq is 1951500
> > > > WARNING: >>> tuning failed!!!
> > > 
> > > I suspect you might be running into this problem:
> > >   https://bugzilla.kernel.org/show_bug.cgi?id=9476
> > > 
> > > The bug title is misleading -- the problem is actually that the card
> > > doesn't get configured properly to send the 22kHz tone for high-band
> > > transponders, like the one in your error above.
> > > 
> > > Applying this patch makes my Nova-S-Plus work with recent kernels:
> > >   https://bugzilla.kernel.org/attachment.cgi?id=21905&action=edit
> > 
> > Applying that patch would break support for all other devices with
> > isl6421.
> > 
> > Could you please test the enclosed patch? It allows the bridge
> > driver to tell if the set_tone should be overrided by isl6421 or
> > not. The code only changes it for Hauppauge model 92001.
> 
> Unfortunately, it appears to be more problematic. While the fix allows to scan 
> the channel list, it is not complete (in another setup at the same dish (via 
> multiswitch), vdrs channel list has about 1600 channels, while scan does 
> collect 1138 only.
> 
> More importantly, a single channel (arte) is received with 0 BER and a S/N 
> ratio of 99%, while all other channels produce more BER, eg. "Das Erste" with 
> about 320 BER (SNR 99%, a few artifacts/distortions occasionally), 
> "ZDF" about 6400 BER, (SNR drops down to 75%, constant distortions, and many 
> channels doesn't produce anything beyond distortions with a video stream  
> below 0.3 MBit/s and about 160000 BER. (measured using vdr femon plugin v. 
> 1.6.7)
> 
> So, still no cigar, sorry.
> 
> I've tested both patches, just to be sure, with the same result. I had to 
> relocate and refresh yours in order to apply it to 3.4, since the paths 
> changed, result attached.
> 
> > If it works, please answer this email with a:
> > 	Tested-by: your name <your@email>
> > 
> > For me to add it when merging the patch upstream.
> > 
> > Regards,
> > Mauro.
> 
> It looks like the idea is sound, but the logic is still missing something that 
> prevents it from tuning most channels properly.

Well, what it is expected from this patch is to be able of seeing
channels with H and V polarization. Nothing more, nothing less.

>From what I understood, you're now seeing more than just one channel,
so, it is likely part of the fix, right?

If are there any other issues, then it it would require other fixes,
likely at cx24123 frontend. My guess is that it could be due to some
precision loss maybe at cx24123_set_symbolrate(). It helps if you could
check if the channels that are more problematic have a higher or a
lower bit rate. It probably makes sense to change the code there to
use u64 and asm/div64.h, in order to allow the calculus to have more
precision. I'll try to write such patch.

With regards to this fix, could you please confirm that you can
now get channels with both polarizations?

Thanks,
Mauro
