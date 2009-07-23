Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34741 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751079AbZGWLKO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jul 2009 07:10:14 -0400
Content-Type: text/plain; charset="iso-8859-1"
Date: Thu, 23 Jul 2009 13:10:06 +0200
From: anderse@gmx.de
Message-ID: <20090723111006.59010@gmx.net>
MIME-Version: 1.0
Subject: Re: [linux-dvb] Terratec Cinergy HTC USB XS HD
To: linux-media@vger.kernel.org
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>On Sat, Jul 18, 2009 at 12:46 PM, Mario Fetka<mario.fe...@gmail.com> wrote:
>> On Saturday, 18. July 2009 04:06:13 Alain Kalker wrote:
>>> Op maandag 15-06-2009 om 22:36 uur [tijdzone +0200], schreef sacha:
>>> > Hello
>>> >
>>> > Does anybody know if this devise will ever work with Linux?
>>> > It was promised by one person last year the support will be available
>>> > within months. One year has gone, nothing happens.
>>> > Is there any alternatives to develop a driver for this devise aside from
>>> > this person?
>>>
>>> Since there has been no answer to your question for some time, I think I
>>> will step in.
>>>
>>> >From http://mcentral.de/wiki/index.php5/Terratec_HTC_XS , the future for
>>>
>>> a driver from Markus for this device does seem to look quite bleak.
>>> However, from looking in the mailinglist archive I gather that Steven
>>> Toth has offered to try getting it to work if someone is willing to
>>> provide him with a device.
>>> Maybe you two could get in contact.
>>> I myself am also interested in a driver for this device but I haven't
>>> got one yet.
>>>
>>> Kind regards,
>>>
>>> Alain
>>>
>> as far as i know there already exists a driver but it could not be published
>> as it is based on the micronas refernce driver
>>
>> i think the problem is related to
>>
>> http://www.linuxtv.org/pipermail/linux-dvb/2008-December/030738.html
>>
>> but this new situation with
>> http://www.tridentmicro.com/Product_drx_39xyK.asp
>>
>> can maby change something about this chip
>>
>> and it would be possible to get the rights to publish the driver under  gpl-2
>>

>This won't solve the issue that the AVFB4910 has been discontinued.
>This affects FM Radio, Analogue TV, Composite and S-Video, that IC
>didn't get bought by Trident.

>regards,
>Markus

Did Devin Heitmueller comment on that? AFAIK he already finished a driver for the DRX-3933J and I would think he might have interest to get in contact with trident in order of being allowed to publish his work.
Should be a rather small step compared to the work he has done so far.
And Trident has some history in cooperating together with XFree developers, 
letting them develop graphics card drivers.

What about this AVFB4910? Is it possible to get a working DVB-C/DVB-T solution without getting in contact with this chip? And once this would be done, there should still be the option of reverse engineering the protocol of that one.

Meanwhile, Terratec has dicontinued the Cinergy HTC USB XS HD, but what about the H5? Does anyone know about its internals already? 

AFAIK, these are still the only non-PCI DVB-C solutions on the market.

Hmm, did micronas give up this full range of products? Sold the 'interesting' part to trident and ceased production of everything else? Maybe half a year ago, they didn't want to disturb ongoing selling negotiations by giving away their intellectual property for free in parallel, and now, after all is settled, maybe they don't mind anymore. 
So contacting those people again could be worth it, too.

best regards, 

Raimund


-- 
Neu: GMX Doppel-FLAT mit Internet-Flatrate + Telefon-Flatrate
für nur 19,99 Euro/mtl.!* http://portal.gmx.net/de/go/dsl02
