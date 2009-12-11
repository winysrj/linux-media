Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:45584 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756483AbZLKWcz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2009 17:32:55 -0500
Received: by fxm21 with SMTP id 21so1547112fxm.1
        for <linux-media@vger.kernel.org>; Fri, 11 Dec 2009 14:32:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40155CEE312@dlee06.ent.ti.com>
References: <A69FA2915331DC488A831521EAE36FE40155C809AB@dlee06.ent.ti.com>
	 <846899810912101139g6e8a36f7j78fa650e6629ad1b@mail.gmail.com>
	 <4B2156AA.80309@emlix.com>
	 <A69FA2915331DC488A831521EAE36FE40155C80C7B@dlee06.ent.ti.com>
	 <846899810912101315o6e576ed8y150c93ea44cb0d66@mail.gmail.com>
	 <A69FA2915331DC488A831521EAE36FE40155CEE312@dlee06.ent.ti.com>
Date: Fri, 11 Dec 2009 23:32:58 +0100
Message-ID: <846899810912111432p2e3d5423v63b8460ad3e921b7@mail.gmail.com>
Subject: Re: Latest stack that can be merged on top of linux-next tree
From: HoP <jpetrous@gmail.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Cc: =?ISO-8859-1?Q?Daniel_Gl=F6ckner?= <dg@emlix.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

2009/12/11 Karicheri, Muralidharan <m-karicheri2@ti.com>:
> Hi,
>
> Thanks for the response. One more question that I have is if
> the devices on the two buses can use the same i2c address.
> That is the case for my board. So wondering if this works as
> well.
>

That is IMHO exactly reason of existence such "expanders".
We, for example have two DVB-S2 tuners, using totally
same i2c addresses (for demod & pll).

If you are carefull and access such devices only using
those virtual i2c buses, then you not need to manage
switching between them at all. It is job for pca954x
driver. Simple and easy :)

/Honza
