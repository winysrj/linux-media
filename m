Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7E6Dr9o000458
	for <video4linux-list@redhat.com>; Thu, 14 Aug 2008 02:13:53 -0400
Received: from mail.uni-paderborn.de (mail.uni-paderborn.de [131.234.142.9])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7E6DcrB007707
	for <video4linux-list@redhat.com>; Thu, 14 Aug 2008 02:13:39 -0400
Message-ID: <48A3CD0F.9050509@hni.uni-paderborn.de>
Date: Thu, 14 Aug 2008 08:13:35 +0200
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
	<48A3BB38.7010301@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0808140705550.12600@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0808140705550.12600@axis700.grange>
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
> On Thu, 14 Aug 2008, Stefan Herbrechtsmeier wrote:
>
>   
>> Guennadi Liakhovetski schrieb:
>>     
>>> How about the version below? I didn't understand why you need extra .init
>>> and .release calls, so, I removed them for now. I think, .init per host and
>>> power-on / off per camera should be enough for all init / release needs,
>>> don't you think so
>>>       
>> I use the .init call for gpio_request and gpio_direction_output and the
>> .release call for gpio_free.
>> I do that this way, because I think they belongs more to the camera.
>>     
>
> What are these GPIOs? Are they interfacing to a specific camera, or do 
> they belong to the camera-host interface? If they belong to a specific 
> camera, then yes, it is logical to control them from the camera driver 
> platform callbacks.
The GPIOs belongs to the camera. One GPIO for the camera reset input and 
one for the power down
input of the camera.
> But cannot you do this in .power? Just do the .init 
> part on power-on and the .release part on power-off?
>   
The driver need to control the power down input after power-off to hold 
the camera in power down mode.
Maybe I can free the gpio after power-off without changing the gpio 
value, but I think the use of .init and
.release call is better and more clearly. Do you think it is ok to free 
the gpio even if it must stay high?
>   
>> The patch looks ok for me.
>>     
>
> Well, if you cannot use it in this form without .init and .release then it 
> can hardly be called "ok" for you:-)
>   
I mean it is ok except the .init and .release part. ;-)

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
