Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:40066 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552AbbBYTC1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2015 14:02:27 -0500
Date: Wed, 25 Feb 2015 16:02:21 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] xc5000: fix memory corruption when unplugging device
Message-ID: <20150225160221.2db06c12@recife.lan>
In-Reply-To: <CAGoCfiyDP9LM7aFGE1+doOPu=A_+1ryKuKiM9aLGUw6PjkB42Q@mail.gmail.com>
References: <1424798958-2819-1-git-send-email-dheitmueller@kernellabs.com>
	<54EDD761.6060900@osg.samsung.com>
	<CAGoCfiyN_iQ6vGn0YGUD_OxngwKEMs056Gzp4yW9wWjSa8Lisw@mail.gmail.com>
	<54EE10DD.9020205@iki.fi>
	<CAGoCfiyDP9LM7aFGE1+doOPu=A_+1ryKuKiM9aLGUw6PjkB42Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 25 Feb 2015 13:37:07 -0500
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> > These are just the issues I would like to implement drivers as standard I2C
> > driver model =) Attaching driver for one chip twice is ugly hack!
> 
> While I'm not arguing the merits of using the standard I2C driver
> model, it won't actually help in this case since we would still need a
> structure representing shared state accessible by both the DVB and
> V4L2 subsystems.  And that struct will need to be referenced counted,
> which is exactly what hybrid_tuner_request_state() does.
...
> If you ever get around to implementing support for a hybrid device
> (where you actually have to worry about how both digital and analog
> share a single tuner), you'll appreciate some of these challenges and
> why what was done was not as bad/crazy as you might think.

The I2C model that Antti is proposing may work, but, for that,
we'll very likely need to re-write the tuner core.

Currently, the binding model is:

for analog:

	tuner driver -> tuner-core module <==> V4L2 driver

The interface between V4L2 driver and tuner core is the I2C high
level API.

for digital

	tuner driver <==> DVB driver

The interface between the tuner driver and the DVB driver is the
I2C low level API.

Antti's proposal makes the DVB driver to use the high level I2C API,
with makes the DVB driver a little closer to what V4L2 does.

Yet, for V4L2, the tuner-core module is required.

The binding code at the tuner-core is very complex, as it needs to
talk both V4L2 and DVB "dialogs". This should be simplified.

In other words, If we want to use the same model for all tuners, 
we'll need to rewrite the binding schema to avoid the need of a 
tuner core module, or to replace it by something better/simpler.

For locking the tuner between analog/digital usage, the best
approach seems to be to use the media controller.

Regards,
Mauro
