Return-path: <mchehab@localhost>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:56435 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056Ab1GFT7Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2011 15:59:24 -0400
Message-ID: <4E14BE93.2030205@kolumbus.fi>
Date: Wed, 06 Jul 2011 22:59:15 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Andy Walls <awalls@md.metrocast.net>,
	linux-media@vger.kernel.org
Subject: Re: [RFCv2 PATCH 0/5] tuner-core: fix s_std and s_tuner
References: <1307804731-16430-1-git-send-email-hverkuil@xs4all.nl>	<201106152237.02427.hverkuil@xs4all.nl>	<BANLkTimVQDoHo+5-2ZkU0sE0LWiUjHeBXg@mail.gmail.com>	<201106160821.15352.hverkuil@xs4all.nl>	<4DF9E5AB.1050707@redhat.com>	<BANLkTi=Wq=swMMBfK+X9gVQ0XhL4OSxXFA@mail.gmail.com>	<4E14A127.8040805@kolumbus.fi> <CAGoCfiwjXYBR8FBYMS8BsBM20mCQLvWQbyhLh-psA_HX73SGjw@mail.gmail.com>
In-Reply-To: <CAGoCfiwjXYBR8FBYMS8BsBM20mCQLvWQbyhLh-psA_HX73SGjw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

06.07.2011 21:17, Devin Heitmueller kirjoitti:
> On Wed, Jul 6, 2011 at 1:53 PM, Marko Ristola <marko.ristola@kolumbus.fi> wrote:
>>
> 
> All that said, I believe that you are correct in that the business
> logic needs to ultimately be decided by the bridge driver, rather than
> having the dvb/tuner core blindly calling the sleep routines against
> the tuner and demod drivers without a full understanding of what
> impact it has on the board as a whole.

You wrote it nicely and compactly.

What do you think about tracking coarse last busy time rather than figuring out accurate idle time?

dvb_frontend.c and V4L side would just poll the device:
"bridge->wake()". wake() will just store current "busy" timestamp to the bridge device
with coarse accuracy, if subdevices are already at active state.
If subdevices are powered off, it will first power them on and resume them, and then store "busy" timestamp.

Bridge device would have a "delayed task": "Check after 3 minutes: If I haven't been busy
for three minutes, I'll go to sleep. I'll suspend the subdevices and power them off."

The "delayed task" would refresh itself: check again after last awake time + 3 minutes.

"Delayed task" could be further developed to support multiple suspend states.

> 
> Cheers,
> 
> Devin
> 


Marko
