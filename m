Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:54645 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbZIJJBm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2009 05:01:42 -0400
Message-ID: <4AA8C07C.9030804@nildram.co.uk>
Date: Thu, 10 Sep 2009 10:01:48 +0100
From: Lou Otway <lotway@nildram.co.uk>
Reply-To: lotway@nildram.co.uk
MIME-Version: 1.0
To: Eduard Huguet <eduardhc@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Nova-T 500 Dual DVB-T and h.264
References: <4AA7AE23.2040601@nildram.co.uk>	 <loom.20090909T195347-576@post.gmane.org>	 <4AA8B235.3050407@nildram.co.uk> <617be8890909100110jaaedf51h637d114d30382b99@mail.gmail.com>
In-Reply-To: <617be8890909100110jaaedf51h637d114d30382b99@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Eduard Huguet wrote:
> 2009/9/10 Lou Otway <lotway@nildram.co.uk>:
>> Eduard Huguet wrote:
>>> Lou Otway <lotway <at> nildram.co.uk> writes:
>>>
>>>> Hi,
>>>>
>>>> Does anyone have experience of using the Hauppuage Nova-T 500 with DVB-T
>>>> broadcasts with h.264 and AAC audio?
>>>>
>>>> DTT in New Zealand uses these formats and I'm seeing poor performance
>>>> from the Nova-T card. My thinking is that it was probably not conceived for
>>>> dealing with dual h264 streams.
>>>>
>>>> Has the PCIe HVR-2200 been tested with dual h.264? I was wondering if
>>>> this card might have better performance.
>>>>
>>>> Thanks,
>>>>
>>>> Lou
>>>
>>> Hi,    AFAIK the card just tunes to the desired frequency, applies
>>> configured
>>> filters (to select the desired station through its PID number), and
>>> handles the
>>> received transport stream to the calling application. It's up to the
>>> lastest to
>>> properly decode it. Check that the software you are using is properly
>>> capable of
>>> decoding this kind of content.
>>>
>>> Best regards,  Eduard Huguet
>>
>> Hi,
>>
>> the problem isn't to do with playback as I have another type of adapter card
>> that creates a TS, from the same mux, that is played back with no problem.
>>
>> It seems that the problem only happens when using the Nova-T card.
>>
>> DTT in NZ has services with 1080i video format, I'm not sure that there are
>> many other places in the world where 1080i h.264 content is broadcast using
>> DVB-T, hence I was thinking that this combination may not have been well
>> tested.
>>
>> Thanks,
>>
>> Lou
>>
> 
> I don't know how this it works in NZ. Here in Spain there is at least
> one station (TVC's 3HD) emitting HD content through TDT, and it works
> flawlessly with a Nova-T 500 (as I have one). I'm not sure if contents
> are 1080 or 720, though.
> 
> There were some problems watching these channels through MythTV, but
> they were definitely decoding related. With current MythTV trunk they
> are fine.
> 
> Anyway, as I said before, theoretically a DVB card doesn't know what
> kind of streams contains the signal it tunes. Decoding & parsing is
> handled by the app.
> 
> Best regards,
>   Eduard Huguet
> --

I'm not using MythTV or any other type of Media playing application.

In any case, I see very different performance between the two different 
types of card, when presented with the same input.

I'll gather some more data, if I can draw any new conclusions I'll 
update the list.

Best,

Lou


