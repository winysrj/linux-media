Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34300 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257AbaA0AjO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jan 2014 19:39:14 -0500
Message-ID: <52E5AAAD.5050906@iki.fi>
Date: Mon, 27 Jan 2014 02:39:09 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Michael Krufky <mkrufky@linuxtv.org>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jean Delvare <khali@linux-fr.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH 1/3] e4000: convert DVB tuner to I2C driver model
References: <1390781812-20226-1-git-send-email-crope@iki.fi> <CAGoCfiyQ6-SA-5PYMgAv3Oq3gzcR-ReYCpL8Ak-KRVw0XHNd4Q@mail.gmail.com>
In-Reply-To: <CAGoCfiyQ6-SA-5PYMgAv3Oq3gzcR-ReYCpL8Ak-KRVw0XHNd4Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27.01.2014 02:28, Devin Heitmueller wrote:
> On Sun, Jan 26, 2014 at 7:16 PM, Antti Palosaari <crope@iki.fi> wrote:
>> Driver conversion from proprietary DVB tuner model to more
>> general I2C driver model.
>
> Mike should definitely weigh in on this.  Eliminating the existing
> model of using dvb_attach() for tuners is something that needs to be
> considered carefully, and this course of action should be agreed on by
> the subsystem maintainers before we start converting drivers.  This
> could be particularly relevant for hybrid tuners where the driver
> instance is instantiated via tuner-core using dvb_attach() for the
> analog side.
>
> In the meantime, this change makes this driver work differently than
> every other tuner in the tree.

Heh, it is quite stupid to do things otherwise than rest of the kernel 
and also I think it is against i2c documentation. For more we refuse to 
use kernel standard practices the more there will be problems in a long ran.

There is things that are build top of these standard models and if you 
are using some proprietary method, then you are without these services. 
I think it was regmap which I was looking once, but dropped it as it 
requires i2c client.

Also, I already implemented one tuner driver using standard I2C model. 
If there will be problems then those are surely fixable.

regards
Antti

-- 
http://palosaari.fi/
