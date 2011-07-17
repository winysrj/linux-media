Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:53138 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab1GQDCe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jul 2011 23:02:34 -0400
Message-ID: <4E2250C5.2010400@linuxtv.org>
Date: Sun, 17 Jul 2011 05:02:29 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Antti Palosaari <crope@iki.fi>,
	Ralph Metzler <rjkm@metzlerbros.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 0/5] Driver support for cards based on Digital Devices
 bridge (ddbridge)
References: <201107032321.46092@orion.escape-edv.de> <4E1F8E1F.3000008@redhat.com> <4E1FBA6F.10509@redhat.com> <201107150717.08944@orion.escape-edv.de> <19999.63914.990114.26990@morden.metzler> <4E203FD0.4030503@redhat.com> <4E207252.5050506@linuxtv.org> <4E20D042.3000302@iki.fi> <4E21832A.20600@redhat.com> <4E219D49.1070709@iki.fi> <4E21A63A.8040008@redhat.com> <4E21B0DE.2020902@linuxtv.org> <4E21B1E6.4090302@iki.fi> <4E21B3EC.9060709@linuxtv.org> <4E223344.1080109@redhat.com>
In-Reply-To: <4E223344.1080109@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17.07.2011 02:56, Mauro Carvalho Chehab wrote:
> Em 16-07-2011 12:53, Andreas Oberritter escreveu:
>> On 16.07.2011 17:44, Antti Palosaari wrote:
>>> On 07/16/2011 06:40 PM, Andreas Oberritter wrote:
>>>> On 16.07.2011 16:54, Mauro Carvalho Chehab wrote:
>>>>> Em 16-07-2011 11:16, Antti Palosaari escreveu:
>>>>>> On 07/16/2011 03:25 PM, Mauro Carvalho Chehab wrote:
>>>>>>> Em 15-07-2011 20:41, Antti Palosaari escreveu:
>>>>>>>> On 07/15/2011 08:01 PM, Andreas Oberritter wrote:
>>>>>>>>> On 15.07.2011 15:25, Mauro Carvalho Chehab wrote:
>>>>>>>>>> Em 15-07-2011 05:26, Ralph Metzler escreveu:
>>>>>>>>>>> At the same time I want to add delivery system properties to
>>>>>>>>>>> support everything in one frontend device.
>>>>>>>>>>> Adding a parameter to select C or T as default should help in most
>>>>>>>>>>> cases where the application does not support switching yet.
>>>>>>>>>>
>>>>>>>>>> If I understood well, creating a multi-delivery type of frontend
>>>>>>>>>> for
>>>>>>>>>> devices like DRX-K makes sense for me.
>>>>>>>>>>
>>>>>>>>>> We need to take some care about how to add support for them, to
>>>>>>>>>> avoid
>>>>>>>>>> breaking userspace, or to follow kernel deprecating rules, by
>>>>>>>>>> adding
>>>>>>>>>> some legacy compatibility glue for a few kernel versions. So,
>>>>>>>>>> the sooner
>>>>>>>>>> we add such support, the better, as less drivers will need to
>>>>>>>>>> support
>>>>>>>>>> a "fallback" mechanism.
>>>>>>>>>>
>>>>>>>>>> The current DVB version 5 API doesn't prevent some userspace
>>>>>>>>>> application
>>>>>>>>>> to change the delivery system[1] for a given frontend. This
>>>>>>>>>> feature is
>>>>>>>>>> actually used by DVB-T2 and DVB-S2 drivers. This actually
>>>>>>>>>> improved the
>>>>>>>>>> DVB API multi-fe support, by avoiding the need of create of a
>>>>>>>>>> secondary
>>>>>>>>>> frontend for T2/S2.
>>>>>>>>>>
>>>>>>>>>> Userspace applications can detect that feature by using
>>>>>>>>>> FE_CAN_2G_MODULATION
>>>>>>>>>> flag, but this mechanism doesn't allow other types of changes like
>>>>>>>>>> from/to DVB-T/DVB-C or from/to DVB-T/ISDB-T. So, drivers that
>>>>>>>>>> allow such
>>>>>>>>>> type of delivery system switch, using the same chip ended by
>>>>>>>>>> needing to
>>>>>>>>>> add two frontends.
>>>>>>>>>>
>>>>>>>>>> Maybe we can add a generic FE_CAN_MULTI_DELIVERY flag to
>>>>>>>>>> fe_caps_t, and
>>>>>>>>>> add a way to query the type of delivery systems supported by a
>>>>>>>>>> driver.
>>>>>>>>>>
>>>>>>>>>> [1]
>>>>>>>>>> http://linuxtv.org/downloads/v4l-dvb-apis/FE_GET_SET_PROPERTY.html#DTV-DELIVERY-SYSTEM
>>>>>>>>>>
>>>>>>>>>
>>>>>>>>> I don't think it's necessary to add a new flag. It should be
>>>>>>>>> sufficient
>>>>>>>>> to add a property like "DTV_SUPPORTED_DELIVERY_SYSTEMS", which
>>>>>>>>> should be
>>>>>>>>> read-only and return an array of type fe_delivery_system_t.
>>>>>>>>>
>>>>>>>>> Querying this new property on present kernels hopefully fails with a
>>>>>>>>> non-zero return code. in which case FE_GET_INFO should be used to
>>>>>>>>> query
>>>>>>>>> the delivery system.
>>>>>>>>>
>>>>>>>>> In future kernels we can provide a default implementation, returning
>>>>>>>>> exactly one fe_delivery_system_t for unported drivers. Other drivers
>>>>>>>>> should be able to override this default implementation in their
>>>>>>>>> get_property callback.
>>>>>>>>
>>>>>>>> One thing I want to say is that consider about devices which does
>>>>>>>> have MFE using two different *physical* demods, not integrated to
>>>>>>>> same silicon.
>>>>>>>>
>>>>>>>> If you add such FE delsys switch mechanism it needs some more glue
>>>>>>>> to bind two physical FEs to one virtual FE. I see much easier to
>>>>>>>> keep all FEs as own - just register those under the same adapter
>>>>>>>> if FEs are shared.
>>>>>>>
>>>>>>> In this case, the driver should just create two frontends, as
>>>>>>> currently.
>>>>>>>
>>>>>>> There's a difference when there are two physical FE's and just one FE:
>>>>>>> with 2 FE's, the userspace application can just keep both opened at
>>>>>>> the same time. Some applications (like vdr) assumes that all multi-fe
>>>>>>> are like that.
>>>>>>
>>>>>> Does this mean demod is not sleeping (.init() called)?
>>>>>>
>>>>>>> When there's just a single FE, but the driver needs to "fork" it in
>>>>>>> two
>>>>>>> due to the API troubles, the driver needs to prevent the usage of both
>>>>>>> fe's, either at open or at the ioctl level. So, applications like vdr
>>>>>>> will only use the first frontend.
>>>>>>
>>>>>> Lets take example. There is shared MFE having DVB-S, DVB-T and
>>>>>> DVB-C. DVB-T and DVB-C are integrated to one chip whilst DVB-S have
>>>>>> own.
>>
>> One remark: In my previous mail I assumed that in your example DVB-S and
>> either DVB-C or DVB-T can be tuned simultaneously, i.e. there are two
>> antenna connectors and two tuners in addition to the two demod chips. If
>> this assumtion was wrong, then of course approach 2 is the sane one, not
>> approach 3.
>>
>>>>>> Currently it will shown as:
>>>>>
>>>>> Let me name the approaches:
>>>>>
>>>>> Approach 1)
>>>>>> * adapter0
>>>>>> ** frontend0 (DVB-S)
>>>>>> ** frontend1 (DVB-T)
>>>>>> ** frontend2 (DVB-C)
>>>>>
>>>>> Approach 2)
>>>>>> Your new "ideal" solution will be:
>>>>>> * adapter0
>>>>>> ** frontend0 (DVB-S/T/C)
>>>>>
>>>>> Approach 3)
>>>>>> What really happens (mixed old and new):
>>>>>> * adapter0
>>>>>> ** frontend0 (DVB-S)
>>>>>> ** frontend1 (DVB-T/C)
>>>>>
>>>>> What I've said before is that approach 3 is the "ideal" solution.
>>>>>
>>>>>> It does not look very good to offer this kind of mixed solution,
>>>>>> since it is possible to offer only one solution for userspace, new
>>>>>> or old, but not mixing.
>>>>>
>>>>> Good point.
>>>>>
>>>>> There's an additional aspect to handle: if a driver that uses
>>>>> approach 1, a conversion
>>>>> to either approach 2 or 3 would break existing applications that
>>>>> can't handle with
>>>>> the new approach.
>>>>>
>>>>> There's a 4th posibility: always offering fe0 with MFE capabilities,
>>>>> and creating additional fe's
>>>>> for old applications that can't cope with the new mode.
>>>>> For example, on a device that supports
>>>>> DVB-S/DVB-S2/DVB-T/DVB-T2/DVB-C/ISDB-T, it will be shown as:
>>>>>
>>>>> Approach 4) fe0 is a frontend "superset"
>>>>>
>>>>> *adapter0
>>>>> *frontend0 (DVB-S/DVB-S2/DVB-T/DVB-T2/DVB-C/ISDB-T) - aka: FE superset
>>>>> *frontend1 (DVB-S/DVB-S2)
>>>>> *frontend2 (DVB-T/DVB-T2)
>>>>> *frontend3 (DVB-C)
>>>>> *frontend4 (ISDB-T)
>>>>>
>>>>> fe0 will need some special logic to allow redirecting a FE call to
>>>>> the right fe, if
>>>>> there are more than one physical frontend bound into the FE API.
>>>>>
>>>>> I'm starting to think that (4) is the better approach, as it won't
>>>>> break legacy
>>>>> applications, and it will provide an easier way for new applications
>>>>> to control
>>>>> the frontend with just one frontend.
>>>>
>>>> Approach 4 would break existing applications, because suddenly they'd
>>>> have to cope with an additional device. It would be impossible for an
>>>> existing application to tell whether frontend0 (from your example) was a
>>>> real device or not.
>>>>
>>>> Approach 2 doesn't make any sense to me.
>>>
>>> I like approach 1 since it is very simple interface.
> 
> Yes: approach 1 has a simple interface. The only issue on that is that it is
> not possible to know if fe0 and fe1 can be used simultaneously, or if they're
> mutually exclusive. Several userspace applications currently don't work on that
> scenario, where the frontends are mutually exclusive.
> 
> So, if we're going to use approach 1, we need to properly document that applications
> should be prepared for that scenario, and, maybe, adding some way for userspace
> to detect frontend "groups".
> 
>>> Secondly I like
>>> approach 2. I think that more API issue than technical.
> 
> Approach 2 limits the usage of two simultaneous fe, when they're not
> mutually exclusive. Not sure if this is actually a problem.

This would be a problem, of course. If they're not mutually exclusive,
then I'd expect the possibility to use them simultaneously.
