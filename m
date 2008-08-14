Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7E6bidI010204
	for <video4linux-list@redhat.com>; Thu, 14 Aug 2008 02:37:44 -0400
Received: from mail.uni-paderborn.de (mail.uni-paderborn.de [131.234.142.9])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7E6bUnN018832
	for <video4linux-list@redhat.com>; Thu, 14 Aug 2008 02:37:30 -0400
Message-ID: <48A3D2A6.50905@hni.uni-paderborn.de>
Date: Thu, 14 Aug 2008 08:37:26 +0200
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
	<48A3CD0F.9050509@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0808140820580.13783@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0808140820580.13783@axis700.grange>
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
>> The GPIOs belongs to the camera. One GPIO for the camera reset input and one
>> for the power down
>> input of the camera.
>>     
>
> Ok, then don't you want to keep the camera off even if the driver is not 
> configured or not loaded at all? Why don't you configure those GPIOs in 
> your platform code permanently, you can make it dependent on 
> defined(CONFIG_...) || defined(CONFIG_..._MODULE), and then just let power 
> and reset callbacks toggle them without reconfiguring them ever again?
>   
I move the GPIOs init code to platform code. Thus your patch is complete 
ok for me. ;-)

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
