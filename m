Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f178.google.com ([209.85.218.178]:38465 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbZCEWF0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 17:05:26 -0500
MIME-Version: 1.0
In-Reply-To: <96DA7A230D3B2F42BA3EF203A7A1B3B5012EAC2043@dlee07.ent.ti.com>
References: <5e9665e10903041858j7d2177abjfa1193532553059c@mail.gmail.com>
	 <96DA7A230D3B2F42BA3EF203A7A1B3B5012EAC2043@dlee07.ent.ti.com>
Date: Fri, 6 Mar 2009 01:05:23 +0300
Message-ID: <208cbae30903051405p7588b3a9pb17338ec99dc749a@mail.gmail.com>
Subject: Re: [PATCH 4/5] OMAP3430SDP: Add support for Camera Kit v3
From: Alexey Klimov <klimov.linux@gmail.com>
To: "Curran, Dominic" <dcurran@ti.com>
Cc: "DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
	MiaoStanley <stanleymiao@hotmail.com>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Lakhani, Amish" <amish@ti.com>, "Menon, Nishanth" <nm@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, all

On Thu, Mar 5, 2009 at 7:42 PM, Curran, Dominic <dcurran@ti.com> wrote:
>
> Hi Kim
>
>> -----Original Message-----
>> From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
>> owner@vger.kernel.org] On Behalf Of DongSoo(Nathaniel) Kim
>> Sent: Wednesday, March 04, 2009 8:58 PM
>> To: Aguirre Rodriguez, Sergio Alberto
>> Cc: linux-media@vger.kernel.org; linux-omap@vger.kernel.org; Sakari Ailus;
>> Tuukka.O Toivonen; Hiroshi DOYU; MiaoStanley; Nagalla, Hari; Hiremath,
>> Vaibhav; Lakhani, Amish; Menon, Nishanth
>> Subject: Re: [PATCH 4/5] OMAP3430SDP: Add support for Camera Kit v3
>>
>> Hi Sergio,
>>
>>
>>
>> On Wed, Mar 4, 2009 at 5:44 AM, Aguirre Rodriguez, Sergio Alberto
>> <saaguirre@ti.com> wrote:
>> > +               /* turn on analog power */
>> > +               twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
>> > +                               VAUX_2_8_V, TWL4030_VAUX2_DEDICATED);
>> > +               twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
>> > +                               VAUX_DEV_GRP_P1, TWL4030_VAUX2_DEV_GRP);
>> > +
>> > +               /* out of standby */
>> > +               gpio_set_value(MT9P012_STANDBY_GPIO, 0);
>> > +               udelay(1000);
>>
>> It seems better using msleep rather than udelay for 1000us much. Just
>> to be safe :)
>> How about you?
>>
>
> Why is msleep safer than udelay ?

I have small guess that he is wondering why you are using big delays
with help of udelay(). (It's may be obvious but as we know udelay uses
cpu loops to make delay and msleep calls to scheduler) So, msleep is
more flexible and "softer" but if you need precise time or you can't
sleep in code you need udelay. Sometimes using udelay is reasonably
required.

-- 
Best regards, Klimov Alexey
