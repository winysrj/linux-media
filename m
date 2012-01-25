Return-path: <linux-media-owner@vger.kernel.org>
Received: from pitbull.cosy.sbg.ac.at ([141.201.2.122]:41830 "EHLO
	pitbull.cosy.sbg.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab2AYNMm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jan 2012 08:12:42 -0500
Cc: linux-media@vger.kernel.org
Message-Id: <CAB0B130-3B08-41B4-920A-C54058C43AEE@cosy.sbg.ac.at>
From: =?ISO-8859-1?Q?Christian_Pr=E4hauser?= <cpraehaus@cosy.sbg.ac.at>
To: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
In-Reply-To: <CAF0Ff2ncv0PJWSOOw=7WeGyqX3kKiQitY52uEOztfC8Bwj6LgQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; delsp=yes
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: DVB-S2 multistream support
Date: Wed, 25 Jan 2012 14:12:40 +0100
References: <4EF67721.9050102@unixsol.org> <4EF6DD91.2030800@iki.fi> <4EF6F84C.3000307@redhat.com> <CAF0Ff2kkFJYLUjVdmV9d9aWTsi-2ZHHEEjLrVSTCUnP+VTyxRg@mail.gmail.com> <4EF7066C.4070806@redhat.com> <loom.20111227T105753-96@post.gmane.org> <CAF0Ff2mf0tYs3UG3M6Cahep+_kMToVaGgPhTqR7zhRG0UXWuig@mail.gmail.com> <85A7A8FC-150C-4463-B09C-85EED6F851A8@cosy.sbg.ac.at> <CAF0Ff2ncv0PJWSOOw=7WeGyqX3kKiQitY52uEOztfC8Bwj6LgQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Konstantin!

I received your "present" :-) - many thanks! I already ported my base- 
band
demux code to the current linux media master branch (in the v4l-dvb  
git repo).
It currently allows drivers/frontends to pass base-band frames to the  
bb-demux.
The bb-demux allows user-space filtering for BBFrames, TS packets, etc  
via
the demux handle or dvr device. It also allows other kernel components  
to do
base-band filtering (e.g. receive BBFrames on a specific ISI).

Currently, the bb-demux only accepts a single, complete BBFrame in a  
single buffer, but I think
it should also be able to cope with a stream of data (for ease of  
driver integration), including
synchronization (search for frame start) and buffering (for assembling  
frames).

Besides checking whether the current user-space API for base-band  
filtering is useful,
there are a few remaining design questions to think about:

  * How to allow pes/section filtering when receiving multiple TSs in  
parallel (on different ISIs)
	- allow to "stack" filters, e.g. a bb-demux filter delivers TS from a  
certain
	ISI and forwards it to a section filter (which then passes sections  
to user-space).
	- dmx / dvr device for each?
  * When and how to bring frontend into base-band data mode (a mode  
where it delivers
	BBFrames instead of TS)?
	- Should this be set by the user or happen automatically?
  * How to set ISI on demux if we receive TS on a channel with MIS
	(if this is not already possible, didn't check it yet)
	- this could be covered by the bb-demux filtering API, although the  
base-band
	demux is not directly involved in this case (since TS data is  
delivered to dvb-core).

For now, I'm working to setup a public GIT repository, so you can have  
a look at the current status.
Do you have a repository for the TBS drivers or should I use the  
official ones? Do you have
an idea of how to program the STV900 to output BBFrames?

Thanks again and kind regards,
Christian.

Am 17.01.2012 um 21:04 schrieb Konstantin Dimitrov:

> hi Christian,
>
> it's great that you find it interesting too. i already prepared the
> package and i will send it tomorrow - you should get in shorty - i
> believe even with the most inexpensive shipping service within Europe
> you will get in just a week or so. i hope you will have fun with the
> TBS 6925 board - even if not for anything else just to receive DVB-S2
> in Linux.
>
> kind regards,
> konstantin
>
> On Thu, Jan 12, 2012 at 3:06 PM, Christian Prähauser
> <cpraehaus@cosy.sbg.ac.at> wrote:
>> Hi Konstantin!
>>
>> Thank you, and a happy new year to you too!
>>
>> The way to proceed you suggested sounds very interesting too me! I'd
>> be more than happy if you could send me the TBS 6925 card to my  
>> university
>> address:
>>
>> Christian Prähauser
>> c/o Department of Computer Sciences
>> University of Salzburg
>> Jakob Haringer Str. 2
>> A 5020 Salzburg
>> AUSTRIA
>>
>> I will start to update my patches to match recent LinuxDVB sources  
>> and
>> try to integrate Baseband demux support into the TBS linux driver.
>> If this works, we can also put in GSE-support (S2-native  
>> encapsulation for
>> carrying IP packets in DVB). This would then probably start to be
>> interesting
>> for some people...
>>
>> Thanks and kind regards,
>> Christian.
>>
>> Am 10.01.2012 um 20:40 schrieb Konstantin Dimitrov:
>>
>>
>>> hello Christian,
>>>
>>> and Happy New Year to you!
>>>
>>> thank you for joining the discussion, but apparently and  
>>> unfortunately
>>> Mauro current priorities are not to bring V4L to a next-level, as  
>>> you
>>> call it in your article to next-generation. anyway, i think your  
>>> work
>>> is very interesting and the least i can do is to offer you, if you
>>> agree and give me your address, to send you as gift one TBS 6925  
>>> card
>>> - i had two samples of such card, because i made the Linux drivers  
>>> for
>>> it and i can send you one of those two boards to you. what is
>>> interesting about the card that in Windows TBS has tool called "TBS
>>> Recorder" that can capture BBFrames - i'm not sure if the capture is
>>> entirely correct, but at least checking with hex-editor the BBFrames
>>> headers are present in the data dump. also, datasheets of the
>>> demodulator in use on the board confirm that it can output  
>>> BBFreames.
>>> so, we can try just for fun to merge your work on BB-demux to V4L  
>>> tree
>>> with TBS 6925 support and see if we can get real hardware take use  
>>> of
>>> the BB-demux. what you think about such idea?
>>>
>>> kind regards,
>>> konstantin
>>>
>>> On Tue, Dec 27, 2011 at 12:12 PM, Christian Prähauser
>>> <cpraehaus@cosy.sbg.ac.at> wrote:
>>>>>
>>>>>
>>>>> Yes, I'm meaning something like what it was described there. I  
>>>>> think
>>>>> that the code written by Christian were never submitted upstream.
>>>>>
>>>>
>>>> Hello Mauro,
>>>>
>>>> Konstantin drew my attention to this discussion. Indeed, some  
>>>> time ago I
>>>> wrote
>>>> a base-band demux for LinuxDVB. It was part of a project to  
>>>> integrate
>>>> support
>>>> for second-generation IP/DVB encapsulations (GSE). The BB-demux  
>>>> allows to
>>>> register filters for different ISIs and data types (raw, generic  
>>>> stream,
>>>> transport stream).
>>>>
>>>> I realized that the repo hosted at our University is down. If  
>>>> there is
>>>> interest,
>>>> I can update my patches to the latest LinuxDVB version and we can  
>>>> put
>>>> them on a
>>>> public repo e.g. at linuxdvb.org.
>>>>
>>>> Kind regards,
>>>> Christian.
>>>>
>>>>
>>>>
>>>>
>>>>
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux- 
>>>> media" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>> ---
>> Dipl.-Ing. Christian Praehauser <cpraehaus@cosy.sbg.ac.at>
>>
>> || //\\//\\ || Multimedia Communications Group,
>> ||//  \/  \\|| Department of Computer Sciences, University of  
>> Salzburg
>> http://www.cosy.sbg.ac.at/~cpraehaus/
>> http://www.network-research.org/
>> http://www.uni-salzburg.at/

---
Dipl.-Ing. Christian Praehauser <cpraehaus@cosy.sbg.ac.at>

|| //\\//\\ || Multimedia Communications Group,
||//  \/  \\|| Department of Computer Sciences, University of Salzburg
http://www.cosy.sbg.ac.at/~cpraehaus/
http://www.network-research.org/
http://www.uni-salzburg.at/
