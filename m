Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5HDcwVL013798
	for <video4linux-list@redhat.com>; Tue, 17 Jun 2008 09:38:58 -0400
Received: from mailmxout.mailmx.agnat.pl (mailmxout.mailmx.agnat.pl
	[193.239.44.238])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5HDcfZp007574
	for <video4linux-list@redhat.com>; Tue, 17 Jun 2008 09:38:42 -0400
Received: from smtp.agnat.pl ([193.239.44.82])
	by mailmxout.mailmx.agnat.pl with esmtp (Exim 4.69)
	(envelope-from <admin@satland.com.pl>) id 1K8bOS-0007Mz-DM
	for video4linux-list@redhat.com; Tue, 17 Jun 2008 15:38:40 +0200
Received: from [79.187.82.59] (helo=[192.168.0.5])
	by smtp.agnat.pl with esmtpsa (TLSv1:DHE-RSA-AES256-SHA:256)
	(Exim 4.67) (envelope-from <admin@satland.com.pl>)
	id 1K8bOS-0005Bi-7g
	for video4linux-list@redhat.com; Tue, 17 Jun 2008 15:38:40 +0200
Message-ID: <4857BE60.4000305@satland.com.pl>
Date: Tue, 17 Jun 2008 15:38:40 +0200
From: =?UTF-8?B?xYF1a2FzeiDFgXVrb2rEhw==?= <admin@satland.com.pl>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <4853745E.6000805@satland.com.pl>
	<1213444547.3173.4.camel@palomino.walls.org>
In-Reply-To: <1213444547.3173.4.camel@palomino.walls.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Subject: Re: Re: multiple saa7130 chipsets problem
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

Andy Walls pisze:
> On Sat, 2008-06-14 at 09:33 +0200, Łukasz Łukojć wrote:
>   
>> Hi
>>
>> I'm using 8 x saa7130hl chipset  based surveillance card and recently 
>> bought another one.
>> Just wanted to achieve 16 channels for cams recording.
>> Problem is that saa7134 module will only see eight integrals of card 
>> array 'card=x,x,x,x,x,x,x' and while i'm putting 
>> 'card=x,x,x,x,x,x,x,x,x,x,x,x,x,x,x' - dmesg will print 
>>
>> card: can only take 8 arguments
>> saa734: '69' invalid for parameter 'card'
>>
>> Modprobing with 'only' eight parameters will result that saa714 will be 
>> try to autodetect chipsets, which is appraently ends with hang errors.
>> Is there a siple hack to ovverride this behaviour ?
>>     
>
> You could try modifying
>
> 	#define SAA7134_MAXBOARDS 8
>
> in linux/drivers/media/video/saa7134/saa7134.h and recompiling.
>
> -Andy
>
>
>   
It did the trick :)
Now kernel seees two x eight channel cards, and i've '/dev/video*' from 
0 to 15

Thanks

Lucas

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
