Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7E4vl1I003223
	for <video4linux-list@redhat.com>; Thu, 14 Aug 2008 00:57:47 -0400
Received: from mail.uni-paderborn.de (mail.uni-paderborn.de [131.234.142.9])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7E4vXvJ003984
	for <video4linux-list@redhat.com>; Thu, 14 Aug 2008 00:57:33 -0400
Message-ID: <48A3BB38.7010301@hni.uni-paderborn.de>
Date: Thu, 14 Aug 2008 06:57:28 +0200
From: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <294f0a37c4feadf87bf8.1217484144@carolinen.hni.uni-paderborn.de>
	<48917CB5.6000304@teltonika.lt>
	<4892A90B.7080309@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0808010820560.14927@axis700.grange>
	<4892BCD8.4010102@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0808010940400.14927@axis700.grange>
	<4892C629.5000208@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0808131456140.5389@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0808131456140.5389@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Subject: Re: [PATCH] soc-camera: Move .power and .reset from soc_camera host
 to sensor driver
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

Guennadi Liakhovetski schrieb:
> Make .power and .reset callbacks per camera instead of per host, also move 
> their invocation to camera drivers.
>
> Signed-off-by: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>
> On Fri, 1 Aug 2008, Stefan Herbrechtsmeier wrote:
>   
>> Guennadi Liakhovetski schrieb:
>>     
>>> I'd rather preserve the possibility to use "soft" reset / poweroff also when
>>> a platform function is defined. In fact, it might be even better to do a
>>> soft power-off first and then call platform-provided one. Don't think it
>>> would make much sense for reset though.
>>>   
>>>       
>> You are right, I'll change it with the next version.
>>     
>
> How about the version below? I didn't understand why you need extra .init 
> and .release calls, so, I removed them for now. I think, .init per host 
> and power-on / off per camera should be enough for all init / release 
> needs, don't you think so
I use the .init call for gpio_request and gpio_direction_output and the 
.release call for gpio_free.
I do that this way, because I think they belongs more to the camera.

The patch looks ok for me.

Regards
    Stefan

-- 
Dipl.-Ing. Stefan Herbrechtsmeier

Heinz Nixdorf Institute
University of Paderborn 
System and Circuit Technology 
Fürstenallee 11
D-33102 Paderborn (Germany)

office : F0.415
phone  : + 49 5251 - 60 6342
fax    : + 49 5251 - 60 6351

mailto : hbmeier@hni.upb.de

www    : http://wwwhni.upb.de/sct/mitarbeiter/hbmeier


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
