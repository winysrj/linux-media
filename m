Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2K1OlTD006987
	for <video4linux-list@redhat.com>; Wed, 19 Mar 2008 21:24:47 -0400
Received: from mailout01.sul.t-online.de (mailout01.sul.t-online.de
	[194.25.134.80])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2K1ODnU006291
	for <video4linux-list@redhat.com>; Wed, 19 Mar 2008 21:24:13 -0400
Message-ID: <47E1BCAF.80208@t-online.de>
Date: Thu, 20 Mar 2008 02:23:59 +0100
From: Hartmut Hackmann <hartmut.hackmann@t-online.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
References: <47E060EB.5040207@t-online.de>	<Pine.LNX.4.64.0803190017330.24094@bombadil.infradead.org>	<47E190CF.9050904@t-online.de>
	<20080319193832.643bf8a0@gaivota>
In-Reply-To: <20080319193832.643bf8a0@gaivota>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Michael Krufky <mkrufky@linuxtv.org>,
	Linux and Kernel Video <video4linux-list@redhat.com>,
	LInux DVB <linux-dvb@linuxtv.org>
Subject: Re: [RFC] TDA8290 / TDA827X with LNA: testers wanted
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>



Mauro Carvalho Chehab schrieb:
> On Wed, 19 Mar 2008 23:16:47 +0100
> Hartmut Hackmann <hartmut.hackmann@t-online.de> wrote:
> 
>> Hi, Mauro
>>
>> Mauro Carvalho Chehab schrieb:
>>> On Wed, 19 Mar 2008, Hartmut Hackmann wrote:
>>>
>>>> Mauro, what's your opinion on this? As far as i know, the broken code
>>>> is in the upcoming
>>>> kernel release. The patch is big, is there a chance to commit it to
>>>> the kernel?
>>> While some fixes are cosmetic (like __func__ change), and others are
>>> just function reordering, I suspect that the real changes are still too
>>> big for -rc6. It will probably be nacked.
>>>
>>> Yet, it may be worthy to try.
>> This was my opinion as well.
>> Did you notice Michaels reply on this issue? He pointed out that the problem
>> was introduced by this changeset:
>> http://linuxtv.org/hg/v4l-dvb/rev/ad6fb7fe6240 : Add support for xc3028-based boards
>>
>> If this did not go to Linus yet, we don't have a problem. This also explains
>> why we don't have bug reports on this.
> 
> It didn't reach mainstream yet. About the bug report, there's a related bug, on
> a thread about Avermedia A16D. The issue is that "dev" is NULL but this
> shouldn't happen (otherwise, all callbacks will fail).
> 
> On your patch, you're just returning, if dev=NULL, at saa7134 callback function. IMO, the correct would be to
> print an error message and return. Also, we should discover why dev is being
> null there (I'll try to identify here - the reason - yet, I can't really test,
> since the saa7134 boards I have don't need any callback.

That's not the point. In the call in tda827x.c tda827xa_lna_gain(), the argument
did not point to the saa7134_dev structure as the function expected. I added
the check for NULL because only at the very first call, the pointer is still
not valid. I did not check this carefully but i guess this is a matter of the
initilization sequence of the data structures. IMHO yes, we should understand this
sometime but this does not have priority because i am sure that the NULL pointer
occurs only during initialization.

>>> I still need to send a patchset to Linus, after testing compilation
>>> (unfortunately, I had to postpone, since I need first to free some
>>> hundreds of Mb on my HD on my /home, to allow kernel compilation).
>>> Hopefully, I'll have some time tomorrow for doing a "housekeeping".
>>>
>> Unfortunately, i deleted you mails describing what went to linux and i don't
>> have the RC source here :-(
> 
> You may take a look on master branch on my git tree. I'm about to forward him a
> series of patches. Hopefully, 2GB free space will be enough for a full kernel
> compilation. I'll discover soon...
> 
Jep. Meanwhile Michael confirmed that the problem is not in mainstream,
so there is no reason to hurry.
But we should have a bigger audience for my latest changes, so i will send
you a pull request in a minute.


Best regards
  Hartmut

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
