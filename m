Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54408 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757145Ab1IGVcO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2011 17:32:14 -0400
Received: by ywf7 with SMTP id 7so87645ywf.19
        for <linux-media@vger.kernel.org>; Wed, 07 Sep 2011 14:32:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E67DDCA.8000908@iki.fi>
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
	<CAHAyoxyc6EyZdUueiF9VpssX8i0LazzL_BgJKczi=MOsfO1fKg@mail.gmail.com>
	<4E67DDCA.8000908@iki.fi>
Date: Wed, 7 Sep 2011 17:32:14 -0400
Message-ID: <CAOcJUbz9HrfPC1bnihb2gjPSE7iM8H64J=kGGSPw6NfYoBog4w@mail.gmail.com>
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

On Wed, Sep 7, 2011 at 5:10 PM, Antti Palosaari <crope@iki.fi> wrote:
> On 09/07/2011 09:36 PM, Michael Krufky wrote:
>>
>> On Wed, Sep 7, 2011 at 2:20 PM, Antti Palosaari<crope@iki.fi>  wrote:
>
>>> Yes, I now saw when looked latest anysee driver that you moved
>>> .streaming_ctrl(), .frontend_attach() and .tuner_attach() to frontend
>>> property. OK, it is not then relevant anymore to change register all as
>>> once.
>>>
>>> What is size_of_priv used?
>>
>> size_of_priv is a signal to the dvb-usb framework to allocate memory
>> of size, size_of_priv to track device state at a given context.  If
>> you look in dvb-usb.h, there was always a size_of_priv / void *priv at
>> the dvb_usb_device context level, and there was always a size_of_priv
>> / void *priv at the dvb_usb_adapter context level.   After my MFE
>> patch, there is now a size_of_priv / void *priv at the
>> dvb_usb_fe_adapter context level.  This private state structure is
>> used to track state at the context of each dvb_usb_fe_adap, to manage
>> the environment needed to switch between the various attached
>> frontends.  You may take a look in mxl111sf.c to see how this is used
>> (ie, struct mxl111sf_adap_state *adap_state =
>> adap->fe_adap[fe->id].priv;)
>>
>> If size_of_priv is left undefined, it is initialized to 0, and the
>> void *priv pointer remains null.
>
> I marvel at there was 3 states, one for device, one for each adapter and now
> even one for each frontend. Surely enough, generally only device state is
> used. And your new driver seems to even use that new FE priv added.

My new driver requires state tracking at the dvb_usb_fe_adapter
context level, but it does *not* require state tracking at the
dvb_usb_adapter level.  The driver also has state tracking at the
dvb_usb_device context level.  It needs this tracking at both levels,
but not at the middle adapter level.

dib0700, however, requires state tracking at the dvb_usb_adapter
context level and it also requires state tracking at the
dvb_usb_device context level.  Most devices that have multiple
adapters follow this same schema for tracking state within various
context levels.

The private state tracking structures are allocated dynamically as
needed, and only if size_of_priv is defined.  Device property contexts
that do not define size_of_priv simply do not allocate any additional
memory for state tracking.

Having the ability to track private state within each context level
gives the dvb-usb framework the maximum flexibility to work with
various styles of both simple and complex digital media receiver
devices.

Regards,

Mike Krufky
