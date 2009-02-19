Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1JDOoIh010791
	for <video4linux-list@redhat.com>; Thu, 19 Feb 2009 08:24:50 -0500
Received: from mtaout01-winn.ispmail.ntl.com (mtaout01-winn.ispmail.ntl.com
	[81.103.221.47])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n1JDNRdP026229
	for <video4linux-list@redhat.com>; Thu, 19 Feb 2009 08:24:12 -0500
Message-ID: <499D5D4C.8070803@tesco.net>
Date: Thu, 19 Feb 2009 13:23:24 +0000
From: John Pilkington <J.Pilk@tesco.net>
MIME-Version: 1.0
To: v4l_list <video4linux-list@redhat.com>,
	hermann pitton <hermann-pitton@arcor.de>
References: <498C3AD4.1070907@tesco.net>	
	<1233958764.2466.72.camel@pc10.localdom.local>
	<4990B315.8000309@tesco.net>	
	<1234228256.3932.15.camel@pc10.localdom.local>
	<499C0E76.9000907@tesco.net>
	<1235000333.2486.35.camel@pc10.localdom.local>
	<499D4FD2.6010503@tesco.net>
In-Reply-To: <499D4FD2.6010503@tesco.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: 
Subject: Re: Hauppauge HVR-1110 analog audio problem - success
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

John Pilkington wrote:
> hermann pitton wrote:
>> Am Mittwoch, den 18.02.2009, 13:34 +0000 schrieb John Pilkington:
>>> < older stuff deleted>
> 
>>
>> tvtime -v --device=/dev/video2 and then
>> "sox -c 2 -s -w -r 32000 -t ossdsp /dev/dsp3 -t ossdsp -w -r 32000 
>> /dev/dsp"
> 
> [John@gateway ~]$ sox -c 2 -s -w -r 32000 -t ossdsp /dev/dsp3 -t ossdsp 
> -w -r 32000 /dev/dsp
> sox: invalid option -- 'w'
> sox: SoX v14.2.0
> 
> Failed: invalid option
> 
> 
> Hi Hermann, and thanks again. My card shows up as /dev/video0, but the 
> sox produces this. I got it before and wonder why?  I can't find a 
> sensible-looking instance of -w in my docs or on the sox site.  Is it a 
> switch to pcm, is it tied to oss?
> 
> Cheers, John

It works in tvtime, antenna and composite, with

> sox -c 2 -s -u -r 32000 -t ossdsp /dev/dsp1 -t ossdsp -u -r 32000 /dev/dsp

Maybe the alsa-plugins-oss helped.  More experiments still to do, but it 
does work.

Thanks a lot!!

John





--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
