Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m671AKFe016125
	for <video4linux-list@redhat.com>; Sun, 6 Jul 2008 21:10:20 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.170])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m671A8wX001846
	for <video4linux-list@redhat.com>; Sun, 6 Jul 2008 21:10:09 -0400
Received: by wf-out-1314.google.com with SMTP id 25so1879739wfc.6
	for <video4linux-list@redhat.com>; Sun, 06 Jul 2008 18:10:08 -0700 (PDT)
Message-ID: <48716CED.6010608@gmail.com>
Date: Sun, 06 Jul 2008 17:10:05 -0800
From: D <therealisttruest@gmail.com>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
References: <486FF148.2060506@gmail.com>	
	<1215298086.3237.19.camel@pc10.localdom.local>
	<48700079.6000209@gmail.com>	 <48701944.2040200@gmail.com>
	<1215343839.2852.14.camel@pc10.localdom.local>
In-Reply-To: <1215343839.2852.14.camel@pc10.localdom.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Help with Chinese card
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


> "garbled video" can mean lots of different things.
> Black and white only would be simplest, since indicating some wrong
> vmux.
>
>   
When I added card 145, I did have one of the 8 cameras that are set up 
showing grainy, black and white video with a very bad jitter to it(this 
was using ntsc, not pal). This was with vmux=2 I believe. I tried 0,1, 
and 3 as well just to see if it was a bit off, but only ended up with 
black output. The other videos were black as well, even though there 
should have been video in at least one or two others.
>>> [44494.080206] saa7134:   card=145 -> AOPVision AOP-8008A 16CH/240fps 
>>> Capture
>>> [44494.080210] saa7130[0]: subsystem: 1131:0000, board: 
>>> UNKNOWN/GENERIC [card=0,autodetected]
>>> [44494.080220] saa7130[0]: board init: gpio is c013ef0
>>>       
>                                            ^^^^^^^^^^^^^^^
>
> In such a case, this is the only indication if it might have been seen
> already previously. 
>
> If this is after a boot prior to mess around with other card entries or
> trying something yourself on gpios, it looks like this device was not
> seen yet then.
>
>   
>>> [44494.807913] saa7134:   card=145 -> AOPVision AOP-8008A 16CH/240fps 
>>> Capture
>>> [44494.807917] saa7130[7]: subsystem: 1131:0000, board: 
>>> UNKNOWN/GENERIC [card=0,autodetected]
>>> [44494.807930] saa7130[7]: board init: gpio is 10000
>>>       
>                    ^^^^^^^^^^              ^^^^^^^^^^^^^
> Seems to be still unique here.
>   
As far as autodetection goes, when I originally started working on this, 
it was card number 0, by default. What I did above to get it back to 
that point was modprobe saa7134, without the 'card=' argument, so that 
tells me it doesn't autodetect it correctly or recognize it. As I said 
before card number 145 is my own, but it's not correct either. Do you 
have any tips on what I can do next. I know this card is not yet 
supported as is, but would like to get it working and perhaps get 
support added to it for other users in the future.  My idea was to 
change the gpio values, but it sounds like that could be a problem 
unless I can find what the correct values are. Any ideas? I'm willing to 
do what I can, but I need some guidance on this one.

Thanks much,
Daniel
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
