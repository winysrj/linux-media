Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3H0lK84027430
	for <video4linux-list@redhat.com>; Wed, 16 Apr 2008 20:47:20 -0400
Received: from ti-out-0910.google.com (ti-out-0910.google.com [209.85.142.184])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3H0l9DL026672
	for <video4linux-list@redhat.com>; Wed, 16 Apr 2008 20:47:09 -0400
Received: by ti-out-0910.google.com with SMTP id 11so848339tim.7
	for <video4linux-list@redhat.com>; Wed, 16 Apr 2008 17:47:08 -0700 (PDT)
Message-ID: <998e4a820804161747m6d8377b1k7481aaff7d081259@mail.gmail.com>
Date: Thu, 17 Apr 2008 08:47:08 +0800
From: "=?GB2312?B?t+v2zg==?=" <fengxin215@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0804132124100.6622@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Disposition: inline
References: <998e4a820804040811l748bd5b7tedf7a50521ff449e@mail.gmail.com>
	<Pine.LNX.4.64.0804071322490.5585@axis700.grange>
	<998e4a820804071849s60e883f9ne2d8ad6a2f48bd42@mail.gmail.com>
	<Pine.LNX.4.64.0804090104190.4987@axis700.grange>
	<998e4a820804081827j5379efdfw3a95dd1731e02e42@mail.gmail.com>
	<Pine.LNX.4.64.0804091616470.5671@axis700.grange>
	<998e4a820804092242i8ead476nf7e4db3712bc881@mail.gmail.com>
	<Pine.LNX.4.64.0804100749310.3693@axis700.grange>
	<998e4a820804101854l77e702d9j78d16afc59d807a@mail.gmail.com>
	<Pine.LNX.4.64.0804132124100.6622@axis700.grange>
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: question for soc-camera driver
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

2008/4/14 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
>>  I found the problem with reversed frame order. The same problem led to
>>  corrupted frames. Please try the patch below on the top of the previous
>>  one. With it I have no more problems with the test application with any
>>  number of buffers.

2008/4/14 ·ëöÎ <fengxin215@gmail.com>:
>  I test it and It is good.But some frames is dropped,like
>  1,2,3,4,5,8,9,10,11,14,15,16,17,18,21,22.The frame 6,7,12,13,19,20 is
>  dropped.I request 4 buffers now.

Will you improve soc-camera driver for the lost frames?

Thanks
fengxin

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
