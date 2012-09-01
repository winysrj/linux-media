Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:32881 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab2IAQ0O (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Sep 2012 12:26:14 -0400
Received: by iahk25 with SMTP id k25so2628137iah.19
        for <linux-media@vger.kernel.org>; Sat, 01 Sep 2012 09:26:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50423436.9040708@iki.fi>
References: <20120731222216.GA36603@triton8.kn-bremen.de>
	<502711BE.4020701@redhat.com>
	<50422EFA.5000606@gmail.com>
	<50423436.9040708@iki.fi>
Date: Sat, 1 Sep 2012 12:26:13 -0400
Message-ID: <CAGoCfiy=nbL1MvLZmiRG0JZe+69VBjPNur8R64pcoL0f3Y7Q_A@mail.gmail.com>
Subject: Re: Fwd: [PATCH, RFC] Fix DVB ioctls failing if frontend open/closed
 too fast
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: poma <pomidorabelisima@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Juergen Lock <nox@jelal.kn-bremen.de>, hselasky@c2i.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Sep 1, 2012 at 12:13 PM, Antti Palosaari <crope@iki.fi> wrote:
> Is there anyone caring to review that carefully?
>
> I am quite out with semaphores (up/down_interruptible) and also frontend is
> so complex... I would rather design / write whole dvb-frontend from the
> scratch :] (not doing that as no time).

If you're not willing to take the time to understand why the existing
dvb-frontend is so complex, how could you possibly suggest that you
could do a better job rewriting it from scratch?  :-)

Like most things, the devil is in the details.  The threading model is
complicated not because it was done poorly, but because there are lots
of complexity that is not obvious (combined with it having evolved
over time to adapt to hardware bugs).  It's only when you run it
against a half dozen cards with different behavior that you begin to
see why certain things were done the way they were.

In this case, I think the race condition in question has become more
obvious because of more aggressive use of power management for the
tuner and demod.  Because powering down the frontend now takes actual
time (due to i2c), users are now starting to hit the race condition.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
