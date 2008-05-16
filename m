Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4G8soEF010690
	for <video4linux-list@redhat.com>; Fri, 16 May 2008 04:54:50 -0400
Received: from mail.uni-paderborn.de (mail.uni-paderborn.de [131.234.142.9])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4G8sZWa005975
	for <video4linux-list@redhat.com>; Fri, 16 May 2008 04:54:36 -0400
Message-ID: <482D4BC7.7020409@hni.uni-paderborn.de>
Date: Fri, 16 May 2008 10:54:31 +0200
From: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <365592.144287319-sendEmail@carolinen>
	<Pine.LNX.4.64.0805061520250.5880@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0805061520250.5880@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Subject: Re: [PATCH] Add x_skip_left to soc_camera_device
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

Sorry for the late answer, but I have to rework my driver.

Guennadi Liakhovetski schrieb:
> I think, this is all we need for now - small and nice. Actually, it would 
> make even more sense to submit this when your new camera driver is ready, 
> but if you prefer, I'll accept it now. Just, please, resubmit it without 
> the above two hunks, and, maybe, add a sentence to the patch comment, 
> saying "will be used in xxx driver."
>   
Because of problems with the HSYNC support for different resolutions, I 
skipped it.
I remove the HSYNC specific code (configuration of HSYNC or HREF) and
only used HREF as signal. This makes this Patch obsolete for now.

Should I skip it or resubmit it for further use?

Thanks
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
