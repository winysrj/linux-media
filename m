Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2R0FdL2006824
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 20:15:39 -0400
Received: from mailout11.sul.t-online.de (mailout11.sul.t-online.de
	[194.25.134.85])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2R0FRCV031929
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 20:15:27 -0400
Message-ID: <47EAE6DD.80701@t-online.de>
Date: Thu, 27 Mar 2008 01:14:21 +0100
From: Hartmut Hackmann <hartmut.hackmann@t-online.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
References: <47E060EB.5040207@t-online.de>	<Pine.LNX.4.64.0803190017330.24094@bombadil.infradead.org>	<47E190CF.9050904@t-online.de>	<20080319193832.643bf8a0@gaivota>	<47E1BCAF.80208@t-online.de>	<20080319224222.581d7b85@gaivota>	<47E2CBEF.3090609@t-online.de>
	<20080321082109.07bb6013@gaivota>
In-Reply-To: <20080321082109.07bb6013@gaivota>
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

Hi, Mauro

Mauro Carvalho Chehab schrieb:
> On Thu, 20 Mar 2008 21:41:19 +0100
> Hartmut Hackmann <hartmut.hackmann@t-online.de> wrote:
> 
>> HI, Mauro
>>
>> Mauro Carvalho Chehab schrieb:
>>> On Thu, 20 Mar 2008 02:23:59 +0100
>>> Hartmut Hackmann <hartmut.hackmann@t-online.de> wrote:
>>>
>>>>> On your patch, you're just returning, if dev=NULL, at saa7134 callback function. IMO, the correct would be to
>>>>> print an error message and return. Also, we should discover why dev is being
>>>>> null there (I'll try to identify here - the reason - yet, I can't really test,
>>>>> since the saa7134 boards I have don't need any callback.
>>>> That's not the point. In the call in tda827x.c tda827xa_lna_gain(), the argument
>>>> did not point to the saa7134_dev structure as the function expected. I added
>>>> the check for NULL because only at the very first call, the pointer is still
>>>> not valid. I did not check this carefully but i guess this is a matter of the
>>>> initilization sequence of the data structures. IMHO yes, we should understand this
>>>> sometime but this does not have priority because i am sure that the NULL pointer
>>>> occurs only during initialization.
>>> This is caused by a patch conflict between hybrid redesign and the merge of
>>> xc3028 support. The enclosed experimental patch fixes the tuner_callback
>>> argument, on linux/drivers/media/dvb/frontends/tda827x.c. 
>>> It should also fix the priv argument on saa7134_tuner_callback(). I can't test
>>> the saa7134 part here, due to the lack of a saa7134 hardware that needs a
>>> callback.
>>>
>>> The patch also intends to make xc3028 easier to use. That part is still not
>>> fully working. I should finish this patch tomorrow.
>>>
>>>>>>> I still need to send a patchset to Linus, after testing compilation
>>>>>>> (unfortunately, I had to postpone, since I need first to free some
>>>>>>> hundreds of Mb on my HD on my /home, to allow kernel compilation).
>>>>>>> Hopefully, I'll have some time tomorrow for doing a "housekeeping".
>>>>>>>
>>>>>> Unfortunately, i deleted you mails describing what went to linux and i don't
>>>>>> have the RC source here :-(
>>>>> You may take a look on master branch on my git tree. I'm about to forward him a
>>>>> series of patches. Hopefully, 2GB free space will be enough for a full kernel
>>>>> compilation. I'll discover soon...
>>>>>
>>>> Jep. Meanwhile Michael confirmed that the problem is not in mainstream,
>>>> so there is no reason to hurry.
>>> Yes.
>>>
>>>> But we should have a bigger audience for my latest changes, so i will send
>>>> you a pull request in a minute.
>>> Could you please test my patch first? Having the same arguments for all
>>> callback functions avoid future mistakes.
>>>
>>> ---
>>> [RFC] Fix tuner_callback for tda827x
>>>
>>> Signed-off-by Mauro Carvalho Chehab <mchehab@infradead.org>
>>>
>> <snip>
>>
>> Your patch does not completely apply for me, it fails in cx88-dvb.c
> 
> This is due to some changes that happened later on the tree, for cx88.
> 
> I also had some a trivial conflict on saa7134-cards, when merging from your tree ;)
> 
> The better is to do an "hg pull -u", before asking me to pull.
> 
Basically you are right of corse. I try to avoid this after i once saw a merge
causing an unnecessary huge change log. But this was an old hg version.

> Anyway, the conflict were easily solved.
> 
>> I had a close look and found that we are going in the same direction.
>> - The change in tda827x is the same as i did.
>> - In saa7134-cards.c your patch is right. My version just worked by accident.
>>   I corrected this in my repository.
>> By the way: the dev pointer is NULL during initialization is gone.
>> I tested again and things work for me.
> 
> Great news.
> 
>> I would recommend the following:
>> - You pull from my repository (sent you the request yesterday)
>> - You apply the patch *except* the changes in tda827x.c, saa7134-cards.c
>>   and saa7134-dvb.c. Afterwards we should be fine.
> 
> Ok, I did this. 
> 
> Patches applied on a order that won't generate bissect compilation issues.
> 
> I still had to patch saa7134-dvb, probably due to the conflict
> I've mentioned. I'll double check when importing the changes to -git, since
> I'll need to manually fix there, instead of trusting on kdiff3.
> 
> I also added a printk, if dev=NULL. This won't work with the current code, but
> it helps to track future issues, if we have this kind of troubles later with
> other callbacks.
> 
That's fine.

>> My other changes to tda827x and saa7134-dvb.c are not only cosmetic. It merged
>> the _lna_gain functions for analog and dvb and adapt the data structures.
>> What do you think?
> 
> Seems fine to me.
> 
> Just one comment about the config var (this applies also to the previous code): 
> I'd prefer to have an enum, instead of config=0,1,2,3. Something like:
> 
> enum {
> 	TDA827x_NO_LNA,
> 	TDA827x_LNA_VIA8290_LOW,
> 	TDA827x_LNA_VIA8290_HIGH,
> 	TDA827x_LNA_VIA_HOST,
> } config;
> 
> This helps people to better understand the LNA config code.
> 
Hm, i did similar things in other places...
I did not do this here because i wanted to be able to use this variable
with other tuners as well -> use #defines instead?

>> I will be out from friday to monday.
> 
> I should also take a break during those days ;)
> 
> 
> Cheers,
> Mauro
> 
Best regards
  Hartmut

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
