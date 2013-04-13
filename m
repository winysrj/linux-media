Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58034 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379Ab3DMQWN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Apr 2013 12:22:13 -0400
Message-ID: <5169860B.80609@iki.fi>
Date: Sat, 13 Apr 2013 19:21:31 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/3] em28xx: clean up end extend the GPIO port handling
References: <1365846521-3127-1-git-send-email-fschaefer.oss@googlemail.com> <51695A7B.4010206@iki.fi> <20130413112517.40833d48@redhat.com> <51697A29.5030307@googlemail.com> <CAGoCfiwO+98ZkSt-mY6U3nnfge43xy+1WLEv=3wUf6SaDEgACQ@mail.gmail.com>
In-Reply-To: <CAGoCfiwO+98ZkSt-mY6U3nnfge43xy+1WLEv=3wUf6SaDEgACQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/13/2013 06:34 PM, Devin Heitmueller wrote:
> On Sat, Apr 13, 2013 at 11:30 AM, Frank Schäfer
> <fschaefer.oss@googlemail.com> wrote:
>> I've checked the documentation about the gpio and led frameworks a few
>> weeks ago to find out if it makes sense to use them for the
>> gpio/buttons/led stuff of the VAD Laplace webcam.
>> AFAICS, there are no benfits as long as you are dealing with these
>> things internally. It just increases the code size and adds an
>> additional dependency in this case.
>> Of course, the situation is different when there is an interaction with
>> other modules or userspace. In that case using gpiolib could make sense.
>> I don't know which case applies to the LAN stuff, but for the
>> buttons/leds it's the first case.
>
> IMHO, it would be a bad idea to expose the actual GPIOs to userspace.
> Improperly setting the GPIOs can cause damage to the board, and all of
> the functionality that the GPIOs control are exposed through other
> much better supported interfaces.  It's a nice debug feature for
> driver developers who want to hack at the driver, but you really don't
> want any situation where end users or applications are making direct
> use of the GPIOs.

Existing userspace sysfs interface is clearly debug interface. You will 
need root privileges to mount it and IIRC it was not even compiled by 
default (needs Kconfig debug option?).

regards
Antti

-- 
http://palosaari.fi/
