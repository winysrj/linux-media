Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m83JCSC1010360
	for <video4linux-list@redhat.com>; Wed, 3 Sep 2008 15:12:28 -0400
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.178])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m83JCEQM022072
	for <video4linux-list@redhat.com>; Wed, 3 Sep 2008 15:12:14 -0400
Received: by py-out-1112.google.com with SMTP id a29so1679432pyi.0
	for <video4linux-list@redhat.com>; Wed, 03 Sep 2008 12:12:14 -0700 (PDT)
Message-ID: <48BEE1A2.9040005@hotmail.com>
Date: Wed, 03 Sep 2008 12:12:34 -0700
From: Lee Alkureishi <lee_alkureishi@hotmail.com>
MIME-Version: 1.0
To: Douglas Schilling Landgraf <dougsland@gmail.com>
References: <BAY126-W51445FEADC96EC0484E7ABE35D0@phx.gbl>	<20080901110337.442e207e@mchehab.chehab.org>	<BAY126-W60A14086F5E15F9DE62FA0E35C0@phx.gbl>
	<20080902113025.336f2514@gmail.com>
In-Reply-To: <20080902113025.336f2514@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: em2820, Tena TNF-9533 and V4L
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

Dear all,

Thank you for the suggestions, but I think this has taken up too much of 
my time already. I wish I had contacted this list sooner, as I spent 
considerable time muddling through based on googling the device.

I followed Douglas's link to build the v4l-dvb sources, but am now 
getting fatal errors when I try to modprobe the em28xx module. I tried 
to follow the ubuntu 8.04-specific fix instructions, but to no avail.

I took the plunge and bought an ATI HDTV wonder, and will receive it in 
a few days. I very much hope that setting this up is considerably easier 
that the USB 2800RF.

I am a bit worried that all the messing around with linux headers, 
sources and the v4l packages may upset the installation of my new card, 
though. If someone could please describe how to get back close to a 
"virgin" state i.e. completely remove v4l, modules and reinstall from 
scratch, I'd be very grateful.

Sorry I can't devote more time to this - I know how important it is to 
the community as a whole to improve legacy hardware support.

Best regards, and thanks again,

Lee







Douglas Schilling Landgraf wrote:
> Hello Lee, 
>
> On Tue, 2 Sep 2008 00:10:12 +0100
> Lee Alkureishi <lee_alkureishi@hotmail.com> wrote:
>
>   
>> Dear Mauro,
>>
>> Thanks for the response. I've done as Markus suggested (reinstalled
>> my kernel, rebooted, then copy-pasted the lines to hg clone the
>> correct driver folder). I then tried to access the
>> tuner/composite/svideo, but am still not getting anything. 
>>     
>
> Before we go further, I suggest you to use upstream driver.
>
> Additional info who to build v4l-dvb sources:
> http://www.linuxtv.org/v4lwiki/index.php/How_to_build_from_Mercurial
>  
>   
>> I tried as you suggested, using usbview as a snoop tool to find out
>> more about my board. Here is the output:
>>     
>
> Could you log your device using usbsnoop tool?
>
> Additional info: 
> http://www.linuxtv.org/v4lwiki/index.php/Usbsnoop
>
> Cheers,
> Douglas
>
>
>   

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
