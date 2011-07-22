Return-path: <linux-media-owner@vger.kernel.org>
Received: from impaqm5.telefonica.net ([213.4.138.21]:22955 "EHLO
	telefonica.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750820Ab1GVQZx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2011 12:25:53 -0400
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH] add support for the dvb-t part of CT-3650 v3
Date: Fri, 22 Jul 2011 18:25:47 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Michael Krufky <mkrufky@kernellabs.com>
References: <201106070205.08118.jareguero@telefonica.net> <201107221802.34505.jareguero@telefonica.net> <4E29A087.4090507@iki.fi>
In-Reply-To: <4E29A087.4090507@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107221825.48246.jareguero@telefonica.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Viernes, 22 de Julio de 2011 18:08:39 Antti Palosaari escribió:
> On 07/22/2011 07:02 PM, Jose Alberto Reguero wrote:
> > On Viernes, 22 de Julio de 2011 13:32:53 Antti Palosaari escribió:
> >> Have you had to time test these?
> >> 
> >> And about I2C adapter, I don't see why changes are needed. As far as I
> >> understand it is already working with TDA10023 and you have done changes
> >> for TDA10048 support. I compared TDA10048 and TDA10023 I2C functions and
> >> those are ~similar. Both uses most typical access, for reg write {u8
> >> REG, u8 VAL} and for reg read {u8 REG}/{u8 VAL}.
> >> 
> >> regards
> >> Antti
> > 
> > I just finish the testing. The changes to I2C are for the tuner tda827x.
> > The MFE fork fine. I need to change the code in tda10048 and ttusb2.
> > Attached is the patch for CT-3650 with your MFE patch.
> 
> You still pass tda10023 fe pointer to tda10048 for I2C-gate control
> which is wrong. Could you send USB sniff I can look what there really
> happens. If you have raw SniffUSB2 logs I wish to check those, other
> logs are welcome too if no raw SniffUSB2 available.
> 

Youre chnage don't work. You need to change the function i2c gate of tda1048 
for the one of tda1023, but the parameter of this function must be the fe 
pointer of tda1023. If this is a problem, I can duplicate tda1023 i2c gate in 
ttusb2 code and pass it to the tda10048. It is done this way in the first patch 
of this thread.

Jose Alberto
  
> regards
> Antti
