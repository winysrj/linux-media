Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757868Ab2ARPVH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jan 2012 10:21:07 -0500
Message-ID: <4F16E353.9000908@redhat.com>
Date: Wed, 18 Jan 2012 13:20:51 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>
CC: Patrick Boettcher <pboettcher@kernellabs.com>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [git:v4l-dvb/for_v3.3] [media] DVB: dib0700, add support for
 Nova-TD LEDs
References: <E1RnU5E-0000Vf-T9@www.linuxtv.org> <4F16C6B8.8000402@linuxtv.org> <201201181454.34245.pboettcher@kernellabs.com> <4F16D97C.5070005@linuxtv.org>
In-Reply-To: <4F16D97C.5070005@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 18-01-2012 12:38, Michael Krufky escreveu:
> On 01/18/2012 08:54 AM, Patrick Boettcher wrote:
>> On Wednesday 18 January 2012 14:18:48 Michael Krufky wrote:
>>> Mauro,
>>>
>>> Why was my sign-off changed to an Ack?
>>>
>>> As you can see, I worked *with* Jiri to help him create this
>>> patchset.
>>>
>>> During review, I noticed a poorly named function, which I renamed
>>> before pusging it into my own tree.  Patrick saw this, and merged my
>>> changes into into his tree.
>>>
>>> Why did I go through this effort to help another developer add value
>>> to one of our drivers, and additional effort to make a small
>>> cleanup, push the changes into my own tree and issue a pull request?
>>>   I was thanked by Patrick.  Everybody's signature is on the patch,
>>> but you then go and remove my signature, and add a forged "ack"?  I
>>> don't understand this, Mauro.
>>
>> I think it is my fault.
>>
>> I haven't merged your tree but I merged Jiri's patches as is. (git am)
>> I completely oversaw your pull request and issued mine.
>>
>> Mauro in IRC told me that you issued a PULL request as well. Not being
>> aware that you have made any modifications Mauro suggest to pull from me
>> and add an Ack-By to the patches.
>>
>> So he did not remove anything but trusted me too much.
> 
> Hmmmm...  That's unfortunate.  I also made various corrections in the commit messages.
> 
> I *meant* this to go to Mauro, I didn't realize it was going to linux-media list. 
> Now I see that there was a reply-to header set, so that explains why "reply" had larger effects ;-)

With turned to be a good thing, as Patrick could reply on it ;)

> Either way, Mauro, Can you remove those patches and re-apply them from my tree?  Please feel free to add Patrick's Sign-off.

Sorry, but these would cause two very bad side effects:

1) I would need to rebase the tree to actually remove them, or to mangle the
history;

2) I'm planning to send today the last patches for the merge window. Those patches
are already at -next, together with a bunch of other patches. Removing them would
mean that I would need to wait for another day, probably missing the merge window.
> 
> For the record, I actually worked *with* Jiri on these patches -- I told him 
> how to toggle the LEDs, I told him which functions to override, and I showed him
> examples of how it was done elsewhere within dib0700 as well as how other drivers do it,
> and I encouraged him to submit these patches because I am trying to get more people 
> involved in DVB development.

Recorded.

For the record, SOB is the "Developer's Certificate of Origin" [1], e. g. it is used to
track who has manipulated the patch until it achieves upstream. It doesn't 
identify who authored the patch [2]. The main author of the patch is identified 
at the "From:". The other authors are identified inside the patch description,
as there's no special meta-data for co-authors.

Also for the record, when someone makes a patch for a maintained driver, I wait
for a few days in order to see if the maintainer will apply it. If he applies, 
I just pick from his tree. If the patch is trivial (new board addition, typo fixes),
I may just apply it, if I know the maintainer won't complain (several maintainers
seem to prefer this workflow, as they don't care enough to comment trivial patches).

So, if you wanted your SOB on the patches, you should either do:

	1) send it to Jiri for him to add them at the time the patches got posted;
	2) Submit the patches yourself, with both SOB's.

> I just feel violated to have my signature stripped away from something that I took part in,
> and then to see additional signatures added on top made matters worse.

Your signature wasn't stripped away. It was simply not there at the patches:
	http://patchwork.linuxtv.org/patch/9429/
	http://patchwork.linuxtv.org/patch/9426/
	http://patchwork.linuxtv.org/patch/9427/
	http://patchwork.linuxtv.org/patch/9428/

As Patrick picked the patches from the ML, the patch flow was:

Jiri -> Patrick -> me.

That means 3 SOB's on it, in order to represent such patch flow.

Regards,
Mauro

[1] http://linuxtv.org/wiki/index.php/Development:_Submitting_Patches#Developer.27s_Certificate_of_Origin_1.1

[2] As a general rule, the author gets the first SOB. Yet, there are
cases where someone's else takes the responsibility for submitting 
that patch upstream.
> 
> -Mike
> 
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

