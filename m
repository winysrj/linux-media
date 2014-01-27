Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59380 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717AbaA0WOr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jan 2014 17:14:47 -0500
Message-ID: <52E6DA4E.4020109@iki.fi>
Date: Tue, 28 Jan 2014 00:14:38 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jean Delvare <khali@linux-fr.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH 1/3] e4000: convert DVB tuner to I2C driver model
References: <1390781812-20226-1-git-send-email-crope@iki.fi>	<CAGoCfiyQ6-SA-5PYMgAv3Oq3gzcR-ReYCpL8Ak-KRVw0XHNd4Q@mail.gmail.com>	<52E5AAAD.5050906@iki.fi> <CAOcJUbzN9dM-KnMEU3GooS183GPOSmoGyF5CGiX36ZBm7PqYZA@mail.gmail.com>
In-Reply-To: <CAOcJUbzN9dM-KnMEU3GooS183GPOSmoGyF5CGiX36ZBm7PqYZA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27.01.2014 19:45, Michael Krufky wrote:
> On Sun, Jan 26, 2014 at 7:39 PM, Antti Palosaari <crope@iki.fi> wrote:
>> On 27.01.2014 02:28, Devin Heitmueller wrote:
>>>
>>> On Sun, Jan 26, 2014 at 7:16 PM, Antti Palosaari <crope@iki.fi> wrote:
>>>>
>>>> Driver conversion from proprietary DVB tuner model to more
>>>> general I2C driver model.
>>>
>>>
>>> Mike should definitely weigh in on this.  Eliminating the existing
>>> model of using dvb_attach() for tuners is something that needs to be
>>> considered carefully, and this course of action should be agreed on by
>>> the subsystem maintainers before we start converting drivers.  This
>>> could be particularly relevant for hybrid tuners where the driver
>>> instance is instantiated via tuner-core using dvb_attach() for the
>>> analog side.
>>>
>>> In the meantime, this change makes this driver work differently than
>>> every other tuner in the tree.
>>
>>
>> Heh, it is quite stupid to do things otherwise than rest of the kernel and
>> also I think it is against i2c documentation. For more we refuse to use
>> kernel standard practices the more there will be problems in a long ran.
>>
>> There is things that are build top of these standard models and if you are
>> using some proprietary method, then you are without these services. I think
>> it was regmap which I was looking once, but dropped it as it requires i2c
>> client.
>>
>> Also, I already implemented one tuner driver using standard I2C model. If
>> there will be problems then those are surely fixable.
>>
>> regards
>> Antti
>
> Devin is right-  I should have been cc'd on this.  Please remember to
> cc me on any DVB or tuner (both analog and digital) subsystem-level
> changes.
>
> What Devin probably doesn't realize, however, is that I have basically
> already agreed on this change -- this, overall, will be a very
> positive move for the media subsystem.  We just need to do it
> correctly, subsystem-wide.
>
> But just because this is a good idea, its no reason to call the
> current mechanism 'quite stupid' .. We're all working together here,
> let's not belittle the work that others have done in the past.  I'd
> rather just look forward and build a better codebase for the future
> :-)
>
> Antti submitted similar patches a few months ago - I have to review
> his newer series and see if anything has changed.  My goal would be to
> commit these patches into a new branch and work on converting the
> entire tuner tree to the newer method, only merging to master once all
> is done and tested.

My biggest point was to criticize that general resistance of new design 
models which has been DVB side, not only that simple change but many 
others too. I am pretty sure the many "mistakes" are taken when there 
has not been better alternative available at the time, and later was 
developed proper solution, which is not still taken into use.
I have also feeling that these wrong solutions and design models used 
are one source of problems we have. All the chip I/Os should be modeled 
in a standard manner to make sure it is possible to interconnect 
flexible. GPIOs should be implemented as kernel GPIOs. I2C should be 
implemented as kernel I2C. Clock should be implemented as a kernel 
clock. Chip power-management should be implement as regulator (or what 
ever that is). TS interface also should be modeled and implement in a 
standard manner. Implementing things like that makes it possible to 
interconnect complex hardware without fearing some small change will 
break functionality because of some home-brew solution.

regards
Antti

-- 
http://palosaari.fi/
