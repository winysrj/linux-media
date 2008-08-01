Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m718Ow4b028116
	for <video4linux-list@redhat.com>; Fri, 1 Aug 2008 04:24:58 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m718Okvc026524
	for <video4linux-list@redhat.com>; Fri, 1 Aug 2008 04:24:46 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KOpwH-0002i7-Mn
	for video4linux-list@redhat.com; Fri, 01 Aug 2008 08:24:41 +0000
Received: from 82-135-208-232.static.zebra.lt ([82.135.208.232])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Fri, 01 Aug 2008 08:24:41 +0000
Received: from paulius.zaleckas by 82-135-208-232.static.zebra.lt with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Fri, 01 Aug 2008 08:24:41 +0000
To: video4linux-list@redhat.com
From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Date: Fri, 01 Aug 2008 11:24:35 +0300
Message-ID: <4892C843.3030601@teltonika.lt>
References: <294f0a37c4feadf87bf8.1217484144@carolinen.hni.uni-paderborn.de>	<48917CB5.6000304@teltonika.lt>
	<4892A90B.7080309@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0808010820560.14927@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <Pine.LNX.4.64.0808010820560.14927@axis700.grange>
Cc: 
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

Guennadi Liakhovetski wrote:
> On Fri, 1 Aug 2008, Stefan Herbrechtsmeier wrote:
> 
>> Paulius Zaleckas schrieb:
>>> Stefan Herbrechtsmeier wrote:
>>>> Move .power (enable_camera, disable_camera) and .reset from soc_camera
>>>> platform driver (pxa_camera_platform_data, sh_mobile_ceu_info) to sensor
>>>> driver (soc_camera_link) and add .init and .release to request and free
>>>> gpios.
>>>>
>>>> Signed-off-by: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
>>> While I agree that it is good to move .power and .reset to
>>> soc_camera_link... IMHO controlling of these should be left in
>>> host driver.
>> How should we deal with the register based version of this functions (soft
>> reset)?
>> At the moment we reset the sensors twice, if we use a hardware reset (.reset).
> 
> Paulius, can you give any specific reason why you think, calling those 
> functions from the host driver would be better?

I have changed my mind :)
But I think sensor driver should also control mclk activation.
This is because some sensors (in my case OV7670) needs mclk all the time
running to produce images with good white balance in open-capture-close
scenario. Currently I have a patch for soc_camera which leaves the
camera activated after probing...

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
