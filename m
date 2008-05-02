Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m42CAbla019355
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 08:10:37 -0400
Received: from mail.uni-paderborn.de (mail.uni-paderborn.de [131.234.142.9])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m42CAPom023232
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 08:10:25 -0400
Message-ID: <481B04AE.8020609@hni.uni-paderborn.de>
Date: Fri, 02 May 2008 14:10:22 +0200
From: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <4811F4EE.9060409@hni.uni-paderborn.de>	<Pine.LNX.4.64.0804281604400.7897@axis700.grange>	<481AE400.8090709@hni.uni-paderborn.de>	<Pine.LNX.4.64.0805021156400.4920@axis700.grange>
	<481AF860.9060603@hni.uni-paderborn.de>
In-Reply-To: <481AF860.9060603@hni.uni-paderborn.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: pxa_camera with one buffer don't work
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

Stefan Herbrechtsmeier schrieb:
> Guennadi Liakhovetski schrieb:
>> On Fri, 2 May 2008, Stefan Herbrechtsmeier wrote:
>>
>>  
>>> Guennadi Liakhovetski schrieb:
>>>    
>>>> On Fri, 25 Apr 2008, Stefan Herbrechtsmeier wrote:
>>>>
>>>>        
>>>>> Hi,
>>>>>
>>>>> is it normal, that the pxa_camera driver don`t work with one 
>>>>> buffer?. The
>>>>> DQBUF blocks if only one buffer is in the query.
>>>>>             
>>>> Well, in v4l2-apps/test/capture_example.c we see:
>>>>
>>>>     if (req.count < 2) {
>>>>         fprintf (stderr, "Insufficient buffer memory on %s\n",
>>>>              dev_name);
>>>>         exit (EXIT_FAILURE);
>>>>     }
>>>>
>>>> so, they seem to refuse to run with fewer than 2 buffers. But if I 
>>>> remove
>>>> this restriction and enforce 1 buffer, it works. 2.5 times slower, but
>>>> works.       
>>> If I do the same thing, I get a select timeout.
>>>     
>>
>> With the same capture_example.c?
>>   
> I used a modified capture_example.c (with the modification you point 
> me some emails ago). If I change the
> req.count to 1 and remove the restriction I get the select timeout.
I forget to say, that I use V4L2_PIX_FMT_YUYV

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
