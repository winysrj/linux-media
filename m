Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m42BUA5U029857
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 07:30:10 -0400
Received: from mail.uni-paderborn.de (mail.uni-paderborn.de [131.234.142.9])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m42BTuq0002970
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 07:29:56 -0400
Message-ID: <481AFB30.5070508@hni.uni-paderborn.de>
Date: Fri, 02 May 2008 13:29:52 +0200
From: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <48030F6F.1040007@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0804142224570.5332@axis700.grange>
	<480477BD.5090900@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0804151228370.5159@axis700.grange>
	<481ADED1.8050201@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0805021143250.4920@axis700.grange>
	<481AF6CA.9030505@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0805021314510.4920@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0805021314510.4920@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: OmniVision OV9655 camera chip via soc-camera interface
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
> On Fri, 2 May 2008, Stefan Herbrechtsmeier wrote:
>
>   
>> Guennadi Liakhovetski schrieb:
>>     
>>>> 3. Add x_skip_left to soc_camera_device
>>>> The pxa_camera has to skip some pixel at the begin of each line if a HSYNC
>>>> signal is used.
>>>> (y_skip_top and x_skip_left can change with each format adjustment!)
>>>>     
>>>>         
>>> How and why shall they change?
>>>   
>>>       
>> They shall change to support both signal types and to make the names and
>> function clear. The OmniVision chips
>> support both types and you can configure the VSYNC pin. At the moment I used
>> SOCAM_HSYNC_*
>> but configure the chip to use HREF to work without pixel skipping.
>>     
>
> Sorry, I mean why y_skip_top and x_skip_left shall change?
>
>   
At the time I used VSYNC (without x_skip_left) I have different number 
of empty pixels
at the begin of each line for different resolutions. But I haven't 
really evaluate this.

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
