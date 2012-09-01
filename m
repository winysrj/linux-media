Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56587 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab2IAQjD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Sep 2012 12:39:03 -0400
Message-ID: <50423A14.6090306@iki.fi>
Date: Sat, 01 Sep 2012 19:38:44 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: poma <pomidorabelisima@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Juergen Lock <nox@jelal.kn-bremen.de>, hselasky@c2i.net
Subject: Re: Fwd: [PATCH, RFC] Fix DVB ioctls failing if frontend open/closed
 too fast
References: <20120731222216.GA36603@triton8.kn-bremen.de> <502711BE.4020701@redhat.com> <50422EFA.5000606@gmail.com> <50423436.9040708@iki.fi> <CAGoCfiy=nbL1MvLZmiRG0JZe+69VBjPNur8R64pcoL0f3Y7Q_A@mail.gmail.com>
In-Reply-To: <CAGoCfiy=nbL1MvLZmiRG0JZe+69VBjPNur8R64pcoL0f3Y7Q_A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/01/2012 07:26 PM, Devin Heitmueller wrote:
> On Sat, Sep 1, 2012 at 12:13 PM, Antti Palosaari <crope@iki.fi> wrote:
>> Is there anyone caring to review that carefully?
>>
>> I am quite out with semaphores (up/down_interruptible) and also frontend is
>> so complex... I would rather design / write whole dvb-frontend from the
>> scratch :] (not doing that as no time).
>
> If you're not willing to take the time to understand why the existing
> dvb-frontend is so complex, how could you possibly suggest that you
> could do a better job rewriting it from scratch?  :-)

Writing and designing things from the scratch is more motivated that 
trying to learn this much complex stuff. You surely know I has a kinda 
understanding with current dvb-frontend but I hate there is so much 
hacks which makes it even worse. Writing from the scratch means you 
could get rid of hacks - slowly.

See all the module parameters and think twice are those really needed? 
Also re-initialization stuff and what more. Unfortunately those are 
allowed at some phase as easy solution and now it is impossible to get 
rid. Hacks which belongs to individual drivers instead of core.

> Like most things, the devil is in the details.  The threading model is
> complicated not because it was done poorly, but because there are lots
> of complexity that is not obvious (combined with it having evolved
> over time to adapt to hardware bugs).  It's only when you run it
> against a half dozen cards with different behavior that you begin to
> see why certain things were done the way they were.
>
> In this case, I think the race condition in question has become more
> obvious because of more aggressive use of power management for the
> tuner and demod.  Because powering down the frontend now takes actual
> time (due to i2c), users are now starting to hit the race condition.
>
> Devin
>

regards
Antti


-- 
http://palosaari.fi/
