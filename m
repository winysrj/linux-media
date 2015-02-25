Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:35988 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbbBYShI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2015 13:37:08 -0500
Received: by mail-qa0-f46.google.com with SMTP id n4so4105316qaq.5
        for <linux-media@vger.kernel.org>; Wed, 25 Feb 2015 10:37:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54EE10DD.9020205@iki.fi>
References: <1424798958-2819-1-git-send-email-dheitmueller@kernellabs.com>
	<54EDD761.6060900@osg.samsung.com>
	<CAGoCfiyN_iQ6vGn0YGUD_OxngwKEMs056Gzp4yW9wWjSa8Lisw@mail.gmail.com>
	<54EE10DD.9020205@iki.fi>
Date: Wed, 25 Feb 2015 13:37:07 -0500
Message-ID: <CAGoCfiyDP9LM7aFGE1+doOPu=A_+1ryKuKiM9aLGUw6PjkB42Q@mail.gmail.com>
Subject: Re: [PATCH] xc5000: fix memory corruption when unplugging device
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
	"mauro Carvalho Chehab (m.chehab@samsung.com)" <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> These are just the issues I would like to implement drivers as standard I2C
> driver model =) Attaching driver for one chip twice is ugly hack!

While I'm not arguing the merits of using the standard I2C driver
model, it won't actually help in this case since we would still need a
structure representing shared state accessible by both the DVB and
V4L2 subsystems.  And that struct will need to be referenced counted,
which is exactly what hybrid_tuner_request_state() does.

In short, what you're proposing doesn't have any relevance to this
case - it just moves the problem to some other mechanism for sharing
private state between two drivers and having to reference count it.
And at least in this case it's done the same way for all the tuner
drivers (as opposed to different tuners re-inventing their own
mechanism for sharing state between the different consumers).

If you ever get around to implementing support for a hybrid device
(where you actually have to worry about how both digital and analog
share a single tuner), you'll appreciate some of these challenges and
why what was done was not as bad/crazy as you might think.

If anything, this little regression is yet another point of evidence
that innocent refactoring and "cleanup" of existing code without
really understanding what it does and/or performing significant
testing can leave everybody worse off than if the well-intentioned
committer had done nothing at all.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
