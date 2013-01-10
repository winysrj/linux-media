Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:45228 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038Ab3AJSqj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jan 2013 13:46:39 -0500
Received: by mail-ob0-f182.google.com with SMTP id 16so922404obc.13
        for <linux-media@vger.kernel.org>; Thu, 10 Jan 2013 10:46:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50EF0A4F.1000604@gmail.com>
References: <507FE752.6010409@schinagl.nl>
	<50D0E7A7.90002@schinagl.nl>
	<50EAA778.6000307@gmail.com>
	<50EAC41D.4040403@schinagl.nl>
	<20130108200149.GB408@linuxtv.org>
	<50ED3BBB.4040405@schinagl.nl>
	<20130109084143.5720a1d6@redhat.com>
	<CAOcJUbyKv-b7mC3-W-Hp62O9CBaRLVP8c=AWGcddWNJOAdRt7Q@mail.gmail.com>
	<20130109124158.50ddc834@redhat.com>
	<CAHFNz9+=awiUjve3QPgHtu5Vs2rbGqcLUMzyOojguHnY4wvnOA@mail.gmail.com>
	<50EF0A4F.1000604@gmail.com>
Date: Fri, 11 Jan 2013 00:16:38 +0530
Message-ID: <CAHFNz9LrW4GCZb-BwJ8v7b8iT-+8pe-LAy8ZRN+mBDNLsssGPg@mail.gmail.com>
Subject: Re: [RFC] Initial scan files troubles and brainstorming
From: Manu Abraham <abraham.manu@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Oliver Schinagl <oliver+list@schinagl.nl>,
	Johannes Stezenbach <js@linuxtv.org>,
	linux-media <linux-media@vger.kernel.org>, jmccrohan@gmail.com,
	Christoph Pfister <christophpfister@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 1/11/13, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 01/10/2013 06:40 PM, Manu Abraham wrote:
>> On 1/9/13, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
>>> Em Wed, 9 Jan 2013 06:08:44 -0500
>>> Michael Krufky <mkrufky@linuxtv.org> escreveu:
>>>
>>>> On Wed, Jan 9, 2013 at 5:41 AM, Mauro Carvalho Chehab
>>>> <mchehab@redhat.com> wrote:
>>>>> Em Wed, 09 Jan 2013 10:43:23 +0100
>>>>> Oliver Schinagl <oliver+list@schinagl.nl> escreveu:
>>>>>
>>>>>> On 08-01-13 21:01, Johannes Stezenbach wrote:
>>>>>>> On Mon, Jan 07, 2013 at 01:48:29PM +0100, Oliver Schinagl wrote:
>>>>>>>> On 07-01-13 11:46, Jiri Slaby wrote:
>>>>>>>>> On 12/18/2012 11:01 PM, Oliver Schinagl wrote:
>>>>>>>>>> Unfortunatly, I have had zero replies.
>>>>>>>>> Hmm, it's sad there is a silence in this thread from linux-media
>>>>>>>>> guys :/.
>>>>>>>> In their defense, they are very very busy people ;) chatter on this
>>>>>>>> thread does bring it up however.
>>>>>>> This is such a nice thing to say :-)
>>>>>>> But it might be that Mauro thinks the dvb-apps maintainer should
>>>>>>> respond, but apparently there is no dvb-apps maintainer...
>>>>>>> Maybe you should ask Mauro directly to create an account for you
>>>>>>> to implement what you proposed.
>>>>>> Mauro is CC'ed and I'd ask of course for this (I kinda did) but who
>>>>>> decides what I suggested is a good idea? I personally obviously think
>>>>>> it
>>>>>> is ;) and even more so if dvb-apps are unmaintained.
>>>>>>
>>>>>> I guess the question now becomes 'who okay's this change? Who says
>>>>>> 'okay, lets do it this way. Once that is answered we can go from
>>>>>> there
>>>>>> ;)
>>>>>
>>>>> If I understood it right, you want to split the scan files into a
>>>>> separate
>>>>> git tree and maintain it, right?
>>>>>
>>>>> I'm ok with that.
>>>>>
>>>>> Regards,
>>>>> Mauro
>>>>
>>>> As a DVB maintainer, I am OK with this as well - It does indeed make
>>>> sense to separate the c code sources from the regional frequency
>>>> tables, and I'm sure we'll see much benefit from this change.
>>>
>>> Done. I created a tree for Oliver to maintain it and an account for him.
>>> I also created a new tree with just the DVB table commits to:
>>> 	http://git.linuxtv.org/dtv-scan-tables.git
>>>
>>> I kept there both szap and scan files, although maybe it makes sense to
>>> drop the szap table (channels-conf dir). It also makes sense to drop the
>>> tables from the dvb-apps tree, to avoid duplicated stuff, and to avoid
>>
>> Being one of the maintainers:
>>
>> I will keep the tables in the dvb-apps tree for the time being.
>
> That does not make sense at all -- why? Duplicated stuff always hurts.


The scan files and config files are very specific to dvb-apps, some
applications
do rely on these config files. It doesn't really make sense to have
split out config
files for these  small applications.


>
>> Will decide to
>> drop the config files as needed from dvb-apps. It is necessary to keep a
>> copy of the config files for development purposes, rather than pulling
>> from
>> different trees.
>
> What development purposes, could you be more specific? You can still use
> git submodules if really needed. But as it stands I do not see a reason
> for that at all...


Did you think that the dvb-apps just came out of thin air ?

development of dvb-applications, implies eventually config files also
will be updated as necessary. Having them in separate repositories
makes such work harder for working.
while working with dvb-apps, it would make things saner if it is the
same SCM, rather
than having different SCM's. So according to you, you want to make it
still harder for someone to work with dvb-apps.


Manu
