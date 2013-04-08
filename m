Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760770Ab3DHCjw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Apr 2013 22:39:52 -0400
Date: Sun, 7 Apr 2013 23:39:23 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: Adam Sampson <ats@offog.org>, linux-media@vger.kernel.org,
	jdonog01@eircom.net, bugzilla-kernel@tcnnet.com
Subject: Re: Hauppauge Nova-S-Plus DVB-S works for one channel, but cannot
 tune in others
Message-ID: <20130407233923.543817ba@redhat.com>
In-Reply-To: <2403957.P6csrtIOfG@xrated>
References: <1463242.ms8FUp7FVg@xrated>
	<1677512.fSL1vcfScG@xrated>
	<20130407140329.6f5db5e4@redhat.com>
	<2403957.P6csrtIOfG@xrated>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 07 Apr 2013 21:10:21 +0200
Hans-Peter Jansen <hpj@urpla.net> escreveu:

> On Sonntag, 7. April 2013 14:03:29 Mauro Carvalho Chehab wrote:
> > Em Sat, 06 Apr 2013 22:20:19 +0200
> > 
> > Hans-Peter Jansen <hpj@urpla.net> escreveu:
> > > On Samstag, 6. April 2013 16:26:32 Mauro Carvalho Chehab wrote:
> > > > Em Sat, 06 Apr 2013 19:26:23 +0200
> > > > 
> > > > Hans-Peter Jansen <hpj@urpla.net> escreveu:
> > > > > On Samstag, 6. April 2013 10:37:52 you wrote:
> > > > > > Em Sat, 06 Apr 2013 12:20:41 +0200
> > > > > > 
> > > > > > Hans-Peter Jansen <hpj@urpla.net> escreveu:
> > > > > > > Dear Mauro,
> > > > > > > 
> > > > > > > first of all, thank you for providing a proper fix that quickly.
> > > > > > > 
> > > > > > > On Freitag, 5. April 2013 13:18:54 Mauro Carvalho Chehab wrote:
> > > > > > > > Em Fri, 05 Apr 2013 13:25:01 +0100
> > > > > > > > 
> > > > > > > > Adam Sampson <ats@offog.org> escreveu:
> > > > > > > > > Hans-Peter Jansen <hpj@urpla.net> writes:
> > > > > > > > > > In one of my systems, I've used a
> > > > > > > > > > Hauppauge Nova-S-Plus DVB-S card successfully, but after a
> > > > > > > > > > system
> > > > > > > > > > upgrade to openSUSE 12.2, it cannot tune in all but one
> > > > > > > > > > channel.
> > > > > > > > > 
> > > > > > > > > [...]
> > > > > > > > > 
> > > > > > > > > > initial transponder 12551500 V 22000000 5
> > > > > > > > > > 
> > > > > > > > > >>>> tune to: 12551:v:0:22000
> > > > > > > > > > 
> > > > > > > > > > DVB-S IF freq is 1951500
> > > > > > > > > > WARNING: >>> tuning failed!!!
> > > > > > > > > 
> > > > > > > > > I suspect you might be running into this problem:
> > > > > > > > >   https://bugzilla.kernel.org/show_bug.cgi?id=9476
> > > > > > > > > 
> > > > > > > > > The bug title is misleading -- the problem is actually that
> > > > > > > > > the
> > > > > > > > > card
> > > > > > > > > doesn't get configured properly to send the 22kHz tone for
> > > > > > > > > high-band
> > > > > > > > > transponders, like the one in your error above.
> > > > > > > > > 
> > > > > > > > > Applying this patch makes my Nova-S-Plus work with recent 
> kernels:
> > > > > > > > >   https://bugzilla.kernel.org/attachment.cgi?id=21905&action=e
> > > > > > > > >   dit
> > > > > > > > 
> > > > > > > > Applying that patch would break support for all other devices
> > > > > > > > with
> > > > > > > > isl6421.
> > > > > > > > 
> > > > > > > > Could you please test the enclosed patch? It allows the bridge
> > > > > > > > driver to tell if the set_tone should be overrided by isl6421 or
> > > > > > > > not. The code only changes it for Hauppauge model 92001.
> > > > > > > 
> > > > > > > Unfortunately, it appears to be more problematic. While the fix
> > > > > > > allows
> > > > > > > to
> > > > > > > scan the channel list, it is not complete (in another setup at the
> > > > > > > same
> > > > > > > dish (via multiswitch), vdrs channel list has about 1600 channels,
> > > > > > > while
> > > > > > > scan does collect 1138 only.
> > > > > > > 
> > > > > > > More importantly, a single channel (arte) is received with 0 BER
> > > > > > > and a
> > > > > > > S/N
> > > > > > > ratio of 99%, while all other channels produce more BER, eg. "Das
> > > > > > > Erste"
> > > > > > > with about 320 BER (SNR 99%, a few artifacts/distortions
> > > > > > > occasionally),
> > > > > > > "ZDF" about 6400 BER, (SNR drops down to 75%, constant
> > > > > > > distortions,
> > > > > > > and
> > > > > > > many channels doesn't produce anything beyond distortions with a
> > > > > > > video
> > > > > > > stream below 0.3 MBit/s and about 160000 BER. (measured using vdr
> > > > > > > femon
> > > > > > > plugin v. 1.6.7)
> > > > > > > 
> > > > > > > So, still no cigar, sorry.
> > > > > > > 
> > > > > > > I've tested both patches, just to be sure, with the same result. I
> > > > > > > had
> > > > > > > to
> > > > > > > relocate and refresh yours in order to apply it to 3.4, since the
> > > > > > > paths
> > > > > > > changed, result attached.
> > > > > > > 
> > > > > > > > If it works, please answer this email with a:
> > > > > > > > 	Tested-by: your name <your@email>
> > > > > > > > 
> > > > > > > > For me to add it when merging the patch upstream.
> > > > > > > > 
> > > > > > > > Regards,
> > > > > > > > Mauro.
> > > > > > > 
> > > > > > > It looks like the idea is sound, but the logic is still missing
> > > > > > > something
> > > > > > > that prevents it from tuning most channels properly.
> > > > > > 
> > > > > > Well, what it is expected from this patch is to be able of seeing
> > > > > > channels with H and V polarization. Nothing more, nothing less.
> > > > > 
> > > > > Okay. Yes, I do.
> > > > > 
> > > > > > From what I understood, you're now seeing more than just one
> > > > > > channel,
> > > > > > so, it is likely part of the fix, right?
> > > > > 
> > > > > Yes.
> > > > 
> > > > Ok, I'll likely be merging it by Monday.
> > > 
> > > Since it fixes the Nova-S-Plus 92001 model for some users, that's great.
> > > 
> > > > > > If are there any other issues, then it it would require other fixes,
> > > > > > likely at cx24123 frontend. My guess is that it could be due to some
> > > > > > precision loss maybe at cx24123_set_symbolrate(). It helps if you
> > > > > > could
> > > > > > check if the channels that are more problematic have a higher or a
> > > > > > lower bit rate. It probably makes sense to change the code there to
> > > > > > use u64 and asm/div64.h, in order to allow the calculus to have more
> > > > > > precision. I'll try to write such patch.
> > > > > 
> > > > > ..that I'm testing right now. Build is on the way.
> > > > > 
> > > > > You wrote and published the fix in less then 8 minutes. Wow,
> > > > > unbelievable.
> > > > 
> > > > Well, the patch is really trivial. If it works or not, only the tests
> > > > can
> > > > tell ;) I have one Nova-S model here, but unfortunately I don't have a
> > > > satellite dish anymore, so I can't test.
> > > 
> > > That's a pity. Bad news: no changes. I double checked, that the new
> > > cx24123
> > > patch was applied. Unfortunately it doesn't help. The behavior is
> > > unchanged
> > > from what I can see.
> > 
> > Ok. As you're getting signals with high symbol rate, it were less likely to
> > have troubles there.
> > 
> > That also means that the patch didn't introduce any bugs, so I'll likely
> > apply it, as this way is better than before.
> > 
> > As you said that you weren't experiencing any issue with a previous kernel,
> > I suggest you to do a diff between cx24123 on the version where everything
> > is OK with the current one, and post here. We can then try to detect where
> > the issue was introduced.
> 
> Hmm, that was an 2.6.2* kernel, IIRC. Only a bisection would make sense. 
> Unfortunately, I cannot spend the time for a bisection today, and tomorrow I 
> get an eagerly awaited Hauppauge WinTV-HVR400 in order to evaluate vdr 2.0 
> with HD eventually, hence after finishing day work, I'm not sure, if I'm able 
> to bridle myself until after the boring bisection. Most likely not.. ;-)

Yeah, bisecting from 2.6.2* could be really boring. As this driver didn't change
that much, perhaps you could speed it up by manually bisecting on the changes
that happened on cx24123 on that time.

Anyway, since kernel 2.6.12, there weren't many changes there:

830e4b5 [media] dvb-frontends: get rid of some "always false" warnings
9a0bf52 [media] move the dvb/frontends to drivers/media/dvb-frontends
7581e61 [media] dvb: Remove ops->info.type from frontends
7c61d80 [media] dvb: don't require a parameter for get_frontend
7e07222 [media] dvb-core: Don't pass DVBv3 parameters on tune() fops
a73efc0 [media] cx23123: convert set_fontend to use DVBv5 parameters
31b4f32 [media] cx23123: remove an unused argument from cx24123_pll_writereg()
a689e36 [media] dvb-core: add support for a DVBv5 get_frontend() callback
bc9cd27 [media] Rename set_frontend fops to set_frontend_legacy
14d24d1 [media] tuners: remove dvb_frontend_parameters from set_params()
25985ed Fix common misspellings
a90f933 [media] i2c: Stop using I2C_CLASS_TV_DIGITAL
1ebcad7 V4L/DVB (12197): Remove unnecessary semicolons
8420fa7 V4L/DVB (10662): remove redundant memset after kzalloc
93504ab V4L/DVB (9260): cx24123: Checkpatch compliance
1d43401 V4L/DVB (8837): dvb: fix I2C adapters name size
6d89761 V4L/DVB (8805): Steven Toth email address change
ca06fa7 V4L/DVB (7470): CX24123: preparing support for CX24113 tuner
9c12224 V4L/DVB (6079): Cleanup: remove linux/moduleparam.h from drivers/media files
3ea9661 V4L/DVB (5840): fix dst and cx24123: tune() callback changed signess for delay
0496daa V4L/DVB (5202): DVB: Use ARRAY_SIZE macro when appropriate
9b5a4a6 V4L/DVB (4699): CX24109 patch to eliminate the weird mis-tunings
ef76856 V4L/DVB (4479): LNB voltage control was inverted for the benefit of geniatech cards on Kworld
d93f886 V4L/DVB (4477): Improve hardware algorithm by setting the appropriate registers
174ff21 V4L/DVB (4435): HW algo
18c053b V4L/DVB (4434): Change BER config
d12a9b9 V4L/DVB (4433): Soft decision threshold
ccd214b V4L/DVB (4284): Cx24123: fix set_voltage function according to the specs
dea7486 V4L/DVB (4028): Change dvb_frontend_ops to be a real field instead of a pointer field inside dvb_frontend
cd20ca9 V4L/DVB (4012): Fix cx24123 diseqc
20b1456 V4L/DVB (3869): Convert cx24123 to refactored tuner code
70047f9 V4L/DVB (3804): Tweak bandselect setup fox cx24123
0e4558a V4L/DVB (3803): Various correctness fixes to tuning.
dce1dfc V4L/DVB (3797): Always wait for diseqc queue to become ready before transmitting a diseqc message
caf970e V4L/DVB (3796): Add several debug messages to cx24123 code
a74b51f V4L/DVB (3795): Fix for CX24123 & low symbol rates
0144f314 V4L/DVB (3130): cx24123: cleanup timout handling
1c956a3 DVB (2451): Add support for KWorld DVB-S 100, based on the same chips as Hauppauge
e3b152b DVB (2446): Minor cleanups.
b79cb65 DVB (2445): Added demodulator driver for Nova-S-Plus and Nova-SE2 DVB-S support.

If it used to work with kernel 2.6.18, and broke at 2.6.2x, my
educated guess is that the regression happened between those 
patches (including them):

$ git describe ca06fa7
v2.6.25-3788-gca06fa7

$ git describe 20b1456
v2.6.17-2503-g20b1456

> Thanks again for your GREAT support, Mauro. Using Linux and Open Source for 
> about 18 years, your engagement is exemplary. Given, that the sub system, you 
> maintain is such an unforgiving mine field¹ just scales up that impression.

Thanks!
> 
> Cheers,
> Pete
> 
> ¹) I just follow this group every now and then..


-- 

Cheers,
Mauro
