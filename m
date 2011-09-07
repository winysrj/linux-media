Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60917 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969Ab1IGQwD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Sep 2011 12:52:03 -0400
Message-ID: <4E67A12B.8020908@iki.fi>
Date: Wed, 07 Sep 2011 19:51:55 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Michael Krufky <mkrufky@kernellabs.com>
CC: linux-media@vger.kernel.org,
	Jose Alberto Reguero <jareguero@telefonica.net>
Subject: Re: [PATCH 2/3] dvb-usb: multi-frontend support (MFE)
References: <4E2E0788.3010507@iki.fi> <4E3061CF.2080009@redhat.com> <4E306BAE.1020302@iki.fi> <4E35F773.3060807@redhat.com> <4E35FFBF.9010408@iki.fi> <4E360E53.80107@redhat.com>
In-Reply-To: <4E360E53.80107@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/01/2011 05:24 AM, Mauro Carvalho Chehab wrote:
> Em 31-07-2011 22:22, Antti Palosaari escreveu:
>> On 08/01/2011 03:46 AM, Mauro Carvalho Chehab wrote:
>>> One bad thing I noticed with the API is that it calls adap->props.frontend_attach(adap)
>>> several times, instead of just one, without even passing an argument for the driver to
>>> know that it was called twice.
>>>
>>> IMO, there are two ways of doing the attach:
>>>
>>> 1) call it only once, and, inside the driver, it will loop to add the other FE's;
>>> 2) add a parameter, at the call, to say what FE needs to be initialized.
>>>
>>> I think (1) is preferred, as it is more flexible, allowing the driver to test for
>>> several types of frontends.

I am planning to change DVB USB MFE call .frontend_attach() only once. 
Is there any comments about that?

Currently there is anysee, ttusb2 and cx88 drivers which uses MFE and 
change is needed ASAP before more MFE devices are coming.

Also .num_frontends can be removed after that, since DVB USB will just 
loop through 0 to MAX FEs and register all FEs found (fe pointer !NULL).

CURRENTLY:
==========
.frontend_attach()
	if (adap->fe_adap[0].fe == NULL)
		adap->fe_adap[0].fe = dvb_attach(DVB-T)
	else if (adap->fe_adap[1].fe == NULL)
		adap->fe_adap[1].fe = dvb_attach(DVB-C)
	else if (adap->fe_adap[2].fe == NULL)
		adap->fe_adap[2].fe = dvb_attach(DVB-S)

PLANNED:
========
.frontend_attach()
	adap->fe_adap[0].fe = dvb_attach(DVB-T)
	adap->fe_adap[1].fe = dvb_attach(DVB-C)
	adap->fe_adap[2].fe = dvb_attach(DVB-S)


regards
Antti
-- 
http://palosaari.fi/
