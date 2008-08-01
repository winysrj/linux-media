Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m718FtIv024080
	for <video4linux-list@redhat.com>; Fri, 1 Aug 2008 04:15:55 -0400
Received: from mail.uni-paderborn.de (mail.uni-paderborn.de [131.234.142.9])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m718Ffd1022112
	for <video4linux-list@redhat.com>; Fri, 1 Aug 2008 04:15:41 -0400
Message-ID: <4892C629.5000208@hni.uni-paderborn.de>
Date: Fri, 01 Aug 2008 10:15:37 +0200
From: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <294f0a37c4feadf87bf8.1217484144@carolinen.hni.uni-paderborn.de>
	<48917CB5.6000304@teltonika.lt>
	<4892A90B.7080309@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0808010820560.14927@axis700.grange>
	<4892BCD8.4010102@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0808010940400.14927@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0808010940400.14927@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Subject: Re: [PATCH] Move .power and .reset from soc_camera platform to
 sensor driver
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
> On Fri, 1 Aug 2008, Stefan Herbrechtsmeier wrote:
>
>   
>> Guennadi Liakhovetski schrieb:
>>     
>>> As for calling either platform-provided reset or internal one. Actually,
>>> whyt about making platform reset (and power too) return an error code, and
>>> if it failed call th internal one? 
>>>       
>> At the moment I assume that reset and power will work, if they are defined,
>> but we can change it.
>>     
>
> I'd rather preserve the possibility to use "soft" reset / poweroff also 
> when a platform function is defined. In fact, it might be even better to 
> do a soft power-off first and then call platform-provided one. Don't think 
> it would make much sense for reset though.
>   
You are right, I'll change it with the next version.
>   
>>> And as a parameter wouldn't it make more sense to pass the soc_camera_link
>>> to the platform functions instead of the struct device from the i2c device?
>>>   
>>>       
>> I have simple make the function similar to other platform_data functions on my
>> system.
>> At the moment I use the parameter only for printing messages via dev_err.
>>     
>
> You have to be able to trace which camera has to be resetted / powered on 
> or off in your platform code, and the camera_link structure is the object 
> that identifies a specific camera, ot, at least, it can be. Whereas the 
> device pointer doesn't easily tell you which camera you want to operate 
> upon.
>   
If you use the same function for different sensors (camera_links), you 
are right,
but you can get the camera_link from the dev pointer (.platform_data) if you
need it.

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
