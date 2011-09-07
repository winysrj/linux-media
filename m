Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51539 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757001Ab1IGVKl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Sep 2011 17:10:41 -0400
Message-ID: <4E67DDCA.8000908@iki.fi>
Date: Thu, 08 Sep 2011 00:10:34 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@kernellabs.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Jose Alberto Reguero <jareguero@telefonica.net>
Subject: Re: [PATCH 2/3] dvb-usb: multi-frontend support (MFE)
References: <4E2E0788.3010507@iki.fi>	<4E3061CF.2080009@redhat.com>	<4E306BAE.1020302@iki.fi>	<4E35F773.3060807@redhat.com>	<4E35FFBF.9010408@iki.fi>	<4E360E53.80107@redhat.com>	<4E67A12B.8020908@iki.fi>	<CAOcJUbz-hTf+xi=9JfJVGYsPSs7Cay6uwuwRdK7aiJeQrCtrGQ@mail.gmail.com>	<CAOcJUbzDNXw8j6seVuM1ZkYzV5WRV0nv6Np620hKq5sHe0Bk=g@mail.gmail.com>	<4E67B5E2.4040006@iki.fi> <CAHAyoxyc6EyZdUueiF9VpssX8i0LazzL_BgJKczi=MOsfO1fKg@mail.gmail.com>
In-Reply-To: <CAHAyoxyc6EyZdUueiF9VpssX8i0LazzL_BgJKczi=MOsfO1fKg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/07/2011 09:36 PM, Michael Krufky wrote:
> On Wed, Sep 7, 2011 at 2:20 PM, Antti Palosaari<crope@iki.fi>  wrote:

>> Yes, I now saw when looked latest anysee driver that you moved
>> .streaming_ctrl(), .frontend_attach() and .tuner_attach() to frontend
>> property. OK, it is not then relevant anymore to change register all as
>> once.
>>
>> What is size_of_priv used?
>
> size_of_priv is a signal to the dvb-usb framework to allocate memory
> of size, size_of_priv to track device state at a given context.  If
> you look in dvb-usb.h, there was always a size_of_priv / void *priv at
> the dvb_usb_device context level, and there was always a size_of_priv
> / void *priv at the dvb_usb_adapter context level.   After my MFE
> patch, there is now a size_of_priv / void *priv at the
> dvb_usb_fe_adapter context level.  This private state structure is
> used to track state at the context of each dvb_usb_fe_adap, to manage
> the environment needed to switch between the various attached
> frontends.  You may take a look in mxl111sf.c to see how this is used
> (ie, struct mxl111sf_adap_state *adap_state =
> adap->fe_adap[fe->id].priv;)
>
> If size_of_priv is left undefined, it is initialized to 0, and the
> void *priv pointer remains null.

I marvel at there was 3 states, one for device, one for each adapter and 
now even one for each frontend. Surely enough, generally only device 
state is used. And your new driver seems to even use that new FE priv added.

regards
Antti


-- 
http://palosaari.fi/
