Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54188 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab0ISM3N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Sep 2010 08:29:13 -0400
Received: by bwz11 with SMTP id 11so3730621bwz.19
        for <linux-media@vger.kernel.org>; Sun, 19 Sep 2010 05:29:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C954C51.8080801@iki.fi>
References: <AANLkTinTvXKrWKqukCj9MWw0Me3K5y2yDHMUP4eMpaN3@mail.gmail.com>
	<4C954C51.8080801@iki.fi>
Date: Sun, 19 Sep 2010 14:29:11 +0200
Message-ID: <AANLkTi=+XOMAPgQz46egRCm0eHATSBo3vO5EjKJ_SrA4@mail.gmail.com>
Subject: Re: dvb-c usb device
From: Markus Rechberger <mrechberger@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Bert Haverkamp <bert@bertenselena.net>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, Sep 19, 2010 at 1:33 AM, Antti Palosaari <crope@iki.fi> wrote:
> On 09/18/2010 09:23 PM, Bert Haverkamp wrote:
>>
>> Every couple of months I scan this mailing list for the keywords usb
>> and dvb-c, hoping that some new device has shown up that is supported
>
> Currently there is Anysee E30C Plus and Technotrend CT-3650. About
> Technotrend I am not 100% sure, but I have seen patch for adding DVB-C
> support for that device. There is many DRX-K devices, but no drivers yet.
> Also there is TDA10024 based "Reddo" available in Finland, but I haven't
> looked it. Thus only reliable one is Anysee.
>

the biggest problem with Linux and DVB-C is getting HDTV work.

1. Nearly no distribution comes with codecs (and those who come are
doing it in a not legal way - there are some)
2. Compiling fails for the masses (we've got exactly 3 opensource
requests within 1 year).
3. graphiccard drivers are a mess (NVidia is doing the best job in
getting their graphiccards work).

We've been in contact with Trident for more than a year now they even
visited our customers
in order to help to improve the DVB-C quality of their solution.

The main problem lies with earning revenue.
If the chip manufacturer releases opensource drivers, all the product
manufacturers will release the same which basically
means there's no advantage for anyone anymore and this finally will
lead to a pricefighting situation.
The price will go down enough that it doesn't make any sense anymore
to sell the product - definitely go down
enough to not spend any money in R&D for software.
What can a product manufacturer do to improve this? nothing.
And ultimately it will go back to the chip manufacturer because it's
not worth for several companies to sell those products.

We can just pick an example, Terratec. They used to offer Linux
drivers. Finally they laid off all their software engineers.
There's a company starting with P. which is now with a company which
starts with H. offering 500 EUR/half year for Linux
drivers.

Since it's possible to drive those ICs from userspace the failure lies
in the structure of this entire linux multimedia project,
not being flexible enough for product manufacturers that's why we
redeveloped everything and see it works.
Those people who are into Linux use to scream loud but use to forget
about the average people who are relevant for
Manufacturers.

I would recommend a situation where mainly the bridge datatransfer is
in kernelspace configurable from userspace (we also
have a kernel opensource bridge driver especially for embedded systems).
The advantage of this is

a. tuner configuration can be added in a flexible way from userspace
at any time, providing backward compatibility to
older kernels
b. compiling drivers is no option for normal endusers.
c. improved stability, since all the complex code is in userspace, the
tuner/demod/etc configuration does not depend
on speed either.
d. bigger userbase, better testing since everyone at any time should
be able to use the latest chipconfiguration package
from userspace.
e. manufacturers would have an easier possibility to provide support
for their devices.

sure this way is new but that's the way we went during the last 2
years and we pretty much succeeded in the linux
area with that. After all it's only about providing good multimedia
support to the enduser.

Best Regards,
Markus
