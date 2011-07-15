Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770Ab1GONZk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 09:25:40 -0400
Message-ID: <4E203FD0.4030503@redhat.com>
Date: Fri, 15 Jul 2011 10:25:36 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Ralph Metzler <rjkm@metzlerbros.de>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/5] Driver support for cards based on Digital Devices
 bridge (ddbridge)
References: <201107032321.46092@orion.escape-edv.de> <4E1F8E1F.3000008@redhat.com> <4E1FBA6F.10509@redhat.com> <201107150717.08944@orion.escape-edv.de> <19999.63914.990114.26990@morden.metzler>
In-Reply-To: <19999.63914.990114.26990@morden.metzler>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 15-07-2011 05:26, Ralph Metzler escreveu:
> Oliver Endriss writes:
>  > > Both ngene and ddbrige calls dvb_attach once for drxk_attach.
>  > > The logic used there, and by tda18271c2dd driver is different
>  > > from similar logic on other frontends.
>  > > 
>  > > The right fix is to change them to use the same logic, but,
>  > > while we don't do that, we need to patch em28xx-dvb in order
>  > > to do cope with ngene/ddbridge magic.
>  > 
>  > I disagree: The right fix is to extend the framework, and drop the
>  > secondary frondend completely. The current way of supporting
>  > multi-standard tuners is abusing the DVB API.
>  > 
> 
> Yes, exactly what I wanted to say.

Yeah, I see your point.

The current approch, however, is in the mid-term of an unique
multi-delivery-system frontend, and two frontend attachments.
As such, it require some ugly glue at the bridge driver like:

		dvb->fe[1]->tuner_priv = dvb->fe[0]->tuner_priv;
		memcpy(&dvb->fe[1]->ops.tuner_ops,
		       &dvb->fe[0]->ops.tuner_ops,
		       sizeof(dvb->fe[0]->ops.tuner_ops));

My proposal is to keep it as-is for now, changing it after we extend
the API to support multi-delivery-system frontend.
 
> I am just working on yet another C/T combo. This time stv0367 and
> TDA18212. For both there are existing drivers and our own version again.
> I am trying to merge them so that there is not yet another
> discussion regarding new driver versions

Thanks!

> (but the very first version
> might still come out with separate drivers).
> At the same time I want to add delivery system properties to 
> support everything in one frontend device.
> Adding a parameter to select C or T as default should help in most
> cases where the application does not support switching yet.

If I understood well, creating a multi-delivery type of frontend for
devices like DRX-K makes sense for me.

We need to take some care about how to add support for them, to avoid
breaking userspace, or to follow kernel deprecating rules, by adding
some legacy compatibility glue for a few kernel versions. So, the sooner
we add such support, the better, as less drivers will need to support
a "fallback" mechanism.

The current DVB version 5 API doesn't prevent some userspace application
to change the delivery system[1] for a given frontend. This feature is
actually used by DVB-T2 and DVB-S2 drivers. This actually improved the
DVB API multi-fe support, by avoiding the need of create of a secondary
frontend for T2/S2.

Userspace applications can detect that feature by using FE_CAN_2G_MODULATION
flag, but this mechanism doesn't allow other types of changes like
from/to DVB-T/DVB-C or from/to DVB-T/ISDB-T. So, drivers that allow such
type of delivery system switch, using the same chip ended by needing to
add two frontends.

Maybe we can add a generic FE_CAN_MULTI_DELIVERY flag to fe_caps_t, and
add a way to query the type of delivery systems supported by a driver.

[1] http://linuxtv.org/downloads/v4l-dvb-apis/FE_GET_SET_PROPERTY.html#DTV-DELIVERY-SYSTEM

Cheers,
Mauro
