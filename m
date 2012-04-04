Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47264 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756106Ab2DDMkh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Apr 2012 08:40:37 -0400
Received: by eaaq12 with SMTP id q12so76181eaa.19
        for <linux-media@vger.kernel.org>; Wed, 04 Apr 2012 05:40:36 -0700 (PDT)
Message-ID: <4F7C4141.40004@gmail.com>
Date: Wed, 04 Apr 2012 14:40:33 +0200
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org, m@bues.ch, hfvogt@gmx.net,
	mchehab@redhat.com
Subject: Re: [PATCH] af9035: add several new USB IDs
References: <1333540034-14002-1-git-send-email-gennarone@gmail.com> <4F7C3787.5020602@iki.fi>
In-Reply-To: <4F7C3787.5020602@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 04/04/2012 13:59, Antti Palosaari ha scritto:
> On 04.04.2012 14:47, Gianluca Gennari wrote:
>> Add several new USB IDs extracted from the Windows and Linux drivers
>> published
>> by the manufacturers (Terratec and AVerMedia).
>> +    [AF9035_07CA_0867] = {
>> +        USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_0867)},
>>       [AF9035_07CA_1867] = {
>>           USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_1867)},
>> +    [AF9035_07CA_3867] = {
>> +        USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_3867)},
>>       [AF9035_07CA_A867] = {
>>           USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A867)},
>> +    [AF9035_07CA_B867] = {
>> +        USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_B867)},
> 
> It have been common practise to use product names for USB PID
> definitions instead of USB ID numbers. I vote to continue that practise.
> 
> Also, I am not very sure if it is wise to add new IDs without any
> testing. Likely those are just reference design and will work, but
> sometimes there is also some changes done for schematic wiring.
> Especially for Avermedia, see hacks needed some AF9015 Avermedia
> devices. They have put invalid data to eeprom and thus hacks are needed
> for overriding tuner IDs etc.
> Not to mention, driver supports also dynamic IDs and even device ID is
> missing user can load driver using dynamic ID and report it working or
> non-working.
> 
> Anyone else any thoughts about adding IDs without testing ?
> 
> regards
> Antti

Regarding the USB PID definition naming, there is no problem for me.
Actually, some product names were used in the modified versions of your
old driver, so I converted them to the format above just for
convenience. The only problem is that there are so many variations of
the Avermedia sticks that it's hard to give them proper names.

Some of this IDs are already tested (if we include the several
modifications of your old driver).

In particular:
AF9035_0CCD_00AA : confirmed working on Ubuntu.it forum with the old
driver (don't have the link);
AF9035_07CA_0825 : confirmed working on OpenPli forum with the old
driver (see link above);

Others comes from the official Windows drivers so they should be just
little variations of the retail products:
AF9035_07CA_A825, AF9035_07CA_0835, AF9035_07CA_3867.

This IDs are can be the more problematic:
AF9035_15A4_1000, AF9035_15A4_1002, AF9035_15A4_1003,
AF9035_07CA_A333, AF9035_07CA_0337, AF9035_07CA_F337
since there is little or no information about this products.

Anyway, this patch can be a reference for users willing to test the new
driver.

Regards,
Gianluca
