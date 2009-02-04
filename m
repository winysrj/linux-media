Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp129.rog.mail.re2.yahoo.com ([206.190.53.34]:24312 "HELO
	smtp129.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751358AbZBDD4h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Feb 2009 22:56:37 -0500
Message-ID: <498911EE.7050505@rogers.com>
Date: Tue, 03 Feb 2009 22:56:30 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>
CC: David Engel <david@istwok.net>, Hans Verkuil <hverkuil@xs4all.nl>,
	V4L <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Josh Borke <joshborke@gmail.com>,
	David Lonie <loniedavid@gmail.com>, linux-media@vger.kernel.org
Subject: Re: KWorld ATSC 115 all static  ... Mike's clarification
References: <7994.62.70.2.252.1232028088.squirrel@webmail.xs4all.nl> <496FE555.7090405@rogers.com> <496FFCE2.8010902@rogers.com> <200901171720.03890.hverkuil@xs4all.nl> <49737088.7060800@rogers.com> <20090202235820.GA9781@opus.istwok.net> <4987DE4E.2090902@rogers.com> <49884E67.4090003@linuxtv.org>
In-Reply-To: <49884E67.4090003@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CityK wrote:
> CityK wrote:
>   
>> Hans wrote:
>>     
>>> CityK wrote:
>>>     
>>>       
>>>> In regards to the tuner type being set twice, that is precisely my point
>>>> -- its peculiar and not symptomatic of normal behaviour.  That is why I
>>>> asked whether you expected it to do this    
>>>>       
>>>>         
>>> I think it is OK. The second setup is probably done by dvb_attach() in 
>>> saa7134-dvb.c, line 1191. Can you verify that with a debug message?  
>>>     
>>>       
>> Could not verify.  (dmesg output provided below at end).
>>   
>>     
>
> Actually, looking at the dmesg output now, it is apparent that you are
> correct:
>
> dvb_init() allocating 1 frontend
>
> So, its a case of a bit of redundancy now.

Michael Krufky wrote:
> CityK wrote:
>> - Hans' second attempt at this is found in his v4l-dvb-kworld test
>> repo... testing this code revealed that analog tv did indeed work
>> again withtvtime ... I also noted that there seems to be a bit of
>> redundancy nowin terms of the tuner being initialized twice
>>
>> ... [snip]...
>>
>> - Hans kworld repo:
>> Pros: does provide analog tv functionality for, at a minimum, tvtime.
>> Cons: The changes introduced result in, as testing to date has shown, a
>> harmless bit of duplication in the way of the tuner being loaded twice.
>> kdetv/motv/xawtv, at a minimum, do not work in overlay mode.  
>
> Tuner is _not_ loaded twice.  The tuner-simple driver is displaying
> itself twice in the dmesg logs, because it is attached twice. 

I actually knew that, but as a consequence of writing a long reply, late
at night, I wasn't fully coherent in my faculties and ended up
misreporting the case.

> Once for analog, again for digital -- this is *by design*.
>
> The old code used dvb-pll for the digital side, and tuner-simple for
> analog.  The common support within those two modules has been merged
> together to remove redundancy and allow us to share state between the
> two instances of the driver for the same part.
>
> As tuner-simple registers each side of the interface, it will display
> a message to the kernel logs indicating what tuner has been attached
> -- this is what you see twice.

Mike, thanks for the clarification that the behaviour is intended by
design. And looking at the events in conjunction with the above
explanation, it all makes sense:

tuner 1-0061: chip found @ 0xc2 (saa7133[0])
tuner-simple 1-0061: creating new instance
tuner-simple 1-0061: type set to 68 (Philips TUV1236D ATSC/NTSC dual in)
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
dvb_init() allocating 1 frontend
nxt200x: NXT2004 Detected
tuner-simple 1-0061: attaching existing instance
tuner-simple 1-0061: type set to 68 (Philips TUV1236D ATSC/NTSC dual in)

 
hermann pitton wrote:
> For the second attach of hybrid tuners in digital mode we maybe should print something
> pointing to it.
>   

Yes, I agree -- adding something simple to the existing message here
might help any future cases of head-scratching by those less
knowledgeable of the intricacies.
