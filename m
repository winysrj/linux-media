Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f41.google.com ([209.85.212.41]:38208 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445AbaA1Nll (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jan 2014 08:41:41 -0500
Received: by mail-vb0-f41.google.com with SMTP id g10so246550vbg.0
        for <linux-media@vger.kernel.org>; Tue, 28 Jan 2014 05:41:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52E6DA4E.4020109@iki.fi>
References: <1390781812-20226-1-git-send-email-crope@iki.fi>
	<CAGoCfiyQ6-SA-5PYMgAv3Oq3gzcR-ReYCpL8Ak-KRVw0XHNd4Q@mail.gmail.com>
	<52E5AAAD.5050906@iki.fi>
	<CAOcJUbzN9dM-KnMEU3GooS183GPOSmoGyF5CGiX36ZBm7PqYZA@mail.gmail.com>
	<52E6DA4E.4020109@iki.fi>
Date: Tue, 28 Jan 2014 08:41:40 -0500
Message-ID: <CAGoCfiypLAQJWLpJp-SJ498NXcr35V_Y_EADONHggGwsc70r1g@mail.gmail.com>
Subject: Re: [PATCH 1/3] e4000: convert DVB tuner to I2C driver model
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Michael Krufky <mkrufky@linuxtv.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jean Delvare <khali@linux-fr.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

> My biggest point was to criticize that general resistance of new design
> models which has been DVB side, not only that simple change but many others
> too. I am pretty sure the many "mistakes" are taken when there has not been
> better alternative available at the time, and later was developed proper
> solution, which is not still taken into use.

Sometimes the simplest looking changes can introduce all sorts of
regressions.  Just look at the mess that was caused by Mauro's
supposedly trivial "dynamic stack allocation" fixes as a prime
example.

In principle I don't have any objection to adopting common frameworks.
 That said, the changes you've proposed do deviate from how the
framework currently works, and it might have been more constructive to
post an RFC to the mailing list describing your proposed changes to
the framework rather than just submitting a patch for a single tuner.

In this particular case, your approach does give us some advantages in
being able to leverage the I2C framework, but it has costs as well.
Specifically my concerns are as follows:

1.  Removing the abstraction layer that dvb_attach() provided will
make it more difficult to add resource tracking code to handle tuner
locking/sharing.  To solve those problems would actually require us to
later *reintroduce* a layer of abstraction between the bridge and
tuner drivers if this patch were accepted as-is.

Case in point - in the V4L2 layer, they actually went in the opposite
direction - adding the V4L2 subdev framework in order to provide
additional abstraction between the bridge and I2C devices.

2.  Your approach now makes it the responsibility of the caller to
explicitly call request_module(), something that is taken care of
today by dvb_attach().  Right now you can't forget to include the
dependency since it's taken care of for you - with your change the
implementor *can* forget, and the result will be that it will fail
*sometimes* based on whether the module happens to already be loaded.
In theory your approach would give us a bit more flexibility to have
drivers with fewer module dependencies if people are compiling the
kernel from scratch for a single tuner, but that's hardly the common
use case and it significantly increases the risk of new bugs in
failing to specify dependencies.

3.  Your change gives no consideration to analog or hybrid tuners.
This isn't surprising since you've never worked in that area, but if
the model you are proposing is to be applied to all tuners, then we
need to fully understand the effects on tuner-core.ko.

> I have also feeling that these wrong solutions and design models used are
> one source of problems we have. All the chip I/Os should be modeled in a
> standard manner to make sure it is possible to interconnect flexible. GPIOs
> should be implemented as kernel GPIOs. I2C should be implemented as kernel
> I2C. Clock should be implemented as a kernel clock. Chip power-management
> should be implement as regulator (or what ever that is). TS interface also
> should be modeled and implement in a standard manner. Implementing things
> like that makes it possible to interconnect complex hardware without fearing
> some small change will break functionality because of some home-brew
> solution.

Sure.  Modular design practices are a good thing.  Thanks for stating
the obvious.  Did they also teach you about how refactoring can
introduce bugs, especially in instances where there are no unit tests
and you cannot exercise all the possible code paths?  :-)

I am confident that after the above factors are considered/addressed
that some variant of this patch can certainly be incorporated
upstream, and I look forward to seeing the continued improvement of
the codebase while not introducing new regressions.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
