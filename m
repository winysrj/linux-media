Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:35012 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760977AbZFXRoO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jun 2009 13:44:14 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: =?iso-8859-1?Q?Daniel_Gl=F6ckner?= <daniel-gl@gmx.net>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 24 Jun 2009 12:44:08 -0500
Subject: RE: sub devices sharing same i2c address
Message-ID: <A69FA2915331DC488A831521EAE36FE40139F9D8FA@dlee06.ent.ti.com>
References: <A69FA2915331DC488A831521EAE36FE40139EDB7B2@dlee06.ent.ti.com>
 <20090623191052.GA302@daniel.bse>
In-Reply-To: <20090623191052.GA302@daniel.bse>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Daniel,

Thanks for responding....

Any reason why this is not added to upstream ? I think this is exactly what is needed to support this.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
Phone : 301-515-3736
email: m-karicheri2@ti.com

>-----Original Message-----
>From: Daniel Glöckner [mailto:daniel-gl@gmx.net]
>Sent: Tuesday, June 23, 2009 3:11 PM
>To: Karicheri, Muralidharan
>Cc: linux-media@vger.kernel.org
>Subject: Re: sub devices sharing same i2c address
>
>On Tue, Jun 23, 2009 at 01:10:11PM -0500, Karicheri, Muralidharan wrote:
>> I am having to switch between two sub devices that shares the same i2c
>> address. First one is TVP5146 and the other is MT9T031. The second has
>> a i2c switch and the evm has a data path switch.
>
>You could try Rodolfo Giometti's i2c bus multiplexing code:
>http://i2c.wiki.kernel.org/index.php/I2C_bus_multiplexing
>
>It will create a new i2c_adapter for each output of the i2c switch
>and the switch is handled transparently when accessing the devices.
>
>  Daniel

