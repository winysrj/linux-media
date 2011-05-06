Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:56893 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756438Ab1EFNqx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 May 2011 09:46:53 -0400
From: Antti Palosaari <crope@iki.fi>
Reply-To: Antti Palosaari <crope@iki.fi>
To: Steve Kerrison <steve@stevekerrison.com>,
	Andreas Oberritter <obi@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [git:v4l-dvb/for_v2.6.40] [media] Sony CXD2820R DVB-T/T2/C
	demodulator driver
References: <20110506125542.ADA1D162E7@stevekerrison.com>
In-Reply-To: <20110506125542.ADA1D162E7@stevekerrison.com>
Content-Type: text/plain; charset=utf-8
Content-ID: <1304689603.7702.1.camel@Nokia-N900-42-11>
Date: Fri, 06 May 2011 16:46:44 +0300
Message-Id: <1304689604.7702.2.camel@Nokia-N900-42-11>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Steve or Andreas can do it. I am now on holiday weekend, snowboarding maybe last time for this season :)

I cannot do much until next week. All help is welcome!

Antti
-- 
http://palosaari.fi/
----- Original message -----
> If antti doesn't do this before me, I will look at this over the weekend
> and generate a patch against antti's current code... if that's
> appropriate of course (I'm new at this ;))
> 
> Regards,
> Steve Kerrison.
> 
> ----- Reply message -----
> From: "Andreas Oberritter" <obi@linuxtv.org>
> Date: Fri, May 6, 2011 13:36
> Subject: [git:v4l-dvb/for_v2.6.40] [media] Sony CXD2820R DVB-T/T2/C
> demodulator driver To: "Mauro Carvalho Chehab" <mchehab@redhat.com>
> Cc: "Steve Kerrison" <steve@stevekerrison.com>,
> <linux-media@vger.kernel.org>, "Antti Palosaari" <crope@iki.fi>
> 
> 
> On 05/06/2011 02:23 PM, Mauro Carvalho Chehab wrote:
> > Em 06-05-2011 07:42, Steve Kerrison escreveu:
> > > Hi Andreas,
> > > 
> > > From cxd2820r_priv.h:
> > > 
> > > > +/*
> > > > + * FIXME: These are totally wrong and must be added properly to
> > > > the API. + * Only temporary solution in order to get driver
> > > > compile. + */
> > > > +#define SYS_DVBT2                         SYS_DAB
> > > > +#define TRANSMISSION_MODE_1K   0
> > > > +#define TRANSMISSION_MODE_16K 0
> > > > +#define TRANSMISSION_MODE_32K 0
> > > > +#define GUARD_INTERVAL_1_128   0
> > > > +#define GUARD_INTERVAL_19_128 0
> > > > +#define GUARD_INTERVAL_19_256 0
> > > 
> > > 
> > > I believe Antti didn't want to make frontent.h changes until a
> > > consensus was reached on how to develop the API for T2 support.
> > 
> > Yeah.
> > 
> > Andreas/Antti,
> > 
> > It seems more appropriate to remove the above hack and add Andreas
> > patch. I've reviewed it and it seemed ok on my eyes, provided that we
> > also update DVB specs to reflect the changes.
> > 
> > In special, the new DVB command should be documented:
> >     +#define DTV_DVBT2_PLP_ID    43
> 
> In addition to the patch, the PLP ID needs to be stored in struct
> dtv_frontend_properties and used by property cache functions in
> dvb_frontend.c.
> 
> Antti, could you please complete the patch and test it with your device?
> This patch was adapted from an older kernel and only compile-tested few
> weeks ago.
> 
> Regards,
> Andreas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at   http://vger.kernel.org/majordomo-info.html

