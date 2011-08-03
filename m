Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107Ab1HCLJG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Aug 2011 07:09:06 -0400
Message-ID: <4E392C4B.10207@redhat.com>
Date: Wed, 03 Aug 2011 08:08:59 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Doron Cohen <doronc@siano-ms.com>
CC: BOUWSMA Barry <freebeer.bouwsma@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] drivers: support new Siano tuner devices.
References: <D945C405928A9949A0F33C69E64A1A3BAFFC82@s-mail.siano-ms.ent> <alpine.DEB.2.01.1107310018340.1800@localhost.localdomain> <D945C405928A9949A0F33C69E64A1A3BB39334@s-mail.siano-ms.ent>
In-Reply-To: <D945C405928A9949A0F33C69E64A1A3BB39334@s-mail.siano-ms.ent>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 03-08-2011 02:06, Doron Cohen escreveu:
> Hi Barry,
> One thing I need to check before I approve and even extent this change:
> What happens if the smsdvb module does not exists.
> I assume nothing happens since we are not checking the return code and therefore everything will work as if this call was
> not exist, but I would like to check that before my final decision.
> The reason is that the devices from HAUPPAUGE which currently request for the smsdvb module must use the
> v4l as defined by HAUPPAUGE. Other device based on other SMS chips (Not just the STELLAR but also the NOVA, VENICE, RIO
> and other device series) not always uses the v4l but sometimes has proprietary player which used the SMS device directly. 
> So I wouldn't like to cause harm for those users.
> I seems that requesting the module will not harm, if the module does not exists - the request will fail and everything
> will keep working, and if the module exists it will load but they still won't have to use it.

I think you're calling the DVB API as "v4l". Be careful, as "v4l" is the name of 
the API used for analog TV and webcams. "DVB API" is the name of the API used for
Digital TV, where DVBv3 means the API that supports only DVB/C/T/S and ATSC, and
DVBv5 is the flexible API that supports multiple Delivery Systems, and whose addition
of a new one is just a matter of adding a new set of properties to FE_GET_PROPERTY and
FE_SET_PROPERTY.

The only API acceptable for a DVB driver at the Linux Kernel is the DVB API.
Nothing prevents you to offer other API's to your customers, but upstream 
patches with another API aren't accepted. We had a similar discussion years 
ago, when Uri synced the Siano's internal tree with the kernel one.

That's said, if smsdvb doesn't exist, request_module("smsdvb") won't produce 
any error.

> So in that case I would also add a few more devices to the list (all of Siano devices which 
> supports standards supported by v4l. 

The right solution is to move request_module("smsdvb")to be outside of
the card-specific test, trying to load it for all boards, as it won't 
make sense otherwise (as there's no sense to add the driver to Kernel
without the DVB API, as it won't work as-is).


If there are some Delivery System not yet supported, then the right solution 
is to propose a DVB API addition (using DVBv5 API) to support the new Delivery
System. There are a few ones not properly supported yet. So, go ahead and propose 
adding new properties to support such standards.

Recently, I found some time to update DVBv5 API description for the supported 
Delivery Systems. It is at:
	http://linuxtv.org/downloads/v4l-dvb-apis/FE_GET_SET_PROPERTY.html#fe_property_parameters
The DocBook source for it is at Documentation/DocBook/media/dvb/dvbproperty.xml.

Basically, the API currently documents: DVB-T/T2/C/S/S2, ISDB-T/S and ATSC.

It misses a few standards like DVB-H, DMB and CMMB. Yet, there are a few frontends implementing
them (lgs8gl5, for example, implements DMB-TH). So, maybe all that it is needed for some of
those standards are already there or maybe the current implementations just put everything on
the AUTO mode.

So, maybe it is just a matter of properly documenting what properties those standards need. If not,
adding a few new properties and/or extending the existing ones should be enough to add support
for them.

> If the change will cause problems for users who doesn't need the v4l I will object to this change.
> I will run a few tests on that and either add these changes or let you know of a problem in a few days.
> 
> Regarding DAB+, it was added to the firmware about a year ago, it is required to change the firmware
> file with a newer one and nothing is required in the host layers for that support. Bad news is that 
> according to the patch you gave - you are probably using STELLAR device and there is no such firmware 
> for that device. The DAB+ support was added to newer Siano devices (NOVA and up) but not for the 
> STELLAR due to device HW limitations.

Currently, DAB is not covered by DVBv5 API. So, we'll likely need to add some new properties there
for it.

Cheers,
Mauro
