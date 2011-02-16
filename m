Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:25163 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754921Ab1BPMyw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Feb 2011 07:54:52 -0500
Subject: Re: [PATCH 1/4] [media] tuner-core: remove usage of DIGITAL_TV
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <4D5AD880.1050702@redhat.com>
References: <cover.1297776328.git.mchehab@redhat.com>
	 <20110215113334.49ead2c2@pedra>
	 <a0597677-0cba-48b0-97e6-df1fa46464b7@email.android.com>
	 <4D5AD880.1050702@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Feb 2011 07:55:29 -0500
Message-ID: <1297860929.2086.3.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 2011-02-15 at 17:48 -0200, Mauro Carvalho Chehab wrote:
> Em 15-02-2011 15:25, Andy Walls escreveu:
> > Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> > 
> >> tuner-core has no business to do with digital TV. So, don't use
> >> T_DIGITAL_TV on it, as it has no code to distinguish between
> >> them, and nobody fills T_DIGITAL_TV right.
> >>
> >> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> >>

> >> diff --git a/drivers/media/video/tuner-core.c
> >> b/drivers/media/video/tuner-core.c
> >> index dcf03fa..5e1437c 100644
> >> --- a/drivers/media/video/tuner-core.c
> >> +++ b/drivers/media/video/tuner-core.c

> >> @@ -596,7 +595,7 @@ static int tuner_probe(struct i2c_client *client,
> >> 	   first found TV tuner. */
> >> 	tuner_lookup(t->i2c->adapter, &radio, &tv);
> >> 	if (tv == NULL) {
> >> -		t->mode_mask = T_ANALOG_TV | T_DIGITAL_TV;
> >> +		t->mode_mask = T_ANALOG_TV;
> >> 		if (radio == NULL)
> >> 			t->mode_mask |= T_RADIO;
> >> 		tuner_dbg("Setting mode_mask to 0x%02x\n", t->mode_mask);
> >> @@ -607,18 +606,15 @@ register_client:
> >> 	/* Sets a default mode */
> >> 	if (t->mode_mask & T_ANALOG_TV)
> >> 		t->mode = V4L2_TUNER_ANALOG_TV;
> >> -	else if (t->mode_mask & T_RADIO)
> >> -		t->mode = V4L2_TUNER_RADIO;
> >> 	else
> >> -		t->mode = V4L2_TUNER_DIGITAL_TV;
> >> +		t->mode = V4L2_TUNER_RADIO;
                            ^^^^^^^^^^^^^^^^^^^^^
Mauro,

Here's where I saw a default being changed from DIGITAL_TV to RADIO.
Maybe it doesn't matter?

> > Hmm.  I thought tuner-cards.c or tuner-simple.c had entries for hybrid tuner assemblies.  
> 
> They have, but tuner-core takes care only for V4L2 API calls.
> 
> > You are changing the default mode from digital to radio; does that affect the use of the hybrid tuner assemblies.  
> 
> Where are you seeing such change? I just removed T_DIGITAL_TV mode mask, as this is
> unused. On all places at boards, they use a mask with (T_ANALOG_TV | T_DIGITAL_TV).
> The same mask is used at tuner-core. This patch is basically:
> 	s/"T_ANALOG_TV | T_DIGITAL_TV"/T_ANALOG_TV/g
> 
> Also, the default mode is almost meaningless. On all VIDIOC calls that touch at tuner
> (get/set frequency, get/set tuner), the type of the tuner is passed as a parameter.
> So, no default mode is assumed. At digital mode, on all cases, the set_params callback
> will pass the bandwidth, digital tv standard and the frequency to set. The digital TV
> logic inside the tuner will handle it directly, via a direct I2C attach function, not
> using tuner-core.

OK.  

Regards,
Andy

> So, this patch should cause no functional change.
> 
> Cheers,
> Mauro


