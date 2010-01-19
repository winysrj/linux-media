Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:65483 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab0ASNqB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2010 08:46:01 -0500
Received: by ewy19 with SMTP id 19so1734492ewy.21
        for <linux-media@vger.kernel.org>; Tue, 19 Jan 2010 05:46:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <8f772b00c9ad2033899eeb1913ee42e0@mail.velocitynet.com.au>
References: <3bf14d196e3bc8717d910d09a623f98e@mail.velocitynet.com.au>
	 <fded4e7b5651846ee885157dff27bf5c@mail.velocitynet.com.au>
	 <8d15809584306ed08401d6b06dccfcaf@mail.velocitynet.com.au>
	 <8f772b00c9ad2033899eeb1913ee42e0@mail.velocitynet.com.au>
Date: Tue, 19 Jan 2010 15:45:56 +0200
Message-ID: <4583ac0f1001190545tcd3f826q78e2a94392cfa43@mail.gmail.com>
Subject: Re: DM1105: could not attach frontend 195d:1105
From: "Igor M. liplianin" <liplianin@me.by>
To: paul10@planar.id.au
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2010/1/19  <paul10@planar.id.au>:
>> Well, as I understood, GPIO15 drives reset for demod.
>> dm1105 driver needs little patching.
>>
>>
>
> Igor,
>
> Not to hassle you, I'm sure you're very busy.  Is this something I could
> undertake myself?  If so, which driver would you recommend I copy from - I
> saw on the list that some drivers do their own GPIO management, and others
> use a generic GPIO layer.  I presume we'd need to use the generic layer?
>
> Also, from your explanation it sounds like we need to set GPIO 15 to true
> before we attempt to attach.  Is that correct?  From my reading there are
> two GPIO registers (8 bits each), so we'd be bit masking bit 7 in the
> second GPIO register to 1, then sending that GPIO to the card?
>
> Thanks for any tips,
>
> Paul
>
>
>
As you can see there is two 32-bit registers. First for values, second
for controls. Control means 0 for output and 1 for input.
If I remember it is 17 GPIO lines only.

/* GPIO Interface */
#define DM1105_GPIOVAL				0x08
#define DM1105_GPIOCTR				0x0c


BR

Igor
