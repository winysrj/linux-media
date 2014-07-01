Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway11.websitewelcome.com ([69.93.164.12]:47353 "EHLO
	gateway11.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757382AbaGATPN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Jul 2014 15:15:13 -0400
Received: from gator3086.hostgator.com (gator3086.hostgator.com [50.87.144.121])
	by gateway11.websitewelcome.com (Postfix) with ESMTP id 3CCBE198917CD
	for <linux-media@vger.kernel.org>; Tue,  1 Jul 2014 13:30:28 -0500 (CDT)
From: "Charlie X. Liu" <charlie@sensoray.com>
To: =?UTF-8?Q?'Daniel_Gl=C3=B6ckner'?= <daniel-gl@gmx.net>,
	=?UTF-8?B?J1ZsxINkdcWjIEZyxIPFo2ltYW4n?=
	<fratiman.vladut@gmail.com>
Cc: <linux-media@vger.kernel.org>
References: <CANtDUYzhibHAis3Qg=nj=nbYf+NeUqS8GJ7kMm4nYZHOSBOBxA@mail.gmail.com> <20140701083941.GA14914@minime.bse>
In-Reply-To: <20140701083941.GA14914@minime.bse>
Subject: RE: bt878A card with 16 inputs
Date: Tue, 1 Jul 2014 11:30:21 -0700
Message-ID: <000b01cf955a$8466d240$8d3476c0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Content-Language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Per: http://www.pcidatabase.com/vendor_details.php?id=542, it's "AVerMediaAverTV WDM AudioCapture (878)". 
Windows driver is at: http://www.mmnt.net/db/0/0/usftp.clevo.com.tw/888E/Optional . You would be able to get device info from there.


-----Original Message-----
From: linux-media-owner@vger.kernel.org [mailto:linux-media-owner@vger.kernel.org] On Behalf Of Daniel Glöckner
Sent: Tuesday, July 01, 2014 1:40 AM
To: Vlăduţ Frăţiman
Cc: linux-media@vger.kernel.org
Subject: Re: bt878A card with 16 inputs

Hi,

On Tue, Jul 01, 2014 at 01:30:55AM +0300, Vlăduţ Frăţiman wrote:
> I have an capture card with two bt878A fusion chip and 16 imputs.
> Linux don't recognize and cannot get to work. How can do to resolve that?

> With regspy on indows i have this:
> BT878 Card [0]:
> 
> Vendor ID:           0x109e
> Device ID:           0x036e
> Subsystem ID:        0x00000000

No Subsystem ID => no automatic recognition possible.


> I try't all card numbers when load bttv module but in the best case 
> only one camera i can see per device on channel 0 (using zoneminder).
> Because is a tunerless card, probably my problem is to make tuner on 
> chip to work.

What we need is most likely the GPIO output enable and data values reported by regspy and btspy. They should differ for each input.

It also helps if you make a high resolution scan of both sides of the card and put it online somewhere (don't send it to the list!).

  Daniel
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html

