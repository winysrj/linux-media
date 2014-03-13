Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:55283 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbaCMNt3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 09:49:29 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N2D005E0NQFWS50@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 13 Mar 2014 09:49:27 -0400 (EDT)
Date: Thu, 13 Mar 2014 10:49:21 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH 1/3] e4000: convert DVB tuner to I2C driver model
Message-id: <20140313104921.683455ff@samsung.com>
In-reply-to: <CAGoCfiypLAQJWLpJp-SJ498NXcr35V_Y_EADONHggGwsc70r1g@mail.gmail.com>
References: <1390781812-20226-1-git-send-email-crope@iki.fi>
 <CAGoCfiyQ6-SA-5PYMgAv3Oq3gzcR-ReYCpL8Ak-KRVw0XHNd4Q@mail.gmail.com>
 <52E5AAAD.5050906@iki.fi>
 <CAOcJUbzN9dM-KnMEU3GooS183GPOSmoGyF5CGiX36ZBm7PqYZA@mail.gmail.com>
 <52E6DA4E.4020109@iki.fi>
 <CAGoCfiypLAQJWLpJp-SJ498NXcr35V_Y_EADONHggGwsc70r1g@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 27 Jan 2014 12:45:51 -0500
Michael Krufky <mkrufky@linuxtv.org> escreveu:

> Antti submitted similar patches a few months ago - I have to review
> his newer series and see if anything has changed.  My goal would be to
> commit these patches into a new branch and work on converting the
> entire tuner tree to the newer method, only merging to master once all
> is done and tested.

It passed almost two months without such review. I can't see any reason
to delay merging this patch, as the only device using this tuner should
work with the new approach.

Em Tue, 28 Jan 2014 08:41:40 -0500
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> Hi Antti,
> 
> > My biggest point was to criticize that general resistance of new design
> > models which has been DVB side, not only that simple change but many others
> > too. I am pretty sure the many "mistakes" are taken when there has not been
> > better alternative available at the time, and later was developed proper
> > solution, which is not still taken into use.
> 
> Sometimes the simplest looking changes can introduce all sorts of
> regressions.  Just look at the mess that was caused by Mauro's
> supposedly trivial "dynamic stack allocation" fixes as a prime
> example.
> 
> In principle I don't have any objection to adopting common frameworks.
>  That said, the changes you've proposed do deviate from how the
> framework currently works, and it might have been more constructive to
> post an RFC to the mailing list describing your proposed changes to
> the framework rather than just submitting a patch for a single tuner.

As far as I remember, Antti did it. There weren't many comments about
that.

> In this particular case, your approach does give us some advantages in
> being able to leverage the I2C framework, but it has costs as well.
> Specifically my concerns are as follows:
> 
> 1.  Removing the abstraction layer that dvb_attach() provided will
> make it more difficult to add resource tracking code to handle tuner
> locking/sharing.  To solve those problems would actually require us to
> later *reintroduce* a layer of abstraction between the bridge and
> tuner drivers if this patch were accepted as-is.

dvb_attach() is a dirty hack. It doesn't even take into account which
modules are using a DVB module - as can be seen when using lsmod.

All dvb_attach() does is to load a module when a non-existent symbol
is called.

Up to today, we have issues with that, as some Kconfig configurations
cause compilation failure on dibcom drivers (as, there, there are other
symbols other than attach that are needed for the bridge to properly
talk with the demod).

> Case in point - in the V4L2 layer, they actually went in the opposite
> direction - adding the V4L2 subdev framework in order to provide
> additional abstraction between the bridge and I2C devices.

Yes, but the subdev layer requires that drivers will first be a fully
compliant I2C module, in order to work.

We'll likely need a subdev layer on DVB side too in the future, in
order, for example, to solve the binding problems between dib0700
and the frontends, were there are some additional callbacks that are
needed for it to work properly.

> 2.  Your approach now makes it the responsibility of the caller to
> explicitly call request_module(), something that is taken care of
> today by dvb_attach().  Right now you can't forget to include the
> dependency since it's taken care of for you - with your change the
> implementor *can* forget, and the result will be that it will fail
> *sometimes* based on whether the module happens to already be loaded.
> In theory your approach would give us a bit more flexibility to have
> drivers with fewer module dependencies if people are compiling the
> kernel from scratch for a single tuner, but that's hardly the common
> use case and it significantly increases the risk of new bugs in
> failing to specify dependencies.

The same is true for V4L2 or hybrid drivers. The historic number of bugs
of people forgetting to add request_module() there was very small
because this is easily noticed during development phase, as, without
loading the module, the driver won't work properly.

> 3.  Your change gives no consideration to analog or hybrid tuners.
> This isn't surprising since you've never worked in that area, but if
> the model you are proposing is to be applied to all tuners, then we
> need to fully understand the effects on tuner-core.ko.

Good point. The first time we do such kind of conversion to a tuner
used by an hybrid driver, we'll need to address those issues.

> > I have also feeling that these wrong solutions and design models used are
> > one source of problems we have. All the chip I/Os should be modeled in a
> > standard manner to make sure it is possible to interconnect flexible. GPIOs
> > should be implemented as kernel GPIOs. I2C should be implemented as kernel
> > I2C. Clock should be implemented as a kernel clock. Chip power-management
> > should be implement as regulator (or what ever that is). TS interface also
> > should be modeled and implement in a standard manner. Implementing things
> > like that makes it possible to interconnect complex hardware without fearing
> > some small change will break functionality because of some home-brew
> > solution.
> 
> Sure.  Modular design practices are a good thing.  Thanks for stating
> the obvious.  Did they also teach you about how refactoring can
> introduce bugs, especially in instances where there are no unit tests
> and you cannot exercise all the possible code paths?  :-)

The e4000 tuner is used only on DVB and SDR realtek drivers, all
maintained by Antti.

I'm assuming that he tested that both keeps working after the changes.
In any case, if Antti broke something on his drivers, he should fix it.

> I am confident that after the above factors are considered/addressed
> that some variant of this patch can certainly be incorporated
> upstream, and I look forward to seeing the continued improvement of
> the codebase while not introducing new regressions.
> 
> Devin
> 

Regards,
Mauro
