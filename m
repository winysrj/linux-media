Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:48881 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932201Ab3FQJTb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jun 2013 05:19:31 -0400
Message-ID: <51BED36D.5050403@schinagl.nl>
Date: Mon, 17 Jun 2013 11:14:21 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Duval Mickael <duvalmickael@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: DVB Scan file for Cherbourg (FR)
References: <CAMiis9aue=BJnGxhak9aKSXVtJPPB7df4WpKDdJL9Anw54en5Q@mail.gmail.com> <51B44BD5.2010208@schinagl.nl> <CAMiis9ZiLXwX+E2TmjsYkA1iCowArrP5jTT4VgWCeA6gCUDJDQ@mail.gmail.com> <CAMiis9bZtgfX_zha6vL1HVcxrNJb0RFvP=45Mp44Eb1cuUTSFA@mail.gmail.com> <51BB9033.50709@schinagl.nl> <CAMiis9ZgKKD3iiXchPcN=r9QCBjVvasmXjRn8rvmfzs33k-wPQ@mail.gmail.com> <CAMiis9a=nSvdueKfAJCU=JEuprQU_nSRtKx4u5-QKA2kUrEUZQ@mail.gmail.com> <51BC36ED.3010405@schinagl.nl> <CAMiis9aDuu7xArvg7QOvbXmzVpwKUhETr+m=WEKnbSHbhPuLpA@mail.gmail.com> <51BCD217.8060608@schinagl.nl> <CAMiis9bLv0TBuU_KBNFoDpjKzSBSy9JjaAYDicDRjtgf-6P7eA@mail.gmail.com>
In-Reply-To: <CAMiis9bLv0TBuU_KBNFoDpjKzSBSy9JjaAYDicDRjtgf-6P7eA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16-06-13 10:15, Duval Mickael wrote:
> It is true that only scans once! It can therefore be quite limited at
> this fr_All file and remove fr_Cherbourg and fr_Bordeaux.
Allright, per your request I will merge Cherbourg and Bordeaux into 
fr-All (if there are missing frequencies) and I'll use your fr-All
>
> 2013/6/15 Oliver Schinagl <oliver+list@schinagl.nl>:
>> On 15-06-13 12:08, Duval Mickael wrote:
>>>
>>> Indeed frequencies fr_Cherbourg and fr_Bordeaux are contained in fr_All.
>>> But I was thinking of doing a fr_All file and a specific file for all
>>> city as uk.
>>>
>>> With a file with only the useful frequency, detection will be much faster
>>> right?
>>
>> Yes, if you only have to scan 5 frequencies instead of 20 of course it will
>> be faster. But how often do you tune and how many frequencies are there to
>> consider? If you have look at fr-All, that looks pretty small to me. Having
>> 20 files covering those same frequencies will just add clutter to the db if
>> you ask me. So I would keep with one fr-All if it works 'for everybody'.
>>
>>>
>>> 2013/6/15 Oliver Schinagl <oliver+list@schinagl.nl>:
>>>>
>>>> On 06/15/13 11:30, Duval Mickael wrote:
>>>>>
>>>>> Ok I have cloned your repo with Git, and I've make two patch files.
>>>>>
>>>> Can you explain to me why there are fr-All and fr-Cherbourg? (and
>>>> fr-Bordeaux)?
>>>>
>>>> Does fr-All not work for those two places? If fr-All does everything,
>>>> it's
>>>> ok to merge the other two in. nl-All is all transponders for the country
>>>> as
>>>> a lot of frequencies are shared. We could have 10 or so nl-<area> but
>>>> they'd
>>>> be all really small.
>>>>
>>>> So is fr-All everything for the entire country, but has Cherbourg and
>>>> Bordeaux extra, very different freq's?
>>>>
>>>> Merged in c8050e8105b1b4b5364f57d8b3e658c80fb04a53 for now
>>>>
>>>> Thanks,
>>>> oliver
>>>>
>>>>> 2013/6/15 Duval Mickael <duvalmickael@gmail.com>:
>>>>>>
>>>>>> In zip there is a little modification for city of cherbourg (add two
>>>>>> new muxes) and a fr_ALL for France all channels DVB-T initial
>>>>>> scan.
>>>>>>
>>>>>> What's the problem exactly with my files?
>>>>>>
>>>>>> Thanks
>>>>>> Duval Mickael
>>>>>>
>>>>>> 2013/6/14 Oliver Schinagl <oliver+list@schinagl.nl>:
>>>>>>>
>>>>>>> On 06/13/13 19:10, Duval Mickael wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>> Hello,
>>>>>>>
>>>>>>>
>>>>>>> Hi,
>>>>>>>
>>>>>>>> I send this email to you for a DVB-T scan file for the city of
>>>>>>>> Cherbourg
>>>>>>>> FRANCE, modified with the last channels.
>>>>>>>> I also enclose a package file that includes all channels available
>>>>>>>> for
>>>>>>>> DVB-T in France.
>>>>>>>
>>>>>>>
>>>>>>> I've applied your patch (after manually working it over) last time.
>>>>>>>
>>>>>>> What is in this zip? Please send a patch file what still needs to be
>>>>>>> adjusted. Cherbourg is in the repo now, isn't it?
>>>>>>>
>>>>>>>> Sorry for my poor English ;-)
>>>>>>>>
>>>>>>>> Thank you.
>>>>>>>
>>>>>>>
>>>>>>>
>>

