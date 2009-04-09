Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n39MNmcL017515
	for <video4linux-list@redhat.com>; Thu, 9 Apr 2009 18:23:48 -0400
Received: from smtp.ozonline.com.au (smtp.ozonline.com.au [203.4.248.46])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n39MNQtO025463
	for <video4linux-list@redhat.com>; Thu, 9 Apr 2009 18:23:28 -0400
Message-ID: <49DE7545.9020309@australiaonline.net.au>
Date: Fri, 10 Apr 2009 08:23:01 +1000
From: john knops <jknops@australiaonline.net.au>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <49D20B0B.1030701@australiaonline.net.au>	
	<49D227A3.5000601@linuxtv.org>	
	<49D2FE07.5060906@australiaonline.net.au>	
	<49D60DA2.5040904@australiaonline.net.au>	
	<49DA0B1E.3010704@linuxtv.org>	
	<412bdbff0904060716y44bd932cm81ca214425bdf355@mail.gmail.com>	
	<49DB5046.8010608@australiaonline.net.au>
	<412bdbff0904070703p59adc34atc514387b54aa5597@mail.gmail.com>
In-Reply-To: <412bdbff0904070703p59adc34atc514387b54aa5597@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: 
Subject: Re: No scan with DViCo FusionHDTV DVB-T Dual Express
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

Devin Heitmueller wrote:
> On Tue, Apr 7, 2009 at 9:08 AM, john knops
> <jknops@australiaonline.net.au> wrote:
>   
>>> Devin
>>>
>>> attached are complete dmesg outputs when using both 32bit & 64bit xc3028
>>> extracted from HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip
>>>       
>
> Hello John,
>
> Just to be clear, there is no "32 bit" versus "64 bit" version of the
> firmware.  It's the same firmware.
>
> I think Christopher is on the right track.  You should try out the
> patch he sent and see if it helps.
>
> Devin
>
> The patch did the trick! Sorry for the delay in replying but I wasn't too sure how to patch so I ressurected an old computer on which to practice.
Thankyou to All for your help and patience. It was very much appreciated.
John

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
