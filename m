Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n37E49DI018105
	for <video4linux-list@redhat.com>; Tue, 7 Apr 2009 10:04:10 -0400
Received: from mail-qy0-f104.google.com (mail-qy0-f104.google.com
	[209.85.221.104])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n37E3X8d009534
	for <video4linux-list@redhat.com>; Tue, 7 Apr 2009 10:03:33 -0400
Received: by qyk2 with SMTP id 2so4667646qyk.23
	for <video4linux-list@redhat.com>; Tue, 07 Apr 2009 07:03:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49DB5046.8010608@australiaonline.net.au>
References: <49D20B0B.1030701@australiaonline.net.au>
	<49D227A3.5000601@linuxtv.org>
	<49D2FE07.5060906@australiaonline.net.au>
	<49D60DA2.5040904@australiaonline.net.au>
	<49DA0B1E.3010704@linuxtv.org>
	<412bdbff0904060716y44bd932cm81ca214425bdf355@mail.gmail.com>
	<49DB5046.8010608@australiaonline.net.au>
Date: Tue, 7 Apr 2009 10:03:33 -0400
Message-ID: <412bdbff0904070703p59adc34atc514387b54aa5597@mail.gmail.com>
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: john knops <jknops@australiaonline.net.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
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

On Tue, Apr 7, 2009 at 9:08 AM, john knops
<jknops@australiaonline.net.au> wrote:
>> Devin
>>
>> attached are complete dmesg outputs when using both 32bit & 64bit xc3028
>> extracted from HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip

Hello John,

Just to be clear, there is no "32 bit" versus "64 bit" version of the
firmware.  It's the same firmware.

I think Christopher is on the right track.  You should try out the
patch he sent and see if it helps.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
