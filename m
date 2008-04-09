Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m395X9Es015824
	for <video4linux-list@redhat.com>; Wed, 9 Apr 2008 01:33:09 -0400
Received: from mxout10.netvision.net.il (mxout10.netvision.net.il
	[194.90.6.38])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m395Wn6P010635
	for <video4linux-list@redhat.com>; Wed, 9 Apr 2008 01:32:49 -0400
Received: from mail.linux-boards.com ([62.90.235.247])
	by mxout10.netvision.net.il
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0JZ100I74M6CXX50@mxout10.netvision.net.il> for
	video4linux-list@redhat.com; Wed, 09 Apr 2008 08:35:00 +0300 (IDT)
Date: Wed, 09 Apr 2008 08:32:41 +0300
From: Mike Rapoport <mike@compulab.co.il>
In-reply-to: <Pine.LNX.4.64.0804081729040.4987@axis700.grange>
To: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Message-id: <47FC54F9.1020300@compulab.co.il>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <47FB0742.1060000@compulab.co.il>
	<Pine.LNX.4.64.0804081729040.4987@axis700.grange>
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: PATCH v2] pxa_camera: Add support for YUV modes
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



Guennadi Liakhovetski wrote:
> On Tue, 8 Apr 2008, Mike Rapoport wrote:
> 
>> +		struct pxa_cam_dma *buf_dma;
>> +		struct pxa_cam_dma *act_dma;
>> +		int channels = 1;
>> +		int nents;
>> +		int i;
>> +
>> +		if (buf->fmt->fourcc == V4L2_PIX_FMT_YUV422P)
>> +			channels = 3;
>> +
>> +		for (i = 0; i < channels; i++) {
>> +			buf_dma = &buf->dmas[i];
>> +			act_dma = &active->dmas[0];
> 
> 					   ^^^^^^^
> 
> Just came across this accidentally, is the "[0]" above correct?

It should be "[i]" ...

> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski
> 

-- 
Sincerely yours,
Mike.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
