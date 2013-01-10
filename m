Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:52430 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753639Ab3AJUOn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jan 2013 15:14:43 -0500
Message-ID: <50EF2155.5060905@schinagl.nl>
Date: Thu, 10 Jan 2013 21:15:17 +0100
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Michael Krufky <mkrufky@linuxtv.org>,
	Jiri Slaby <jirislaby@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Johannes Stezenbach <js@linuxtv.org>,
	linux-media <linux-media@vger.kernel.org>, jmccrohan@gmail.com,
	Christoph Pfister <christophpfister@gmail.com>
Subject: Re: [RFC] Initial scan files troubles and brainstorming
References: <507FE752.6010409@schinagl.nl> <50D0E7A7.90002@schinagl.nl> <50EAA778.6000307@gmail.com> <50EAC41D.4040403@schinagl.nl> <20130108200149.GB408@linuxtv.org> <50ED3BBB.4040405@schinagl.nl> <20130109084143.5720a1d6@redhat.com> <CAOcJUbyKv-b7mC3-W-Hp62O9CBaRLVP8c=AWGcddWNJOAdRt7Q@mail.gmail.com> <20130109124158.50ddc834@redhat.com> <CAHFNz9+=awiUjve3QPgHtu5Vs2rbGqcLUMzyOojguHnY4wvnOA@mail.gmail.com> <50EF0A4F.1000604@gmail.com> <CAHFNz9LrW4GCZb-BwJ8v7b8iT-+8pe-LAy8ZRN+mBDNLsssGPg@mail.gmail.com> <CAOcJUbwya++5nW_MKvGOGbeXCbxFgahu_AWEGBb6TLNx0Pz53A@mail.gmail.com> <CAHFNz9JTGZ1MmFCGqyyP0F4oa6t4048O+EYX50zH2J-axpkGVA@mail.gmail.com>
In-Reply-To: <CAHFNz9JTGZ1MmFCGqyyP0F4oa6t4048O+EYX50zH2J-axpkGVA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/10/13 20:04, Manu Abraham wrote:
> On 1/11/13, Michael Krufky <mkrufky@linuxtv.org> wrote:
>> On Thu, Jan 10, 2013 at 1:46 PM, Manu Abraham <abraham.manu@gmail.com>
>> wrote:
>>> On 1/11/13, Jiri Slaby <jirislaby@gmail.com> wrote:
>>>> On 01/10/2013 06:40 PM, Manu Abraham wrote:
>>>>> On 1/9/13, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
>>>>>> Em Wed, 9 Jan 2013 06:08:44 -0500
>>>>>> Michael Krufky <mkrufky@linuxtv.org> escreveu:
>>>>>>
>>>>>>> On Wed, Jan 9, 2013 at 5:41 AM, Mauro Carvalho Chehab
>>>>>>> <mchehab@redhat.com> wrote:
>>>>>>>> Em Wed, 09 Jan 2013 10:43:23 +0100
>>>>>>>> Oliver Schinagl <oliver+list@schinagl.nl> escreveu:
>>>>>>>>
>>>>>>>>> On 08-01-13 21:01, Johannes Stezenbach wrote:
>>>>>>>>>> On Mon, Jan 07, 2013 at 01:48:29PM +0100, Oliver Schinagl wrote:
>>>>>>>>>>> On 07-01-13 11:46, Jiri Slaby wrote:
>>>>>>>>>>>> On 12/18/2012 11:01 PM, Oliver Schinagl wrote:
>>>>>>>>>>>>> Unfortunatly, I have had zero replies.
>>>>>>>>>>>> Hmm, it's sad there is a silence in this thread from linux-media
>>>>>>>>>>>> guys :/.
>>>>>>>>>>> In their defense, they are very very busy people ;) chatter on
>>>>>>>>>>> this
>>>>>>>>>>> thread does bring it up however.
>>>>>>>>>> This is such a nice thing to say :-)
>>>>>>>>>> But it might be that Mauro thinks the dvb-apps maintainer should
>>>>>>>>>> respond, but apparently there is no dvb-apps maintainer...
>>>>>>>>>> Maybe you should ask Mauro directly to create an account for you
>>>>>>>>>> to implement what you proposed.
>>>>>>>>> Mauro is CC'ed and I'd ask of course for this (I kinda did) but who
>>>>>>>>> decides what I suggested is a good idea? I personally obviously
>>>>>>>>> think
>>>>>>>>> it
>>>>>>>>> is ;) and even more so if dvb-apps are unmaintained.
>>>>>>>>>
>>>>>>>>> I guess the question now becomes 'who okay's this change? Who says
>>>>>>>>> 'okay, lets do it this way. Once that is answered we can go from
>>>>>>>>> there
>>>>>>>>> ;)
>>>>>>>>
>>>>>>>> If I understood it right, you want to split the scan files into a
>>>>>>>> separate
>>>>>>>> git tree and maintain it, right?
>>>>>>>>
>>>>>>>> I'm ok with that.
>>>>>>>>
>>>>>>>> Regards,
>>>>>>>> Mauro
>>>>>>>
>>>>>>> As a DVB maintainer, I am OK with this as well - It does indeed make
>>>>>>> sense to separate the c code sources from the regional frequency
>>>>>>> tables, and I'm sure we'll see much benefit from this change.
>>>>>>
>>>>>> Done. I created a tree for Oliver to maintain it and an account for
>>>>>> him.
>>>>>> I also created a new tree with just the DVB table commits to:
>>>>>>      http://git.linuxtv.org/dtv-scan-tables.git
>>>>>>
>>>>>> I kept there both szap and scan files, although maybe it makes sense
>>>>>> to
>>>>>> drop the szap table (channels-conf dir). It also makes sense to drop
>>>>>> the
>>>>>> tables from the dvb-apps tree, to avoid duplicated stuff, and to avoid
>>>>>
>>>>> Being one of the maintainers:
>>>>>
>>>>> I will keep the tables in the dvb-apps tree for the time being.
>>>>
>>>> That does not make sense at all -- why? Duplicated stuff always hurts.
>>>
>>>
>>> The scan files and config files are very specific to dvb-apps, some
>>> applications
>>> do rely on these config files. It doesn't really make sense to have
>>> split out config
>>> files for these  small applications.
>>>
>>>
>>>>
>>>>> Will decide to
>>>>> drop the config files as needed from dvb-apps. It is necessary to keep
>>>>> a
>>>>> copy of the config files for development purposes, rather than pulling
>>>>> from
>>>>> different trees.
>>>>
>>>> What development purposes, could you be more specific? You can still use
>>>> git submodules if really needed. But as it stands I do not see a reason
>>>> for that at all...
>>>
>>>
>>> Did you think that the dvb-apps just came out of thin air ?
>>>
>>> development of dvb-applications, implies eventually config files also
>>> will be updated as necessary. Having them in separate repositories
>>> makes such work harder for working.
>>> while working with dvb-apps, it would make things saner if it is the
>>> same SCM, rather
>>> than having different SCM's. So according to you, you want to make it
>>> still harder for someone to work with dvb-apps.
>>>
>>>
>>> Manu
>>
>> Manu,
>>
>> I see great value in separating the history of the data files from the
>> code files.  If you really think this is such a terrible task for a
>> developer to have to pull from a second repository to fetch these data
>> files, then I find no reason why we couldn't script it such that
>> building the dvb-apps package would trigger the pull from the
>> additional repository.
>>
>> I think that's a fair compromise.
>
>
>   As someone who has long been working with dvb-apps, I see no value
> in this, but just pain altogether. For people who have never worked with it,
> they can say anything what they want, which makes no sense at all.
Well there are a few apps that do use the initial scanfile tree, but do 
not use any of the dvb-apps.

(tvheadend, kaffeine appearantly, i'm guessing VDR and MythTV aswell?)
>
>
>> Meanwhile, your argument is for developers.  Developers can handle
>> pulling from a separated tree for data files who shouldn't be clouding
>> the history of source code development, anyway.  Developers are indeed
>> used to dealing with multiple repositories, and if any developer
>> isn't, then now is the time to get with the program!
>
>
> It isn't that way. Users have to deal with 2 repositories as well. Anyway,
> the repository is not having that many developers to state that developers
> can handle all the burden. It is just but the reverse.
Well one of the biggest issues was, that the scanfiles where ill 
maintained and projects where working around those shortcommings.

The scanfiles are technically unrelated. They are data files, facts and 
can very logically live seperated :) Having commit messages pure for 
data files in a source tree just looks off.

They simply have become a seperate entity as people (not developers) 
depend on them. (Yes there is wscan of course).

Also, purely out of curiousity, how are the scanfiles used during 
development?

oliver

>
> Manu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

