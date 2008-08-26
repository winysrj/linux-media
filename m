Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7QIZHio013854
	for <video4linux-list@redhat.com>; Tue, 26 Aug 2008 14:35:18 -0400
Received: from smtp-out4.blueyonder.co.uk (smtp-out4.blueyonder.co.uk
	[195.188.213.7])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7QIZ0XL009801
	for <video4linux-list@redhat.com>; Tue, 26 Aug 2008 14:35:00 -0400
Message-ID: <48B44CDF.60903@blueyonder.co.uk>
Date: Tue, 26 Aug 2008 19:35:11 +0100
From: Ian Davidson <id012c3076@blueyonder.co.uk>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
References: <488C9266.7010108@blueyonder.co.uk>	<1217364178.2699.17.camel@pc10.localdom.local>	<4890BBE8.8000901@blueyonder.co.uk>	<1217457895.4433.52.camel@pc10.localdom.local>	<48921FF9.8040504@blueyonder.co.uk>	<1217542190.3272.106.camel@pc10.localdom.local>	<48942E42.5040207@blueyonder.co.uk>	<1217679767.3304.30.camel@pc10.localdom.local>	<4895D741.1020906@blueyonder.co.uk>	<1217798899.2676.148.camel@pc10.localdom.local>	<4898C258.4040004@blueyonder.co.uk>
	<489A0B01.8020901@blueyonder.co.uk>	<1218059636.4157.21.camel@pc10.localdom.local>	<489B6E1B.301@blueyonder.co.uk>	<1218153337.8481.30.camel@pc10.localdom.local>	<489D7781.8030007@blueyonder.co.uk>	<1218474259.2676.42.camel@pc10.localdom.local>	<48A8892F.1010900@blueyonder.co.uk>
	<1219024648.2677.20.camel@pc10.localdom.local>
In-Reply-To: <1219024648.2677.20.camel@pc10.localdom.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: KWorld DVB-T 210SE - Capture only in Black/White
Reply-To: ian.davidson@bigfoot.com
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

Arrrrgh!

My capture has gone back to Black and White.

Since being able to capture video in colour, I have been attempting to 
install mjpegtools.  Today, having been pointed at the livna repository, 
I have succeeded.  When I tried a video capture (for regression testing 
purposes), I found that it was, once again, Black and White.

Having said that, I get occasional glimpses of colour - and when I do, 
it is the real colour of whatever the camera is pointing at.  Having 
made a brief study, it would seem that occasional frames get colour at 
the top half of the picture.  I have checked (broken and reconnected) 
the connections between the camera and the computer, but is does not 
seem to make any difference.

Any ideas where I go from here?

Ian





hermann pitton wrote:
> Hi Ian,
>
> Am Sonntag, den 17.08.2008, 21:25 +0100 schrieb Ian Davidson:
>   
>> Hi Hermann,
>>
>> Success.  I did nothing of any significance.  What I did do was to add 
>> some more lines to saa7134-cards.c (to add vmux 5, 6 and 7) - and then 
>> went through the make process again.
>>
>> Then, I ran xawtv and started by selecting Composite1 - and I got a 
>> colour image.
>>
>> I also ran streamer to capture the video signal (using Composite1) and 
>> that also captured a colour image.
>>
>> I hope it stays that way.
>>
>> One other question - but this is probably not the correct place to ask. 
>> In the 'help' for streamer, it describes the use of 'lav2wav' to strip 
>> the audio out of a video file (that is, to create a separate WAV file 
>> using the audio in a particular AVI file).  I do not seem to have 
>> lav2wav on my system - and it does not appear to be something that yum 
>> acknowledges (using Fedora repositories).  Where might I find lav2wav or 
>> something similar?
>>
>> Ian
>>
>>     
>
> as I told you previously already, please stay on the lists.
>
> I don't even have a minimum consense about how to submit 5 to 7 patches
> currently within a kernel release cycle, but I'm very sure about that I
> don't like to be included in 24/7 games and would expect at least kernel
> level agreements for contributions still valid. Mauro?
>
> So, you are on your own to get it in and further, but people on the
> lists are always helpful.
>
> Cheers,
> Hermannn
>
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>   

-- 
Ian Davidson
239 Streetsbrook Road, Solihull, West Midlands, B91 1HE
-- 
Facts used in this message may or may not reflect an underlying objective reality. 
Facts are supplied for personal use only. 
Recipients quoting supplied information do so at their own risk. 
Facts supplied may vary in whole or part from widely accepted standards. 
While painstakingly researched, facts may or may not be indicative of actually occurring events or natural phenomena. 
The author accepts no responsibility for personal loss or injury resulting from memorisation and subsequent use.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
