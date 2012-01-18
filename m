Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hauppauge.com ([167.206.143.4]:3419 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757724Ab2AROi7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jan 2012 09:38:59 -0500
Message-ID: <4F16D97C.5070005@linuxtv.org>
Date: Wed, 18 Jan 2012 09:38:52 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Patrick Boettcher <pboettcher@kernellabs.com>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [git:v4l-dvb/for_v3.3] [media] DVB: dib0700, add support for
 Nova-TD LEDs
References: <E1RnU5E-0000Vf-T9@www.linuxtv.org> <4F16C6B8.8000402@linuxtv.org> <201201181454.34245.pboettcher@kernellabs.com>
In-Reply-To: <201201181454.34245.pboettcher@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/18/2012 08:54 AM, Patrick Boettcher wrote:
> On Wednesday 18 January 2012 14:18:48 Michael Krufky wrote:
>> Mauro,
>>
>> Why was my sign-off changed to an Ack?
>>
>> As you can see, I worked *with* Jiri to help him create this
>> patchset.
>>
>> During review, I noticed a poorly named function, which I renamed
>> before pusging it into my own tree.  Patrick saw this, and merged my
>> changes into into his tree.
>>
>> Why did I go through this effort to help another developer add value
>> to one of our drivers, and additional effort to make a small
>> cleanup, push the changes into my own tree and issue a pull request?
>>   I was thanked by Patrick.  Everybody's signature is on the patch,
>> but you then go and remove my signature, and add a forged "ack"?  I
>> don't understand this, Mauro.
>
> I think it is my fault.
>
> I haven't merged your tree but I merged Jiri's patches as is. (git am)
> I completely oversaw your pull request and issued mine.
>
> Mauro in IRC told me that you issued a PULL request as well. Not being
> aware that you have made any modifications Mauro suggest to pull from me
> and add an Ack-By to the patches.
>
> So he did not remove anything but trusted me too much.

Hmmmm...  That's unfortunate.  I also made various corrections in the 
commit messages.

I *meant* this to go to Mauro, I didn't realize it was going to 
linux-media list.  Now I see that there was a reply-to header set, so 
that explains why "reply" had larger effects ;-)

Either way, Mauro, Can you remove those patches and re-apply them from 
my tree?  Please feel free to add Patrick's Sign-off.

For the record, I actually worked *with* Jiri on these patches -- I told 
him how to toggle the LEDs, I told him which functions to override, and 
I showed him examples of how it was done elsewhere within dib0700 as 
well as how other drivers do it, and I encouraged him to submit these 
patches because I am trying to get more people involved in DVB development.

I just feel violated to have my signature stripped away from something 
that I took part in, and then to see additional signatures added on top 
made matters worse.

-Mike


