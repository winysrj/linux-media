Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143Ab3AWWCs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jan 2013 17:02:48 -0500
Date: Wed, 23 Jan 2013 20:02:35 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Manu Abraham <abraham.manu@gmail.com>,
	Simon Farnsworth <simon.farnsworth@onelan.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <devin.heitmueller@gmail.com>
Subject: Re: [PATCH RFCv10 00/15] DVB QoS statistics API
Message-ID: <20130123200235.1a1e6f1a@redhat.com>
In-Reply-To: <20130123190011.502517d7@redhat.com>
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
	<20130116152151.5461221c@redhat.com>
	<CAHFNz9KjG-qO5WoCMzPtcdb6d-4iZk695zp_L3iSeb=ZiWKhQw@mail.gmail.com>
	<2817386.vHx2V41lNt@f17simon>
	<20130116200153.3ec3ee7d@redhat.com>
	<CAHFNz9L-Dzrv=+Z01ndrfK3GmvFyxT6941W4-_63bwn1HrQBYQ@mail.gmail.com>
	<50F7C57A.6090703@iki.fi>
	<20130117145036.55745a60@redhat.com>
	<50F831AA.8010708@iki.fi>
	<20130117161126.6b2e809d@redhat.com>
	<50F84276.3080909@iki.fi>
	<CAHFNz9JDqYnrmNDt0_nBJMgzAymZSCXBbwY5MHR8AkMopPPQOA@mail.gmail.com>
	<20130117165037.6ed80366@redhat.com>
	<50F84CCC.5040103@iki.fi>
	<20130122101626.006d2d87@redhat.com>
	<50FFFD0B.30701@iki.fi>
	<20130123161801.764495e5@redhat.com>
	<20130123165732.0e8e74bb@redhat.com>
	<51004014.8020809@iki.fi>
	<20130123190011.502517d7@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 23 Jan 2013 19:00:11 -0200
Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:

> Em Wed, 23 Jan 2013 21:55:00 +0200
> Antti Palosaari <crope@iki.fi> escreveu:
> 
> > On 01/23/2013 08:57 PM, Mauro Carvalho Chehab wrote:
> > > Em Wed, 23 Jan 2013 16:18:01 -0200
> > > Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:
> > >
> > >> I'll soon post patches 1 and 2 after those changes. The remaining 4 patches
> > >> don't likely need any change.
> > >
> > > Actually, it sounds better to just do a diff between the two versions.
> > > Each individual patch on v13 is at:
> > > 	http://git.linuxtv.org/mchehab/experimental.git/shortlog/refs/heads/stats_v13
> > >
> > > Cheers,
> > > Mauro
> > >
> > > v13:
> > > - Add post-Viterbi BER on the API
> > > - Some documentation adjustments as suggested by Antti
> > >
> > > Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> > 
> > For all the DVB-core related statistics API changes in that patch serie:
> > 
> > Reviewed-by: Antti Palosaari <crope@iki.fi>
> 
> Thanks!
> > 
> > 
> > I have still one comment about naming:
> > DTV_STAT_PRE_BIT_ERROR_COUNT   => DTV_STAT_PRE_ERROR_BIT_COUNT
> > DTV_STAT_PRE_TOTAL_BIT_COUNT
> > DTV_STAT_POST_BIT_ERROR_COUNT  => DTV_STAT_POST_ERROR_BIT_COUNT
> > DTV_STAT_POST_TOTAL_BIT_COUNT
> > DTV_STAT_ERROR_BLOCK_COUNT
> > DTV_STAT_TOTAL_BLOCK_COUNT
> > 
> > I like to change those two. Anyway, if you think current naming is 
> > better then leave as it is.
> 
> Works for me.

Ok, statistics patches merged at the development tree. The next step,
on Kernelspace, is to gradually add DVBv5.10 statistics support on the
existing frontends.

I also merged the dvbv5-tools patches at:
	http://git.linuxtv.org/v4l-utils.git

The new code there is currently being called only for dvbv5-zap, although
it should be easy to make it to work with dvbv5-scan, as the statistics
code is part of the library. 

There's also a "quality" statistics there in the library,
calculated on userspace:
	http://git.linuxtv.org/v4l-utils.git/commitdiff/d7237c75d9e507ebd51666248dca18feeee8d814

This way, its policy can be easily changed/fixed.

When time permits and after having some confidence about the quality calculus,
My plan is to change the code at the userspace tools to only display,
by default, DVB FE status, strength and (per layer) quality, and to add
an extra option to allow displaying all available stats if the user wants to.

I should also add the same stats code later to dvbv5-scan.

It should be noticed that the quality statistics there are very experimental, 
as I was not able to research for the quality criteria that apply to all DVB
standards.

As one may know, there are actually 3 probability density functions (p. d. f.)
commonly used to describe how the signal to noise ratio interferes on a given 
radio signal: Gaussian, Rician and Raileigh fading, being the last ones typically
closer to real life. The DVB specs define channels in function of all those
three distros. There are, of course, other stochastic models that provide 
different values for the quality, in function of the S/N ratio.

For the quality metrics on terrestrial delivery systems, I based the policy
on both ETSI DVB and ABNT ISDB terrestrial specs, in a way that "Good" means
a Quasi Error Free channel with Raileigh fading[1], e. g. there's no line
of sight signal. On such channels, the S/N ratio should be bigger than on
the other two p. d. f. 

Also, for DVB, the "OK" quality is matching the minimum S/N ratio for the
the Rician fading distribution, e. g., if there is a line of sight signal
that it is stronger than the reflected ones, signal="OK" actually means
a good signal. A more precise application would need to "calibrate" the
quality statistics between Rician and Raileigh distributions, either
if there's a direct sight signal or not.

If available, if BER or PER measures are also taken into account for
the quality statistics, e. g., the signal indicator can
change from "good" to "OK" or "poor" if there are too much errors. 
For now, due to the lack of time to do more research, I just did an 
educated guess for the expected value for parameters, but I'm sure 
that there are plenty of space for improvements.

It should be said that, in practice, the signal can behave different than
either Raileigh or Rician fading. So, the measure just give a rough idea
about the signal quality.

Anyway, patches fixing/improving it are very welcome.

-- 

[1] http://en.wikipedia.org/wiki/Rician_fading

Cheers,
Mauro
