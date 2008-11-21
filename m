Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mALKrV2S026459
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 15:53:31 -0500
Received: from smtp1-g19.free.fr (smtp1-g19.free.fr [212.27.42.27])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mALKrIji031578
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 15:53:18 -0500
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <Pine.LNX.4.64.0811181945410.8628@axis700.grange>
	<Pine.LNX.4.64.0811182010460.8628@axis700.grange>
	<87y6zf76aw.fsf@free.fr>
	<Pine.LNX.4.64.0811202055210.8290@axis700.grange>
	<8763mg28bf.fsf@free.fr>
	<Pine.LNX.4.64.0811212051360.8956@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Fri, 21 Nov 2008 21:53:16 +0100
In-Reply-To: <Pine.LNX.4.64.0811212051360.8956@axis700.grange> (Guennadi
	Liakhovetski's message of "Fri\,
	21 Nov 2008 21\:03\:23 +0100 \(CET\)")
Message-ID: <878wrcztqb.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 2/2 v3] pxa-camera: pixel format negotiation
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

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

>> > Yes, I do not know how to pass a 16-bit format in a pass-through mode, and 
>> > I don't have a test-case for it. Do you?
>> BYR2 I think (12bit Bayer in 16bit words), and Bxxx (10bit Bayer in 16bit
>> words).
>> 
>> And I can test the 10bit Bayer on 16bit words on mt9m111, and will do.
>
> Wait, don't understand. 10-bit Bayer should have depth = 10, so it will 
> pass. 12-bit Bayer will have depth 12 and will not pass, and I do not know 
> how we can accept it on PXA27x.
I should have been clearer.

It's called 8+2 bypass Bayer. Here is the layout :
 - first byte : <B9, B8, B7, B6, B5, B4, B3, B2>
 - second byte : <0, 0, 0, 0, 0, 0, B1, B0>
 => 2 bytes of 8 bits are sent over 8 bits of QIF interface
 => gives a Bayer Code of <0, 0, 0, 0, 0, 0, B9 - B0>

I think it is documented in Micron MT9M111 datasheet, table 6, page 14.
My understanding is that it has a buswidth=8, and depth=16. But I may be wrong,
have a look with your trained eye and tell me please.

> Good, I think, we can use the next week, as long as Linus is scuba 
> diving, to finish this transition:-)
Lucky him :) It's rainy, snowy here ... but ... it gives time to write code :)

Cheers.

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
