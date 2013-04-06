Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:56491 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756574Ab3DFUUr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Apr 2013 16:20:47 -0400
From: Hans-Peter Jansen <hpj@urpla.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Adam Sampson <ats@offog.org>, linux-media@vger.kernel.org,
	jdonog01@eircom.net, bugzilla-kernel@tcnnet.com
Subject: Re: Hauppauge Nova-S-Plus DVB-S works for one channel, but cannot tune in others
Date: Sat, 06 Apr 2013 22:20:19 +0200
Message-ID: <1677512.fSL1vcfScG@xrated>
In-Reply-To: <20130406162632.7d9228b7@redhat.com>
References: <1463242.ms8FUp7FVg@xrated> <1580900.OVB5S0HrEf@xrated> <20130406162632.7d9228b7@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Samstag, 6. April 2013 16:26:32 Mauro Carvalho Chehab wrote:
> Em Sat, 06 Apr 2013 19:26:23 +0200
> 
> Hans-Peter Jansen <hpj@urpla.net> escreveu:
> > On Samstag, 6. April 2013 10:37:52 you wrote:
> > > Em Sat, 06 Apr 2013 12:20:41 +0200
> > > 
> > > Hans-Peter Jansen <hpj@urpla.net> escreveu:
> > > > Dear Mauro,
> > > > 
> > > > first of all, thank you for providing a proper fix that quickly.
> > > > 
> > > > On Freitag, 5. April 2013 13:18:54 Mauro Carvalho Chehab wrote:
> > > > > Em Fri, 05 Apr 2013 13:25:01 +0100
> > > > > 
> > > > > Adam Sampson <ats@offog.org> escreveu:
> > > > > > Hans-Peter Jansen <hpj@urpla.net> writes:
> > > > > > > In one of my systems, I've used a
> > > > > > > Hauppauge Nova-S-Plus DVB-S card successfully, but after a
> > > > > > > system
> > > > > > > upgrade to openSUSE 12.2, it cannot tune in all but one channel.
> > > > > > 
> > > > > > [...]
> > > > > > 
> > > > > > > initial transponder 12551500 V 22000000 5
> > > > > > > 
> > > > > > >>>> tune to: 12551:v:0:22000
> > > > > > > 
> > > > > > > DVB-S IF freq is 1951500
> > > > > > > WARNING: >>> tuning failed!!!
> > > > > > 
> > > > > > I suspect you might be running into this problem:
> > > > > >   https://bugzilla.kernel.org/show_bug.cgi?id=9476
> > > > > > 
> > > > > > The bug title is misleading -- the problem is actually that the
> > > > > > card
> > > > > > doesn't get configured properly to send the 22kHz tone for
> > > > > > high-band
> > > > > > transponders, like the one in your error above.
> > > > > > 
> > > > > > Applying this patch makes my Nova-S-Plus work with recent kernels:
> > > > > >   https://bugzilla.kernel.org/attachment.cgi?id=21905&action=edit
> > > > > 
> > > > > Applying that patch would break support for all other devices with
> > > > > isl6421.
> > > > > 
> > > > > Could you please test the enclosed patch? It allows the bridge
> > > > > driver to tell if the set_tone should be overrided by isl6421 or
> > > > > not. The code only changes it for Hauppauge model 92001.
> > > > 
> > > > Unfortunately, it appears to be more problematic. While the fix allows
> > > > to
> > > > scan the channel list, it is not complete (in another setup at the
> > > > same
> > > > dish (via multiswitch), vdrs channel list has about 1600 channels,
> > > > while
> > > > scan does collect 1138 only.
> > > > 
> > > > More importantly, a single channel (arte) is received with 0 BER and a
> > > > S/N
> > > > ratio of 99%, while all other channels produce more BER, eg. "Das
> > > > Erste"
> > > > with about 320 BER (SNR 99%, a few artifacts/distortions
> > > > occasionally),
> > > > "ZDF" about 6400 BER, (SNR drops down to 75%, constant distortions,
> > > > and
> > > > many channels doesn't produce anything beyond distortions with a video
> > > > stream below 0.3 MBit/s and about 160000 BER. (measured using vdr
> > > > femon
> > > > plugin v. 1.6.7)
> > > > 
> > > > So, still no cigar, sorry.
> > > > 
> > > > I've tested both patches, just to be sure, with the same result. I had
> > > > to
> > > > relocate and refresh yours in order to apply it to 3.4, since the
> > > > paths
> > > > changed, result attached.
> > > > 
> > > > > If it works, please answer this email with a:
> > > > > 	Tested-by: your name <your@email>
> > > > > 
> > > > > For me to add it when merging the patch upstream.
> > > > > 
> > > > > Regards,
> > > > > Mauro.
> > > > 
> > > > It looks like the idea is sound, but the logic is still missing
> > > > something
> > > > that prevents it from tuning most channels properly.
> > > 
> > > Well, what it is expected from this patch is to be able of seeing
> > > channels with H and V polarization. Nothing more, nothing less.
> > 
> > Okay. Yes, I do.
> > 
> > > From what I understood, you're now seeing more than just one channel,
> > > so, it is likely part of the fix, right?
> > 
> > Yes.
> 
> Ok, I'll likely be merging it by Monday.

Since it fixes the Nova-S-Plus 92001 model for some users, that's great.

> > > If are there any other issues, then it it would require other fixes,
> > > likely at cx24123 frontend. My guess is that it could be due to some
> > > precision loss maybe at cx24123_set_symbolrate(). It helps if you could
> > > check if the channels that are more problematic have a higher or a
> > > lower bit rate. It probably makes sense to change the code there to
> > > use u64 and asm/div64.h, in order to allow the calculus to have more
> > > precision. I'll try to write such patch.
> > 
> > ..that I'm testing right now. Build is on the way.
> > 
> > You wrote and published the fix in less then 8 minutes. Wow, unbelievable.
> 
> Well, the patch is really trivial. If it works or not, only the tests can
> tell ;) I have one Nova-S model here, but unfortunately I don't have a
> satellite dish anymore, so I can't test.

That's a pity. Bad news: no changes. I double checked, that the new cx24123 
patch was applied. Unfortunately it doesn't help. The behavior is unchanged
from what I can see.

Here's the debugging output of the cx24123 module with comments:

# tune in the good channel (arte):

Apr  6 22:04:48 xrated kernel: [ 5385.768351] cx88[0]/2-dvb: cx8802_dvb_advise_release
Apr  6 22:04:48 xrated kernel: [ 5385.768410] cx88[0]/2-dvb: cx8802_dvb_advise_acquire
Apr  6 22:04:48 xrated kernel: [ 5385.784365] CX24123: cx24123_send_diseqc_msg: 
Apr  6 22:04:48 xrated kernel: [ 5385.923227] CX24123: cx24123_initfe: init frontend
Apr  6 22:04:48 xrated kernel: [ 5385.947033] CX24123: cx24123_diseqc_send_burst: 
Apr  6 22:04:48 xrated kernel: [ 5386.054894] CX24123: cx24123_set_frontend: 
Apr  6 22:04:48 xrated kernel: [ 5386.056399] CX24123: cx24123_set_inversion: inversion auto
Apr  6 22:04:48 xrated kernel: [ 5386.058834] CX24123: cx24123_set_fec: set FEC to 5/6
Apr  6 22:04:48 xrated kernel: [ 5386.063176] CX24123: cx24123_set_symbolrate: srate=22000000, ratio=0x0037b3a3, sample_rate=50555000 sample_gain=1
Apr  6 22:04:48 xrated kernel: [ 5386.063179] CX24123: cx24123_pll_tune: frequency=993750
Apr  6 22:04:48 xrated kernel: [ 5386.063181] CX24123: cx24123_pll_writereg: pll writereg called, data=0x00100e3f
Apr  6 22:04:48 xrated kernel: [ 5386.070035] CX24123: cx24123_pll_writereg: pll writereg called, data=0x000a0180
Apr  6 22:04:48 xrated kernel: [ 5386.081737] CX24123: cx24123_pll_writereg: pll writereg called, data=0x00000040
Apr  6 22:04:48 xrated kernel: [ 5386.088353] CX24123: cx24123_pll_writereg: pll writereg called, data=0x001f47ad
Apr  6 22:04:48 xrated kernel: [ 5386.096649] CX24123: cx24123_pll_tune: pll tune VCA=1052223, band=64, pll=2049965
Apr  6 22:04:48 xrated kernel: [ 5386.201464] CX24123: cx24123_get_frontend: 
Apr  6 22:04:48 xrated kernel: [ 5386.202165] CX24123: cx24123_get_inversion: read inversion on

# everything is fine, show a perfect stream for 17 sec, now switch to "Das Erste"
# the second best channel:

Apr  6 22:05:05 xrated kernel: [ 5402.838345] cx88[0]/2-dvb: cx8802_dvb_advise_release
Apr  6 22:05:05 xrated kernel: [ 5402.838364] cx88[0]/2-dvb: cx8802_dvb_advise_acquire
Apr  6 22:05:05 xrated kernel: [ 5402.844995] CX24123: cx24123_initfe: init frontend
Apr  6 22:05:05 xrated kernel: [ 5402.868926] CX24123: cx24123_send_diseqc_msg: 
Apr  6 22:05:05 xrated kernel: [ 5403.022665] CX24123: cx24123_diseqc_send_burst: 
Apr  6 22:05:05 xrated kernel: [ 5403.130032] CX24123: cx24123_set_frontend: 
Apr  6 22:05:05 xrated kernel: [ 5403.131587] CX24123: cx24123_set_inversion: inversion auto
Apr  6 22:05:05 xrated kernel: [ 5403.134147] CX24123: cx24123_set_fec: set FEC to 3/4
Apr  6 22:05:05 xrated kernel: [ 5403.138527] CX24123: cx24123_set_symbolrate: srate=27500000, ratio=0x003a05ca, sample_rate=60666000 sample_gain=1
Apr  6 22:05:05 xrated kernel: [ 5403.138587] CX24123: cx24123_pll_tune: frequency=1236500
Apr  6 22:05:05 xrated kernel: [ 5403.138639] CX24123: cx24123_pll_writereg: pll writereg called, data=0x00100e3f
Apr  6 22:05:05 xrated kernel: [ 5403.145421] CX24123: cx24123_pll_writereg: pll writereg called, data=0x000a0180
Apr  6 22:05:05 xrated kernel: [ 5403.152203] CX24123: cx24123_pll_writereg: pll writereg called, data=0x00000201
Apr  6 22:05:05 xrated kernel: [ 5403.158857] CX24123: cx24123_pll_writereg: pll writereg called, data=0x001f44c6
Apr  6 22:05:05 xrated kernel: [ 5403.167529] CX24123: cx24123_pll_tune: pll tune VCA=1052223, band=513, pll=2049222
Apr  6 22:05:05 xrated kernel: [ 5403.274309] CX24123: cx24123_get_frontend: 
Apr  6 22:05:05 xrated kernel: [ 5403.275020] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:05:08 xrated kernel: [ 5406.606664] CX24123: cx24123_get_frontend: 
Apr  6 22:05:08 xrated kernel: [ 5406.607375] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:05:12 xrated kernel: [ 5409.935414] CX24123: cx24123_get_frontend: 
Apr  6 22:05:12 xrated kernel: [ 5409.936213] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:05:13 xrated kernel: [ 5411.148546] CX24123: cx24123_get_frontend: 
Apr  6 22:05:13 xrated kernel: [ 5411.149258] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:05:14 xrated kernel: [ 5412.059054] CX24123: cx24123_get_frontend: 
Apr  6 22:05:14 xrated kernel: [ 5412.059817] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:05:14 xrated kernel: [ 5412.463575] CX24123: cx24123_get_frontend: 
Apr  6 22:05:14 xrated kernel: [ 5412.464279] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:05:17 xrated kernel: [ 5414.885746] CX24123: cx24123_get_frontend: 
Apr  6 22:05:17 xrated kernel: [ 5414.886509] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:05:18 xrated kernel: [ 5415.997814] CX24123: cx24123_get_frontend: 
Apr  6 22:05:18 xrated kernel: [ 5415.998610] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:05:18 xrated kernel: [ 5416.604004] CX24123: cx24123_get_frontend: 
Apr  6 22:05:18 xrated kernel: [ 5416.604773] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:05:19 xrated kernel: [ 5417.513528] CX24123: cx24123_get_frontend: 
Apr  6 22:05:19 xrated kernel: [ 5417.514234] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:05:21 xrated kernel: [ 5418.825570] CX24123: cx24123_get_frontend: 
Apr  6 22:05:21 xrated kernel: [ 5418.826270] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:05:21 xrated kernel: [ 5419.533488] CX24123: cx24123_get_frontend: 
Apr  6 22:05:21 xrated kernel: [ 5419.534201] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:05:23 xrated kernel: [ 5420.846369] CX24123: cx24123_get_frontend: 
Apr  6 22:05:23 xrated kernel: [ 5420.847081] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:05:23 xrated kernel: [ 5421.050152] CX24123: cx24123_get_frontend: 
Apr  6 22:05:23 xrated kernel: [ 5421.050888] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:05:23 xrated kernel: [ 5421.354549] CX24123: cx24123_get_frontend: 
Apr  6 22:05:23 xrated kernel: [ 5421.355253] CX24123: cx24123_get_inversion: read inversion on

# the distortion is visible here by the repeated cx24123_get_frontend/cx24123_get_inversion
# invocations, some visible distortions, switch to a damaged one (ZDF):

Apr  6 22:05:23 xrated kernel: [ 5421.454611] cx88[0]/2-dvb: cx8802_dvb_advise_release
Apr  6 22:05:23 xrated kernel: [ 5421.454639] cx88[0]/2-dvb: cx8802_dvb_advise_acquire
Apr  6 22:05:23 xrated kernel: [ 5421.455336] CX24123: cx24123_initfe: init frontend
Apr  6 22:05:23 xrated kernel: [ 5421.492320] CX24123: cx24123_send_diseqc_msg: 
Apr  6 22:05:23 xrated kernel: [ 5421.647452] CX24123: cx24123_diseqc_send_burst: 
Apr  6 22:05:24 xrated kernel: [ 5421.754847] CX24123: cx24123_set_frontend: 
Apr  6 22:05:24 xrated kernel: [ 5421.756322] CX24123: cx24123_set_inversion: inversion auto
Apr  6 22:05:24 xrated kernel: [ 5421.758759] CX24123: cx24123_set_fec: set FEC to 3/4
Apr  6 22:05:24 xrated kernel: [ 5421.763023] CX24123: cx24123_set_symbolrate: srate=27500000, ratio=0x003a05ca, sample_rate=60666000 sample_gain=1
Apr  6 22:05:24 xrated kernel: [ 5421.763026] CX24123: cx24123_pll_tune: frequency=1353500
Apr  6 22:05:24 xrated kernel: [ 5421.763027] CX24123: cx24123_pll_writereg: pll writereg called, data=0x00100e3f
Apr  6 22:05:24 xrated kernel: [ 5421.769560] CX24123: cx24123_pll_writereg: pll writereg called, data=0x000a0180
Apr  6 22:05:24 xrated kernel: [ 5421.775971] CX24123: cx24123_pll_writereg: pll writereg called, data=0x00000202
Apr  6 22:05:24 xrated kernel: [ 5421.782794] CX24123: cx24123_pll_writereg: pll writereg called, data=0x001f453a
Apr  6 22:05:24 xrated kernel: [ 5421.791368] CX24123: cx24123_pll_tune: pll tune VCA=1052223, band=514, pll=2049338
Apr  6 22:05:24 xrated kernel: [ 5421.895674] CX24123: cx24123_get_frontend: 
Apr  6 22:05:24 xrated kernel: [ 5421.896426] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:05:24 xrated kernel: [ 5422.099346] CX24123: cx24123_get_frontend: 
Apr  6 22:05:24 xrated kernel: [ 5422.100121] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:05:24 xrated kernel: [ 5422.504649] CX24123: cx24123_get_frontend: 
Apr  6 22:05:24 xrated kernel: [ 5422.505463] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:05:25 xrated kernel: [ 5423.211648] CX24123: cx24123_get_frontend: 
Apr  6 22:05:25 xrated kernel: [ 5423.212380] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:05:25 xrated kernel: [ 5423.415355] CX24123: cx24123_get_frontend: 
Apr  6 22:05:25 xrated kernel: [ 5423.416159] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:05:25 xrated kernel: [ 5423.619044] CX24123: cx24123_get_frontend: 
Apr  6 22:05:25 xrated kernel: [ 5423.619807] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:05:26 xrated kernel: [ 5424.326841] CX24123: cx24123_get_frontend: 
Apr  6 22:05:26 xrated kernel: [ 5424.327649] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:05:27 xrated kernel: [ 5425.338309] CX24123: cx24123_get_frontend: 
Apr  6 22:05:27 xrated kernel: [ 5425.339021] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:05:28 xrated kernel: [ 5425.742663] CX24123: cx24123_get_frontend: 
Apr  6 22:05:28 xrated kernel: [ 5425.743429] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:05:28 xrated kernel: [ 5426.148028] CX24123: cx24123_get_frontend: 
Apr  6 22:05:28 xrated kernel: [ 5426.148735] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:05:28 xrated kernel: [ 5426.653281] CX24123: cx24123_get_frontend: 
Apr  6 22:05:28 xrated kernel: [ 5426.653996] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:05:29 xrated kernel: [ 5426.857045] CX24123: cx24123_get_frontend: 
Apr  6 22:05:29 xrated kernel: [ 5426.858245] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:05:29 xrated kernel: [ 5427.061556] CX24123: cx24123_get_frontend: 
Apr  6 22:05:29 xrated kernel: [ 5427.062310] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:05:29 xrated kernel: [ 5427.365074] CX24123: cx24123_get_frontend: 
Apr  6 22:05:29 xrated kernel: [ 5427.365795] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:05:30 xrated kernel: [ 5427.870355] CX24123: cx24123_get_frontend: 
Apr  6 22:05:30 xrated kernel: [ 5427.871059] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:05:31 xrated kernel: [ 5428.678088] CX24123: cx24123_get_frontend: 
Apr  6 22:05:31 xrated kernel: [ 5428.678827] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:05:31 xrated kernel: [ 5428.982453] CX24123: cx24123_get_frontend: 
Apr  6 22:05:31 xrated kernel: [ 5428.983162] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:05:31 xrated kernel: [ 5429.387082] CX24123: cx24123_get_frontend: 
Apr  6 22:05:31 xrated kernel: [ 5429.387844] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:05:32 xrated kernel: [ 5429.792367] CX24123: cx24123_get_frontend: 
Apr  6 22:05:32 xrated kernel: [ 5429.793081] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:05:32 xrated kernel: [ 5430.097632] CX24123: cx24123_get_frontend: 
Apr  6 22:05:32 xrated kernel: [ 5430.098404] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:05:33 xrated kernel: [ 5430.804750] CX24123: cx24123_get_frontend: 
Apr  6 22:05:33 xrated kernel: [ 5430.805466] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:05:33 xrated kernel: [ 5431.210089] CX24123: cx24123_get_frontend: 
Apr  6 22:05:33 xrated kernel: [ 5431.210855] CX24123: cx24123_get_inversion: read inversion on

# the about 2-3 cx24123_get_frontend/cx24123_get_inversion invocations per 
# second document the heavy distortions here, now 3sat, a little less 
# distortion, compared to above

Apr  6 22:06:04 xrated kernel: [ 5462.126946] cx88[0]/2-dvb: cx8802_dvb_advise_release
Apr  6 22:06:04 xrated kernel: [ 5462.126975] cx88[0]/2-dvb: cx8802_dvb_advise_acquire
Apr  6 22:06:04 xrated kernel: [ 5462.142941] CX24123: cx24123_send_diseqc_msg: 
Apr  6 22:06:04 xrated kernel: [ 5462.282574] CX24123: cx24123_initfe: init frontend
Apr  6 22:06:04 xrated kernel: [ 5462.306488] CX24123: cx24123_diseqc_send_burst: 
Apr  6 22:06:04 xrated kernel: [ 5462.413161] CX24123: cx24123_set_frontend: 
Apr  6 22:06:04 xrated kernel: [ 5462.414665] CX24123: cx24123_set_inversion: inversion auto
Apr  6 22:06:04 xrated kernel: [ 5462.417157] CX24123: cx24123_set_fec: set FEC to 5/6
Apr  6 22:06:04 xrated kernel: [ 5462.421438] CX24123: cx24123_set_symbolrate: srate=22000000, ratio=0x0037b3a3, sample_rate=50555000 sample_gain=1
Apr  6 22:06:04 xrated kernel: [ 5462.421445] CX24123: cx24123_pll_tune: frequency=1944750
Apr  6 22:06:04 xrated kernel: [ 5462.421449] CX24123: cx24123_pll_writereg: pll writereg called, data=0x00100e3f
Apr  6 22:06:04 xrated kernel: [ 5462.427984] CX24123: cx24123_pll_writereg: pll writereg called, data=0x000a0180
Apr  6 22:06:04 xrated kernel: [ 5462.434758] CX24123: cx24123_pll_writereg: pll writereg called, data=0x00000220
Apr  6 22:06:04 xrated kernel: [ 5462.441438] CX24123: cx24123_pll_writereg: pll writereg called, data=0x001f4783
Apr  6 22:06:04 xrated kernel: [ 5462.450134] CX24123: cx24123_pll_tune: pll tune VCA=1052223, band=544, pll=2049923
Apr  6 22:06:05 xrated kernel: [ 5462.655630] CX24123: cx24123_get_frontend: 
Apr  6 22:06:05 xrated kernel: [ 5462.656353] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:06:06 xrated kernel: [ 5464.572700] CX24123: cx24123_get_frontend: 
Apr  6 22:06:06 xrated kernel: [ 5464.573454] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:06:07 xrated kernel: [ 5465.482194] CX24123: cx24123_get_frontend: 
Apr  6 22:06:07 xrated kernel: [ 5465.482915] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:06:09 xrated kernel: [ 5466.894964] CX24123: cx24123_get_frontend: 
Apr  6 22:06:09 xrated kernel: [ 5466.895661] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:06:09 xrated kernel: [ 5467.602031] CX24123: cx24123_get_frontend: 
Apr  6 22:06:09 xrated kernel: [ 5467.602777] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:06:12 xrated kernel: [ 5470.427373] CX24123: cx24123_get_frontend: 
Apr  6 22:06:12 xrated kernel: [ 5470.428140] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:06:13 xrated kernel: [ 5470.831789] CX24123: cx24123_get_frontend: 
Apr  6 22:06:13 xrated kernel: [ 5470.832564] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:06:14 xrated kernel: [ 5471.740377] CX24123: cx24123_get_frontend: 
Apr  6 22:06:14 xrated kernel: [ 5471.741140] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:06:14 xrated kernel: [ 5472.245570] CX24123: cx24123_get_frontend: 
Apr  6 22:06:14 xrated kernel: [ 5472.246308] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:06:15 xrated kernel: [ 5472.952418] CX24123: cx24123_get_frontend: 
Apr  6 22:06:15 xrated kernel: [ 5472.953120] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:06:16 xrated kernel: [ 5474.566970] CX24123: cx24123_get_frontend: 
Apr  6 22:06:16 xrated kernel: [ 5474.567703] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:06:17 xrated kernel: [ 5475.174042] CX24123: cx24123_get_frontend: 
Apr  6 22:06:17 xrated kernel: [ 5475.174853] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:06:19 xrated kernel: [ 5477.495375] CX24123: cx24123_get_frontend: 
Apr  6 22:06:19 xrated kernel: [ 5477.496075] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:06:21 xrated kernel: [ 5478.605643] CX24123: cx24123_get_frontend: 
Apr  6 22:06:21 xrated kernel: [ 5478.606343] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:06:21 xrated kernel: [ 5479.010892] CX24123: cx24123_get_frontend: 
Apr  6 22:06:21 xrated kernel: [ 5479.011598] CX24123: cx24123_get_inversion: read inversion on

# now pro7, even without a stable "picture"

Apr  6 22:06:55 xrated kernel: [ 5513.057158] cx88[0]/2-dvb: cx8802_dvb_advise_release
Apr  6 22:06:55 xrated kernel: [ 5513.057189] cx88[0]/2-dvb: cx8802_dvb_advise_acquire
Apr  6 22:06:55 xrated kernel: [ 5513.073138] CX24123: cx24123_send_diseqc_msg: 
Apr  6 22:06:55 xrated kernel: [ 5513.211377] CX24123: cx24123_initfe: init frontend
Apr  6 22:06:55 xrated kernel: [ 5513.235097] CX24123: cx24123_diseqc_send_burst: 
Apr  6 22:06:55 xrated kernel: [ 5513.342913] CX24123: cx24123_set_frontend: 
Apr  6 22:06:55 xrated kernel: [ 5513.344382] CX24123: cx24123_set_inversion: inversion auto
Apr  6 22:06:55 xrated kernel: [ 5513.346830] CX24123: cx24123_set_fec: set FEC to 5/6
Apr  6 22:06:55 xrated kernel: [ 5513.351155] CX24123: cx24123_set_symbolrate: srate=22000000, ratio=0x0037b3a3, sample_rate=50555000 sample_gain=1
Apr  6 22:06:55 xrated kernel: [ 5513.351162] CX24123: cx24123_pll_tune: frequency=1944750
Apr  6 22:06:55 xrated kernel: [ 5513.351166] CX24123: cx24123_pll_writereg: pll writereg called, data=0x00100e3f
Apr  6 22:06:55 xrated kernel: [ 5513.359274] CX24123: cx24123_pll_writereg: pll writereg called, data=0x000a0180
Apr  6 22:06:55 xrated kernel: [ 5513.369254] CX24123: cx24123_pll_writereg: pll writereg called, data=0x00000220
Apr  6 22:06:55 xrated kernel: [ 5513.375809] CX24123: cx24123_pll_writereg: pll writereg called, data=0x001f4783
Apr  6 22:06:55 xrated kernel: [ 5513.384081] CX24123: cx24123_pll_tune: pll tune VCA=1052223, band=544, pll=2049923
Apr  6 22:06:56 xrated kernel: [ 5513.589444] CX24123: cx24123_get_frontend: 
Apr  6 22:06:56 xrated kernel: [ 5513.590141] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:06:58 xrated kernel: [ 5515.607237] CX24123: cx24123_get_frontend: 
Apr  6 22:06:58 xrated kernel: [ 5515.607998] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:06:59 xrated kernel: [ 5516.717685] CX24123: cx24123_get_frontend: 
Apr  6 22:06:59 xrated kernel: [ 5516.718438] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:06:59 xrated kernel: [ 5517.425431] CX24123: cx24123_get_frontend: 
Apr  6 22:06:59 xrated kernel: [ 5517.426190] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:07:01 xrated kernel: [ 5519.343437] CX24123: cx24123_get_frontend: 
Apr  6 22:07:01 xrated kernel: [ 5519.344197] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:07:04 xrated kernel: [ 5522.068048] CX24123: cx24123_get_frontend: 
Apr  6 22:07:04 xrated kernel: [ 5522.068760] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:07:04 xrated kernel: [ 5522.270712] CX24123: cx24123_get_frontend: 
Apr  6 22:07:04 xrated kernel: [ 5522.271420] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:07:04 xrated kernel: [ 5522.473496] CX24123: cx24123_get_frontend: 
Apr  6 22:07:04 xrated kernel: [ 5522.474195] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:07:06 xrated kernel: [ 5523.887241] CX24123: cx24123_get_frontend: 
Apr  6 22:07:06 xrated kernel: [ 5523.888018] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:07:06 xrated kernel: [ 5524.292603] CX24123: cx24123_get_frontend: 
Apr  6 22:07:06 xrated kernel: [ 5524.293306] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:07:07 xrated kernel: [ 5524.899625] CX24123: cx24123_get_frontend: 
Apr  6 22:07:07 xrated kernel: [ 5524.900335] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:07:07 xrated kernel: [ 5525.102312] CX24123: cx24123_get_frontend: 
Apr  6 22:07:07 xrated kernel: [ 5525.103013] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:07:09 xrated kernel: [ 5527.422783] CX24123: cx24123_get_frontend: 
Apr  6 22:07:09 xrated kernel: [ 5527.423543] CX24123: cx24123_get_inversion: read inversion on
Apr  6 22:07:10 xrated kernel: [ 5528.332169] CX24123: cx24123_get_frontend: 
Apr  6 22:07:10 xrated kernel: [ 5528.332878] CX24123: cx24123_get_inversion: read inversion on

Does this help you in some way?

Thanks,
Pete
