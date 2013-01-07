Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:41279 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506Ab3AGMsu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Jan 2013 07:48:50 -0500
Message-ID: <50EAC41D.4040403@schinagl.nl>
Date: Mon, 07 Jan 2013 13:48:29 +0100
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>, pfister@linuxtv.org,
	adq_dvb@lidskialf.net, js@linuxtv.org, cus@fazekas.hu,
	mws@linuxtv.org, jmccrohan@gmail.com, shaulkr@gmail.com,
	mkrufky@linuxtv.org, mchehab@redhat.com, lubomir.carik@gmail.com,
	Christoph Pfister <christophpfister@gmail.com>
Subject: Re: [RFC] Initial scan files troubles and brainstorming
References: <507FE752.6010409@schinagl.nl> <50D0E7A7.90002@schinagl.nl> <50EAA778.6000307@gmail.com>
In-Reply-To: <50EAA778.6000307@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07-01-13 11:46, Jiri Slaby wrote:
> On 12/18/2012 11:01 PM, Oliver Schinagl wrote:
>> Unfortunatly, I have had zero replies.
> Hmm, it's sad there is a silence in this thread from linux-media guys :/.
In their defense, they are very very busy people ;) chatter on this 
thread does bring it up however.
>
>> So why bring it up again? On 2012/11/30 Jakub Kasprzycki provided us
>> with updated polish DVB-T frequencies for his region. This has yet to be
>> merged, almost 3 weeks later.
> I sent a patch for cz data too:
> https://patchwork.kernel.org/patch/1844201/
I see that patch lives on the kernel patchwork not the linuxtv one. Did 
it pass this ML? I have applied it to my tree for now.
>
>> I'll quickly repeat why I think this approach would be quite reasonable.
>>
>> * dvb-apps binary changes don't result in unnecessary releases
>> * frequency updates don't result in unnecessary dvb-app releases
>> * Less strict requirements for commits (code reviews etc)
> Well the code should be reviewed still. See commit a2e96055db297 in your
> repo, it's bogus. The freq added is in kHz instead of MHz.
You are absolutely right, on both accounts. But its far less important. 
Yes I committed it wrongfully. I missed it. I should have spotted it. 
You 'fixed' this bug though ;) Reviewing is still needed. 'Rules' in 
that regard can always be brought up later, when things actually do 
change. Auto apply after a week for example?

Again, 'bugs' aren't critical and don't break functionality (but of 
course do cause headaches if they don't work). But updates are required 
to happen quickly if they do (for dvb-t at the very least). If the 
broadcaster changes settings, users probably want to be able to tune 
right away.
>
>> * Possibly easier entry for new submitters
>> * much easier to package (tag it once per month if an update was)
>> * Separate maintainer possible
>> * just seems more logical to have it separated ;)
> The downside is you have to change the URL in kaffeine sources as
> kaffeine generates its scan file from that repo (on the server side and
> the client downloads then http://kaffeine.kde.org/scanfile.dvb.qz).
IF a proper change goes through, then that's a one time change only 
though and while kaffeine can still use its own mirror, it's less needed :p
>
>> This obviously should find a nice home on linuxtv where it belongs!
> At best.
>
>> Here is my personal repository with the work I mentioned done.
>> git://git.schinagl.nl/dvb_frequency_scanfiles.git
>>
>> If an issue is that none of the original maintainers are not looking
>> forward to do the job, I am willing to take maintenance on me for now.
> Ping? Anybody? I would help with that too as I hate resending patches.
> But the first step I would do is a conversion to GIT. HG is demented to
> begin with.
>

