Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KqAxi-0007HR-Kz
	for linux-dvb@linuxtv.org; Wed, 15 Oct 2008 20:19:12 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta2.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K8S00CE8LIYDDI0@mta2.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Wed, 15 Oct 2008 14:18:35 -0400 (EDT)
Date: Wed, 15 Oct 2008 14:18:34 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <412bdbff0810150740h61049f5fvb679bdebbcd4084d@mail.gmail.com>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Message-id: <48F633FA.4000106@linuxtv.org>
MIME-version: 1.0
References: <412bdbff0810150724h2ab46767ib7cfa52e3fdbc5fa@mail.gmail.com>
	<48F5FE80.5010106@linuxtv.org>
	<412bdbff0810150740h61049f5fvb679bdebbcd4084d@mail.gmail.com>
Cc: Linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Revisiting the SNR/Strength issue
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Devin Heitmueller wrote:
> On Wed, Oct 15, 2008 at 10:30 AM, Steven Toth <stoth@linuxtv.org> wrote:
>> The SNR units should be standardized into a single metric, something
>> actually useful like ESNO or db. If that isn't available then we should aim
>> to eyeball / manually calibrate impossible boards against known reliable
>> demods on the same feed, it should be close enough.
>>
>> This requires patience and time from the right people with the right
>> hardware.
> 
> I agree that standardizing on a particular unit would be the ideal
> scenario.  Realistically though, do you have any confidence that this
> would actually happen?  Many frontends would have to change, reverse

It will happen when someone cares enough to do it, that's the Linux mantra.

Let's quantify this. How many frontends would have to change?

> engineering would have to be done, and in many cases without a signal
> generator this would be very difficult.  This could take months or
> years, or might never happen.

You don't need a signal generator, you _do_ need a comparison product 
that is reliably reporting db.

> 
> Certainly I'm in favor of expressing that there is a preferred unit
> that new frontends should use (whether that be ESNO or db), but the
> solution I'm suggesting would allow the field to become useful *now*.
> This would hold us over until all the other frontends are converted to
> db (which I have doubts will ever actually happen).

I'm not in favour of this.

I'd rather see a single unit of measure agreed up, and each respective 
maintainer go back and perform the necessary code changes. I'm speaking 
as a developer of eight (?) different demod drivers in the kernel. 
That's no small task, but I'd happily conform if I could.

Lastly, for the sake of this discussion, assuming that db is agreed 
upon, if the driver cannot successfully delivery SNR in terms of db then 
  the bogus function returning junk should be removed.

Those two changes alone would be a better long term approach, I think.

- Steve


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
