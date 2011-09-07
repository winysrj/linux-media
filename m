Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41316 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab1IGSgW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2011 14:36:22 -0400
Received: by vxj15 with SMTP id 15so596839vxj.19
        for <linux-media@vger.kernel.org>; Wed, 07 Sep 2011 11:36:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E67B5E2.4040006@iki.fi>
References: <4E2E0788.3010507@iki.fi>
	<4E3061CF.2080009@redhat.com>
	<4E306BAE.1020302@iki.fi>
	<4E35F773.3060807@redhat.com>
	<4E35FFBF.9010408@iki.fi>
	<4E360E53.80107@redhat.com>
	<4E67A12B.8020908@iki.fi>
	<CAOcJUbz-hTf+xi=9JfJVGYsPSs7Cay6uwuwRdK7aiJeQrCtrGQ@mail.gmail.com>
	<CAOcJUbzDNXw8j6seVuM1ZkYzV5WRV0nv6Np620hKq5sHe0Bk=g@mail.gmail.com>
	<4E67B5E2.4040006@iki.fi>
Date: Wed, 7 Sep 2011 14:36:21 -0400
Message-ID: <CAHAyoxyc6EyZdUueiF9VpssX8i0LazzL_BgJKczi=MOsfO1fKg@mail.gmail.com>
Subject: Re: [PATCH 2/3] dvb-usb: multi-frontend support (MFE)
From: Michael Krufky <mkrufky@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Jose Alberto Reguero <jareguero@telefonica.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 7, 2011 at 2:20 PM, Antti Palosaari <crope@iki.fi> wrote:
> On 09/07/2011 08:45 PM, Michael Krufky wrote:
>>
>> On Wed, Sep 7, 2011 at 1:41 PM, Michael Krufky<mkrufky@kernellabs.com>
>>  wrote:
>>>
>>> On Wed, Sep 7, 2011 at 12:51 PM, Antti Palosaari<crope@iki.fi>  wrote:
>>>>
>>>> On 08/01/2011 05:24 AM, Mauro Carvalho Chehab wrote:
>>>>>
>>>>> Em 31-07-2011 22:22, Antti Palosaari escreveu:
>>>>>>
>>>>>> On 08/01/2011 03:46 AM, Mauro Carvalho Chehab wrote:
>>>>>>>
>>>>>>> One bad thing I noticed with the API is that it calls
>>>>>>> adap->props.frontend_attach(adap)
>>>>>>> several times, instead of just one, without even passing an argument
>>>>>>> for
>>>>>>> the driver to
>>>>>>> know that it was called twice.
>>>>>>>
>>>>>>> IMO, there are two ways of doing the attach:
>>>>>>>
>>>>>>> 1) call it only once, and, inside the driver, it will loop to add the
>>>>>>> other FE's;
>>>>>>> 2) add a parameter, at the call, to say what FE needs to be
>>>>>>> initialized.
>>>>>>>
>>>>>>> I think (1) is preferred, as it is more flexible, allowing the driver
>>>>>>> to
>>>>>>> test for
>>>>>>> several types of frontends.
>>>>
>>>> I am planning to change DVB USB MFE call .frontend_attach() only once.
>>>> Is
>>>> there any comments about that?
>>>>
>>>> Currently there is anysee, ttusb2 and cx88 drivers which uses MFE and
>>>> change
>>>> is needed ASAP before more MFE devices are coming.
>>>>
>>>> Also .num_frontends can be removed after that, since DVB USB will just
>>>> loop
>>>> through 0 to MAX FEs and register all FEs found (fe pointer !NULL).
>>>>
>>>> CURRENTLY:
>>>> ==========
>>>> .frontend_attach()
>>>>        if (adap->fe_adap[0].fe == NULL)
>>>>                adap->fe_adap[0].fe = dvb_attach(DVB-T)
>>>>        else if (adap->fe_adap[1].fe == NULL)
>>>>                adap->fe_adap[1].fe = dvb_attach(DVB-C)
>>>>        else if (adap->fe_adap[2].fe == NULL)
>>>>                adap->fe_adap[2].fe = dvb_attach(DVB-S)
>>>>
>>>> PLANNED:
>>>> ========
>>>> .frontend_attach()
>>>>        adap->fe_adap[0].fe = dvb_attach(DVB-T)
>>>>        adap->fe_adap[1].fe = dvb_attach(DVB-C)
>>>>        adap->fe_adap[2].fe = dvb_attach(DVB-S)
>>>
>>> Antti,
>>>
>>> I don't understand exactly what you are proposing -- Is this a change
>>> for the anysee driver?  ...or is it a change for the dvb-usb
>>> framework?  ...or is it a change to dvb-core, and every driver in the
>>> subsystem?
>>>
>>> In the anysee driver, I see that you are using this:
>>>
>>> .frontend_attach()
>>>         if (adap->fe_adap[0].fe == NULL)
>>>                 adap->fe_adap[0].fe = dvb_attach(DVB-T)
>>>         else if (adap->fe_adap[1].fe == NULL)
>>>                 adap->fe_adap[1].fe = dvb_attach(DVB-C)
>>>         else if (adap->fe_adap[2].fe == NULL)
>>>                 adap->fe_adap[2].fe = dvb_attach(DVB-S)
>>>
>>> I have no problem if you want to change the anysee driver to remove
>>> the second dvb_usb_adap_fe_props context, and replace with the
>>> following:
>>>
>>>
>>> .frontend_attach()
>>>        adap->fe_adap[0].fe = dvb_attach(DVB-T)
>>>        adap->fe_adap[1].fe = dvb_attach(DVB-C)
>>>        adap->fe_adap[2].fe = dvb_attach(DVB-S)
>>>
>>> I believe this will work in the anysee driver for you, even with my
>>> changes that got merged yesterday... However, I do *not* believe that
>>> such change should propogate to the dvb-usb framework or dvb-core
>>> itself, because it can have a large negative impact on the drivers
>>> using it.
>>>
>>> For example, my mxl111sf driver was merged yesterday.  Since it is the
>>> initial driver merge, it currently only supports one frontend (ATSC).
>>> The device also supports two other delivery systems, and has two
>>> additional dtv demodulators, each attached via a separate input bus to
>>> the USB device, each streaming on a separate USB endpoint.
>>>
>>> Many demod drivers do an ID test or some other kind of initialization
>>> during the _attach() function.  A device like the mxl111sf would have
>>> to manipulate the USB device state and alter the bus operations before
>>> and after each frontend attachment in order for the _attach() calls to
>>> succeed, not to mention the separate calls needed for bus negotiation
>>> to power on the correct demodulator and initialize its streaming data
>>> path.
>>>
>>> I repeat, if this is a change that is specific to your anysee driver,
>>> then it seems like a good idea to me.  However, if your plan is to
>>> change dvb-usb itself, and / or dvb-core, then I'd really like to have
>>> a better idea of the implications that this change will bring forth.
>>>
>>> So, to help reduce the confusion, can you clarify exactly what code
>>> you plan to change, and what impact it will have on the drivers that
>>> exist today?
>>>
>>> Best Regards,
>>>
>>> Michael Krufky
>>>
>>
>> ADDENDUM:
>>
>> For the anysee driver, for your single .frontend_attach()
>>        adap->fe_adap[0].fe = dvb_attach(DVB-T)
>>        adap->fe_adap[1].fe = dvb_attach(DVB-C)
>>        adap->fe_adap[2].fe = dvb_attach(DVB-S)
>>
>> ...for this to work in today's dvb-usb code without modification to
>> the dvb-usb framework, i believe that you should do a test for
>> (adap->fe_adap[0].fe&&  adap->fe_adap[1].fe&&  adap->fe_adap[2].fe )
>> ... if null, then attach, if not null, then exit -- this will prevent
>> the second context's initialization from occurring twice.
>
> Yes, I now saw when looked latest anysee driver that you moved
> .streaming_ctrl(), .frontend_attach() and .tuner_attach() to frontend
> property. OK, it is not then relevant anymore to change register all as
> once.
>
> What is size_of_priv used?

size_of_priv is a signal to the dvb-usb framework to allocate memory
of size, size_of_priv to track device state at a given context.  If
you look in dvb-usb.h, there was always a size_of_priv / void *priv at
the dvb_usb_device context level, and there was always a size_of_priv
/ void *priv at the dvb_usb_adapter context level.   After my MFE
patch, there is now a size_of_priv / void *priv at the
dvb_usb_fe_adapter context level.  This private state structure is
used to track state at the context of each dvb_usb_fe_adap, to manage
the environment needed to switch between the various attached
frontends.  You may take a look in mxl111sf.c to see how this is used
(ie, struct mxl111sf_adap_state *adap_state =
adap->fe_adap[fe->id].priv;)

If size_of_priv is left undefined, it is initialized to 0, and the
void *priv pointer remains null.

Regards,

Mike Krufky
