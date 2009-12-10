Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:52630 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758263AbZLJVPd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2009 16:15:33 -0500
Received: by fxm21 with SMTP id 21so362598fxm.1
        for <linux-media@vger.kernel.org>; Thu, 10 Dec 2009 13:15:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40155C80C7B@dlee06.ent.ti.com>
References: <A69FA2915331DC488A831521EAE36FE40155C809AB@dlee06.ent.ti.com>
	 <846899810912101139g6e8a36f7j78fa650e6629ad1b@mail.gmail.com>
	 <4B2156AA.80309@emlix.com>
	 <A69FA2915331DC488A831521EAE36FE40155C80C7B@dlee06.ent.ti.com>
Date: Thu, 10 Dec 2009 22:15:39 +0100
Message-ID: <846899810912101315o6e576ed8y150c93ea44cb0d66@mail.gmail.com>
Subject: Re: Latest stack that can be merged on top of linux-next tree
From: HoP <jpetrous@gmail.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Cc: =?ISO-8859-1?Q?Daniel_Gl=F6ckner?= <dg@emlix.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

2009/12/10 Karicheri, Muralidharan <m-karicheri2@ti.com>:
> Hi,
>
> Thanks for the email.
>
> Any idea how i2c drivers can work with this?
>
> Currently in my board, I have adapter id = 1 for main i2c bus. So when this mux driver is built into the kernel, I guess I can access it using a different adapter id, right? If so, what is the adapter id?

Yes, exactly that is way of using - additional i2c buses were born when pca954x
started.

Daniel already described this in his mail:

"With these patches the bus segments beyond the i2c multiplexer will be
registered as separate i2c busses. Access to a device on those busses
will then automatically reconfigure the multiplexer."

Additional i2c buses (adapters) were counted from number +1 higher
then highest i2c bus number. If you main i2c bus is i2c-1, then you
you should find i2c-2,i2c-3,i2c-4,i2c-5 new buses after pca954x loading.

You can check that with i2cdetect tools.

>
> How do I use this with MT9T031 driver? Any idea to share?
>

I never had a look inside mt9t031 driver, but in general - you simply
point to some of that additional adaper by i2c_get_adapter(x)

Idea is very smart. You don't need to manage pca954x on your own.
Driver do it itself :)

/Honza
