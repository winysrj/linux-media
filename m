Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5EBuPtY007648
	for <video4linux-list@redhat.com>; Sat, 14 Jun 2008 07:56:25 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5EBuD7O019801
	for <video4linux-list@redhat.com>; Sat, 14 Jun 2008 07:56:13 -0400
Received: from [192.168.1.2] (02-194.155.popsite.net [66.217.132.194])
	(authenticated bits=0)
	by mail1.radix.net (8.13.4/8.13.4) with ESMTP id m5EBuBHN024275
	for <video4linux-list@redhat.com>; Sat, 14 Jun 2008 07:56:12 -0400 (EDT)
From: Andy Walls <awalls@radix.net>
To: video4linux-list@redhat.com
In-Reply-To: <4853745E.6000805@satland.com.pl>
References: <4853745E.6000805@satland.com.pl>
Content-Type: text/plain; charset=UTF-8
Date: Sat, 14 Jun 2008 07:55:47 -0400
Message-Id: <1213444547.3173.4.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: multiple saa7130 chipsets problem
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

On Sat, 2008-06-14 at 09:33 +0200, Łukasz Łukojć wrote:
> Hi
> 
> I'm using 8 x saa7130hl chipset  based surveillance card and recently 
> bought another one.
> Just wanted to achieve 16 channels for cams recording.
> Problem is that saa7134 module will only see eight integrals of card 
> array 'card=x,x,x,x,x,x,x,x' and while i'm putting 
> 'card=x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x' - dmesg will print 
> 
> card: can only take 8 arguments
> saa734: '69' invalid for parameter 'card'
> 
> Modprobing with 'only' eight parameters will result that saa714 will be 
> try to autodetect chipsets, which is appraently ends with hang errors.
> Is there a siple hack to ovverride this behaviour ?

You could try modifying

	#define SAA7134_MAXBOARDS 8

in linux/drivers/media/video/saa7134/saa7134.h and recompiling.

-Andy

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
