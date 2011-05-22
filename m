Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:45179 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752713Ab1EVLVp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 May 2011 07:21:45 -0400
References: <BANLkTin=Fs-ugm13yT89PtT4bds4WobszA@mail.gmail.com> <BANLkTi=poXh2q+4N6Q9iMJxoW=9txLjt4w@mail.gmail.com> <BANLkTimQGYqS=PRNJSEtL5Wu0rP3YdEOVg@mail.gmail.com> <BANLkTimOUFgBKx5Y4VE+v08SMVB+Ms5RBg@mail.gmail.com> <BANLkTimcqrz3ExwT_TH_AG0zue7YRfTDeg@mail.gmail.com>
In-Reply-To: <BANLkTimcqrz3ExwT_TH_AG0zue7YRfTDeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: Connexant cx25821 help
From: Andy Walls <awalls@md.metrocast.net>
Date: Sun, 22 May 2011 07:21:55 -0400
To: Roman Gaufman <hackeron@gmail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org
Message-ID: <82ec0fb3-fa3d-49f2-b679-90e5b2d26aeb@email.android.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Roman Gaufman <hackeron@gmail.com> wrote:

>On 22 May 2011 04:11, Devin Heitmueller <dheitmueller@kernellabs.com>
>wrote:
>> On Sat, May 21, 2011 at 10:25 PM, Roman Gaufman <hackeron@gmail.com>
>wrote:
>>> I figured as much, but what can I do now?
>>
>> Your options at this point are:
>>
>> 1.  Find some developer who cares enough to take a free board just
>for
>> the fun of making it work.
>
>Any suggestions where?
>
>> 2.  If you're a commercial entity, hire somebody to do the work
>> (Kernel Labs does this sort of work)
>
>I have a small company that consists of just me and I'm broke, heh,
>but I'll check out kernel labs thanks!
>
>> 3.  Learn enough about driver development to add the support
>yourself.
>
>Any suggestions where/how to start? - are there any guides/tutorials
>that show how to go from start to finish getting a board to work?
>
>>
>> The reality is that the LinuxTV project is grossly understaffed
>> already, and if you're a regular user who wants a working product,
>> your best bet is to just buy something that is already supported.
> All
>> other options require either a considerable investment in money (to
>> pay someone to do the work), or time (to learn how to do it
>yourself).
>
>Do you have any recommendations for a DVR card that has 8 or 16
>audio+video inputs that's already supported by linux available for
>sale?
>
>The problem is I can't find anything that's already supported, so I'm
>just trying random cards. I bought one with SAA7134 chips that
>happened to work, but they stopped making it.
>
>The problem is I can't find anything supported that's available for
>sale. It seems quite the opposite, only rare obscure cards that are no
>longer sold are supported :/
>
>>
>> Developers who care enough to contribute to the project typically
>have
>> no shortage of boards at their disposal, and they tend to focus their
>> energy on where you get the most bang for the buck.  This tends to
>> favor products that are more popular, which is why the cx25821 driver
>> has gotten almost zero attention (since there are almost no actual
>> products using it other than Conexant reference designs).
>>
>>> Should I take some high resolution pictures of the board?
>>> Any other details I can provide to help developers add support for
>this board?
>>> Is there anyone in particularly I should contact?
>>> Anywhere I can post any information I collect on this board?
>>
>> You can create an entry on the LinuxTV wiki with the board details.
>> Of course no guarantee that anybody will do anything with it (in
>fact,
>> the less popular the board, the less likely for this to be the case).
>
>This is a board from http://securitycamera2000.com and is one of the
>few boards that pop up when looking for a DVR card on google and ebay.
>
>I will create an entry on the LinuxTV wiki, thanks!
>
>>
>> Devin
>>
>> --
>> Devin J. Heitmueller - Kernel Labs
>> http://www.kernellabs.com
>>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

Bluecherry might have a product that meet your needs:

http://store.bluecherry.net/products/PV%252d155-%252d-16-port-video-capture-card-%28120FPS%29.html

I have no actual experience with their products myself.

Regards,
Andy
