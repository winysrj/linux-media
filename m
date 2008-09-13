Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KebmZ-00061M-2M
	for linux-dvb@linuxtv.org; Sat, 13 Sep 2008 22:31:54 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta2.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K75003N7IC4U1F0@mta2.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Sat, 13 Sep 2008 16:31:16 -0400 (EDT)
Date: Sat, 13 Sep 2008 16:31:16 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <48CB5D7A.3040403@singlespoon.org.au>
To: Paul Chubb <paulc@singlespoon.org.au>
Message-id: <48CC2314.4090800@linuxtv.org>
MIME-version: 1.0
References: <48CB5D7A.3040403@singlespoon.org.au>
Cc: linux dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] why opensource will fail
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

Paul Chubb wrote:
> Hi,
>      now that I have your attention:-{)=

.... You've also had my attention in the past, if I recall I have you 
tips about not using cx_write, instead using cx_set/cx_clear.

Your latest patch still doesn't have those changes btw. ;)


> 
> I believe that this community has a real problem. There appears to be 
> little willingness to help and mentor newcomers. This will limit the 
> effectiveness of the community because it will hinder expansion of 
> people who are both willing and able to work on the code. Eventually 
> this issue  will lead to the community dying simply because you have 
> people leaving but few joining.

I disagree with everything you've just said, but that's just my opinion.


> 
> The card I was working on has been around for  a while now. There have 
> been three attempts so far to get it working with Linux. Two in this 
> community and one against the mcentral.de tree. Both attempts in this 
> community have failed not because of a lack of willingness of the people 
> involved to do the hard yards but because of the inability of the 
> community to mentor and help newcomers.


Did I not try to help you? The one piece of initial feedback I gave you, 
you ignored. (see my opening statement).

I'm always willing to help people, but they also have to demonstrate 
that they are applying themselves, doing basic research, asking specific 
questions ... rather than, here's my patch - and What's Wrong with it.


> 
> The third attempt by a Czech programmer succeeded, however it is 
> dependent on the mcentral.de tree and the author appears to have made no 
> attempt to get the patch into the tree. The original instructions to 
> produce a driver set are in Czech. However instructions in english for 
> 2.6.22 are available - ubuntu gutsy. I will soon be putting up 
> instructions for 2.6.24 - hardy. They may even work  for later revisions 
> since the big issue was incompatible versioning.
> 
> I understand from recent posts to this list that many in the community 
> are disturbed by the existence of mcentral.de. Well every person from 
> now on who wants to run the Leadtek Winfast DTV1800H will be using that 
> tree. Since the card is excellent value for what it is, there should be 
> lots of them. Not helping newcomers who are trying to add cards has led 
> and will lead to increased fragmentation.

So port the mcentral.de details into the kernel, I doubt they'll be 
significantly different.... we're talking about adding support for an 
existing card, it's not a lot of engineering work.


> 
> And before you say or think that we are all volunteers here, I am a 
> volunteer also. I have spent close to 3 weeks on this code and it is 
> very close to working. The biggest difference between working code in 
> the mcentral.de tree and the patch I was working on is the firmware that 
> is used.

... and your efforts are valuable.

Markus (mcentral.de) is paid to work on Linux, just to be clear.

Your last message on that thread said: "xc2028 2-0061: xc2028/3028 
firmware name not set!"

You could of asked a second time before taking the opportunity to vent, 
and taking the community to task.

Showing patience and perseverance is what most other newcomers demonstrate.


> 
> Finally you might consider that if few developers are prepared to work 
> on the v4l-dvb tree, then much of the fun will disappear because those 
> few will have to do everything.

Whether we have 3 people or 30, it's never enough.

In my experience, people who join the list then vent all over it are 
rarely around long enough to make a difference. They often think they 
know more about the community than the community itself.

On the other hand, the people who join and ask well thought out 
questions, describe their failures and working assumptions, then 
demonstrate a willingness to learn attract a mentor very quickly.

... just my opinion of course :)

If you want to make progress with the leadtek card then another look at 
the feedback I gave you, then approach the group again with a more 
insightful email.

Maybe someone will help you then.

- Steve



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
