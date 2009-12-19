Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx05.extmail.prod.ext.phx2.redhat.com
	[10.5.110.9])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nBJBlCRx004714
	for <video4linux-list@redhat.com>; Sat, 19 Dec 2009 06:47:12 -0500
Received: from proxy1.bredband.net (proxy1.bredband.net [195.54.101.71])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nBJBkwfp010095
	for <video4linux-list@redhat.com>; Sat, 19 Dec 2009 06:46:59 -0500
Received: from ipb2.telenor.se (195.54.127.165) by proxy1.bredband.net
	(7.3.140.3) id 4AD3E1C001D63D1E for video4linux-list@redhat.com;
	Sat, 19 Dec 2009 12:46:58 +0100
Message-ID: <4B2CBD2B.4080706@home.se>
Date: Sat, 19 Dec 2009 12:46:51 +0100
From: Andreas Lunderhage <lunderhage@home.se>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
References: <4B268C96.2020605@home.se>
	<829197380912141134o49ec613du97600464c23fe49@mail.gmail.com>
In-Reply-To: <829197380912141134o49ec613du97600464c23fe49@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Pinnacle Hybrid Pro Stick USB scan problems
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

There is a missing header file in the repo...

/home/lunderhage/v4l-dvb/v4l/radio-miropcm20.c:20:23: error: 
sound/aci.h: No such file or directory

Can someone push that file into the repo or send it to me, please?

BR
/Andreas

Devin Heitmueller wrote:
> On Mon, Dec 14, 2009 at 2:05 PM, Andreas Lunderhage <lunderhage@home.se> wrote:
>   
>> Hi,
>>
>> I have problems scanning with my Pinnacle Hybrid Pro Stick (320E). When
>> using the scan command, it finds the channels in the first mux in the mux
>> file but it fails to tune the next ones. If I use Kaffeine to scan, it gives
>> the same result but I can also see that the signal strength shows 99% on
>> those muxes it fails to scan.
>>
>> I thinks this is a problem with the tuning since if I watch one channel and
>> switch to another (on another mux), it fails to tune. If I stop the viewing
>> of the current channel first, then it will succeed tuning the next.
>>
>> I'm running Ubuntu 9.04 32-bit (kernel 2.6.28-17-generic) with the code
>> built from the repository today.
>> I'm also running Ubuntu 9.10 64-bit (kernel 2.6.31-16) (on another machine),
>> but it gives the same problem.
>>     
>
> First, make sure you are running the latest v4l-dvb code (instructions
> at http://linuxtv.org/repo), and then try commenting out line 181 of
> em28xx-cards.c and see if that fixes the issue.
>
> Devin
>
>   

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
