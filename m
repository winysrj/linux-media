Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2R15EVx025451
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 21:05:14 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2R151je029106
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 21:05:01 -0400
Date: Wed, 26 Mar 2008 21:04:59 -0400 (EDT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hartmut Hackmann <hartmut.hackmann@t-online.de>
In-Reply-To: <47EAE6DD.80701@t-online.de>
Message-ID: <Pine.LNX.4.64.0803262101120.15374@bombadil.infradead.org>
References: <47E060EB.5040207@t-online.de>
	<Pine.LNX.4.64.0803190017330.24094@bombadil.infradead.org>
	<47E190CF.9050904@t-online.de> <20080319193832.643bf8a0@gaivota>
	<47E1BCAF.80208@t-online.de> <20080319224222.581d7b85@gaivota>
	<47E2CBEF.3090609@t-online.de> <20080321082109.07bb6013@gaivota>
	<47EAE6DD.80701@t-online.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
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

On Thu, 27 Mar 2008, Hartmut Hackmann wrote:

>> The better is to do an "hg pull -u", before asking me to pull.
>>
> Basically you are right of corse. I try to avoid this after i once saw a merge
> causing an unnecessary huge change log. But this was an old hg version.

hg merge logs sucks, IMO. Git do a much better job. I didn't tested yet hg 
version 1.0 (finally, they lauched version 1 ;) ).

>> Just one comment about the config var (this applies also to the previous code):
>> I'd prefer to have an enum, instead of config=0,1,2,3. Something like:
>>
>> enum {
>> 	TDA827x_NO_LNA,
>> 	TDA827x_LNA_VIA8290_LOW,
>> 	TDA827x_LNA_VIA8290_HIGH,
>> 	TDA827x_LNA_VIA_HOST,
>> } config;
>>
>> This helps people to better understand the LNA config code.
>>
> Hm, i did similar things in other places...
> I did not do this here because i wanted to be able to use this variable
> with other tuners as well -> use #defines instead?

Could be #define or enum. Yet, we'll need to have those defines/enum 
declared into a .h, and included on the driver that uses it. We are using 
this approach also for other drivers that need callback, like 
tuner-xc2028.h.

Cheers,
Mauro Carvalho Chehab
http://linuxtv.org
mchehab@infradead.org

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
