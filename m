Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47507 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab2BSXM2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Feb 2012 18:12:28 -0500
Received: by eaah12 with SMTP id h12so2010525eaa.19
        for <linux-media@vger.kernel.org>; Sun, 19 Feb 2012 15:12:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <78E6697C-BD32-4062-BC2C-A5F7D0CBD79C@cosy.sbg.ac.at>
References: <4EF67721.9050102@unixsol.org>
	<4EF6DD91.2030800@iki.fi>
	<4EF6F84C.3000307@redhat.com>
	<CAF0Ff2kkFJYLUjVdmV9d9aWTsi-2ZHHEEjLrVSTCUnP+VTyxRg@mail.gmail.com>
	<4EF7066C.4070806@redhat.com>
	<loom.20111227T105753-96@post.gmane.org>
	<CAF0Ff2mf0tYs3UG3M6Cahep+_kMToVaGgPhTqR7zhRG0UXWuig@mail.gmail.com>
	<85A7A8FC-150C-4463-B09C-85EED6F851A8@cosy.sbg.ac.at>
	<CAF0Ff2ncv0PJWSOOw=7WeGyqX3kKiQitY52uEOztfC8Bwj6LgQ@mail.gmail.com>
	<CAB0B130-3B08-41B4-920A-C54058C43AEE@cosy.sbg.ac.at>
	<CAF0Ff2kF3VCL4PomOo5zBBrZSPmPvGd9qSZ+XwSp7ALJmq3+kw@mail.gmail.com>
	<78E6697C-BD32-4062-BC2C-A5F7D0CBD79C@cosy.sbg.ac.at>
Date: Mon, 20 Feb 2012 01:12:25 +0200
Message-ID: <CAF0Ff2nCz114LEJFRXy+L7Yq-uD4+sJeHOzNSk=28V_qgbta7A@mail.gmail.com>
Subject: Re: DVB-S2 multistream support
From: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
To: =?ISO-8859-1?Q?Christian_Pr=E4hauser?= <cpraehaus@cosy.sbg.ac.at>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hello Christian,

that's really great news! i'm looking forward to look at the code when
the public repository is ready. i'm sure i'm not the only one and the
news would be especially exciting for TBS 6925 owners, which use
Linux, but it's away beyond that, because the real news here is
working base-band support in 'dvb-core' of V4L. also, it's really good
that SAA716x code seems to just work with BBFrames and no further
changes are required there.

kind regards,
konstantin

On Sat, Feb 18, 2012 at 9:06 PM, Christian Prähauser
<cpraehaus@cosy.sbg.ac.at> wrote:
> Hello Konstantin!
>
> I was on holiday, so no problem at all. I wanted to tell you that I
> managed to get the base-band demux working with the TBS6925 card.
> Actually, I needed to modify the configuration of the STV0900
> packet delineator to switch the circuit to frame mode. The SAA716x
> PCI adapter chip seems to forward the base-band frame without errors.
> I haven't verified if all frames are received, will do that in the next
> couple of days. From that point on, I'm going to complete some open issues
> and clean up the rest of the stuff and open a public repository for the
> bb-demux.
>
> Thanks for the link to the MIS filter patch. I will include it in the
> base-band filtering code
> and try to enhance it to support filtering on multiple ISIs, as the STV0900
> seems to support this.
>
>
> Thanks and kind regards,
> Christian.
>
> Am 01.02.2012 um 19:49 schrieb Konstantin Dimitrov:
>
>
>> hi Christian,
>>
>> sorry for the very late reply - unfortunately i'm very busy lately.
>> so, what i can tell you about your questions:
>>
>> * for setting MIS filter you can follow the link in the first email
>> that started the discussion here:
>>
>>
>> http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/42312
>>
>> or more specifically what's posted here:
>>
>> http://www.tbsdtv.com/forum/viewtopic.php?f=26&t=1874
>>
>> i don't know if you have access to some signal modulator/generator
>> with MIS support, but if not there are several good live MIS signals,
>> e.g.
>>
>> Atlantic Bird 1 @ 12.5 W, 12718 H, 36510, FEC 5/6
>>
>> it's 8PSK MIS transponder with four TS, ISIs of them are: 33, 34, 35 36
>>
>> if you can't get 12.5W let me know and i will look for some other live
>> signal useful for test purposes.
>>
>> *  STV900AAC needs to be put on BBFrame mode, by default it strips the
>> BB data and outputs TS. however, the necessary settings for are
>> BBFrame mode not very clear - i need to do some trial and errors until
>> i hopefully get the BBFrame mode working. however, what is useful as a
>> starter is to parse/analyze for errors data dump made in Windows with
>> "TBS Recorder" tool - i believe i mentioned it to you - the data dump
>> made with that tool seems as valid BBFrames at least at first glance
>> with hex-editor, i.e. valid BBHeader data are observed. so, is there
>> some tool from your work (maybe 'bb-demux') that can parse/analyze
>> data dump of supposedly BBFrames.
>>
>> anyway, let me know what help you need - i will look at BBFrame mode
>> for STV900AAC, because i can identify that task as open.
>>
>> best wishes,
>> konstantin
>>
>> On Wed, Jan 25, 2012 at 3:12 PM, Christian Prähauser
>> <cpraehaus@cosy.sbg.ac.at> wrote:
>>>
>>> Hi Konstantin!
>>>
>>> I received your "present" :-) - many thanks! I already ported my
>>> base-band
>>> demux code to the current linux media master branch (in the v4l-dvb git
>>> repo).
>>> It currently allows drivers/frontends to pass base-band frames to the
>>> bb-demux.
>>> The bb-demux allows user-space filtering for BBFrames, TS packets, etc
>>> via
>>> the demux handle or dvr device. It also allows other kernel components to
>>> do
>>> base-band filtering (e.g. receive BBFrames on a specific ISI).
>>>
>>> Currently, the bb-demux only accepts a single, complete BBFrame in a
>>> single
>>> buffer, but I think
>>> it should also be able to cope with a stream of data (for ease of driver
>>> integration), including
>>> synchronization (search for frame start) and buffering (for assembling
>>> frames).
>>>
>>> Besides checking whether the current user-space API for base-band
>>> filtering
>>> is useful,
>>> there are a few remaining design questions to think about:
>>>
>>>  * How to allow pes/section filtering when receiving multiple TSs in
>>> parallel (on different ISIs)
>>>       - allow to "stack" filters, e.g. a bb-demux filter delivers TS from
>>> a
>>> certain
>>>       ISI and forwards it to a section filter (which then passes sections
>>> to user-space).
>>>       - dmx / dvr device for each?
>>>  * When and how to bring frontend into base-band data mode (a mode where
>>> it
>>> delivers
>>>       BBFrames instead of TS)?
>>>       - Should this be set by the user or happen automatically?
>>>  * How to set ISI on demux if we receive TS on a channel with MIS
>>>       (if this is not already possible, didn't check it yet)
>>>       - this could be covered by the bb-demux filtering API, although the
>>> base-band
>>>       demux is not directly involved in this case (since TS data is
>>> delivered to dvb-core).
>>>
>>> For now, I'm working to setup a public GIT repository, so you can have a
>>> look at the current status.
>>> Do you have a repository for the TBS drivers or should I use the official
>>> ones? Do you have
>>> an idea of how to program the STV900 to output BBFrames?
>>>
>>> Thanks again and kind regards,
>>> Christian.
>>>
>>> Am 17.01.2012 um 21:04 schrieb Konstantin Dimitrov:
>>>
>>>
>>>> hi Christian,
>>>>
>>>> it's great that you find it interesting too. i already prepared the
>>>> package and i will send it tomorrow - you should get in shorty - i
>>>> believe even with the most inexpensive shipping service within Europe
>>>> you will get in just a week or so. i hope you will have fun with the
>>>> TBS 6925 board - even if not for anything else just to receive DVB-S2
>>>> in Linux.
>>>>
>>>> kind regards,
>>>> konstantin
>>>>
>>>> On Thu, Jan 12, 2012 at 3:06 PM, Christian Prähauser
>>>> <cpraehaus@cosy.sbg.ac.at> wrote:
>>>>>
>>>>>
>>>>> Hi Konstantin!
>>>>>
>>>>> Thank you, and a happy new year to you too!
>>>>>
>>>>> The way to proceed you suggested sounds very interesting too me! I'd
>>>>> be more than happy if you could send me the TBS 6925 card to my
>>>>> university
>>>>> address:
>>>>>
>>>>> Christian Prähauser
>>>>> c/o Department of Computer Sciences
>>>>> University of Salzburg
>>>>> Jakob Haringer Str. 2
>>>>> A 5020 Salzburg
>>>>> AUSTRIA
>>>>>
>>>>> I will start to update my patches to match recent LinuxDVB sources and
>>>>> try to integrate Baseband demux support into the TBS linux driver.
>>>>> If this works, we can also put in GSE-support (S2-native encapsulation
>>>>> for
>>>>> carrying IP packets in DVB). This would then probably start to be
>>>>> interesting
>>>>> for some people...
>>>>>
>>>>> Thanks and kind regards,
>>>>> Christian.
>>>>>
>>>>> Am 10.01.2012 um 20:40 schrieb Konstantin Dimitrov:
>>>>>
>>>>>
>>>>>> hello Christian,
>>>>>>
>>>>>> and Happy New Year to you!
>>>>>>
>>>>>> thank you for joining the discussion, but apparently and unfortunately
>>>>>> Mauro current priorities are not to bring V4L to a next-level, as you
>>>>>> call it in your article to next-generation. anyway, i think your work
>>>>>> is very interesting and the least i can do is to offer you, if you
>>>>>> agree and give me your address, to send you as gift one TBS 6925 card
>>>>>> - i had two samples of such card, because i made the Linux drivers for
>>>>>> it and i can send you one of those two boards to you. what is
>>>>>> interesting about the card that in Windows TBS has tool called "TBS
>>>>>> Recorder" that can capture BBFrames - i'm not sure if the capture is
>>>>>> entirely correct, but at least checking with hex-editor the BBFrames
>>>>>> headers are present in the data dump. also, datasheets of the
>>>>>> demodulator in use on the board confirm that it can output BBFreames.
>>>>>> so, we can try just for fun to merge your work on BB-demux to V4L tree
>>>>>> with TBS 6925 support and see if we can get real hardware take use of
>>>>>> the BB-demux. what you think about such idea?
>>>>>>
>>>>>> kind regards,
>>>>>> konstantin
>>>>>>
>>>>>> On Tue, Dec 27, 2011 at 12:12 PM, Christian Prähauser
>>>>>> <cpraehaus@cosy.sbg.ac.at> wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> Yes, I'm meaning something like what it was described there. I think
>>>>>>>> that the code written by Christian were never submitted upstream.
>>>>>>>>
>>>>>>>
>>>>>>> Hello Mauro,
>>>>>>>
>>>>>>> Konstantin drew my attention to this discussion. Indeed, some time
>>>>>>> ago
>>>>>>> I
>>>>>>> wrote
>>>>>>> a base-band demux for LinuxDVB. It was part of a project to integrate
>>>>>>> support
>>>>>>> for second-generation IP/DVB encapsulations (GSE). The BB-demux
>>>>>>> allows
>>>>>>> to
>>>>>>> register filters for different ISIs and data types (raw, generic
>>>>>>> stream,
>>>>>>> transport stream).
>>>>>>>
>>>>>>> I realized that the repo hosted at our University is down. If there
>>>>>>> is
>>>>>>> interest,
>>>>>>> I can update my patches to the latest LinuxDVB version and we can put
>>>>>>> them on a
>>>>>>> public repo e.g. at linuxdvb.org.
>>>>>>>
>>>>>>> Kind regards,
>>>>>>> Christian.
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> --
>>>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>>>> linux-media"
>>>>>>> in
>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> ---
>>>>> Dipl.-Ing. Christian Praehauser <cpraehaus@cosy.sbg.ac.at>
>>>>>
>>>>> || //\\//\\ || Multimedia Communications Group,
>>>>> ||//  \/  \\|| Department of Computer Sciences, University of Salzburg
>>>>> http://www.cosy.sbg.ac.at/~cpraehaus/
>>>>> http://www.network-research.org/
>>>>> http://www.uni-salzburg.at/
>>>
>>>
>>>
>>> ---
>>> Dipl.-Ing. Christian Praehauser <cpraehaus@cosy.sbg.ac.at>
>>>
>>> || //\\//\\ || Multimedia Communications Group,
>>> ||//  \/  \\|| Department of Computer Sciences, University of Salzburg
>>> http://www.cosy.sbg.ac.at/~cpraehaus/
>>> http://www.network-research.org/
>>> http://www.uni-salzburg.at/
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> ---
> Dipl.-Ing. Christian Praehauser <cpraehaus@cosy.sbg.ac.at>
>
> || //\\//\\ || Multimedia Communications Group,
> ||//  \/  \\|| Department of Computer Sciences, University of Salzburg
> http://www.cosy.sbg.ac.at/~cpraehaus/
> http://www.network-research.org/
> http://www.uni-salzburg.at/
