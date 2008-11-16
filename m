Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAG1tXTi014241
	for <video4linux-list@redhat.com>; Sat, 15 Nov 2008 20:55:33 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mAG1tKDd028659
	for <video4linux-list@redhat.com>; Sat, 15 Nov 2008 20:55:21 -0500
Date: Sun, 16 Nov 2008 02:55:26 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <1226521783-19806-1-git-send-email-robert.jarzmik@free.fr>
Message-ID: <Pine.LNX.4.64.0811160142140.21494@axis700.grange>
References: <1226521783-19806-1-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: soc-camera: pixelfmt translation serie
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

Hi Robert,

On Wed, 12 Nov 2008, Robert Jarzmik wrote:

> Hi Guennadi,
> 
> This serie is prolongation of your work on the soc_camera
> bus driver. I reposted your serie within this one, so that
> this serie is a "whole", and can be applied on top of
> v2.6.28-rc4 for testing purpose.
>  => beware, the patch on the ov7272 was removed, shame on me
> 
> The patches are split into :
> 
>  - patch 1 .. 7 : copy paste of your patches, no
>  modification (beware, ov.... was expunged, sorry again)
> 
>  - patch 8 : the translation framework

Ok, I looked at your patches, I even have reviewed #8 and #9 (at least 
partially.) But I think I won't send those reviews. I have a different 
idea now:-) Don't worry, it probably won't mean more work for you. It will 
mean some more work for me, and some work for you too, but, simpler than 
what you have done in your patches, if we agree to my idea, of course:

1. On the first call to soc_camera_open() we generate a list of possible 
pixel formats.

2. on format enumeration we just walk the generated above list, so, I 
don't see a need to let host drivers overload this function. If we agree, 
this can stay central in soc_camera.c for all, then we drop my patch 
"soc-camera: move pixel format handling to host drivers (part 2)," adding 
.enum_fmt method to struct soc_camera_host_ops.

3. try_fmt and set_fmt are handled by the host driver, and that one 
decides which format to request from the sensor.

Now, seeing all the complexity in your patch-series, I would like to 
simplify it. I don't think we need to export to struct soc_camera_device 
the list of host-provided format conversions (your

	const struct soc_camera_format_translate *translate_fmt;

pointer.) So I would drop soc_camera_format_generate() and let host's 
->add_extra_formats() method do all the work - add both format types 
"special" and "pass-through." And because it now would handle not only 
extra formats, it should be called just "add_formats" or "get_formats" or 
"generate_formats"... Then available_formats I would just make a list of 
pointers to struct soc_camera_data_format, so the host driver would just 
either assign a pointer to a sensor provided format struct in case of 
pass-through, or a pointer to its own struct. Hosts would then just define 
a static array of these "extra" structs, similar to sensors. And we don't 
need your struct soc_camera_computed_format - how the host generates the 
required format and which format it requests from the sensor is their 
intimate business, we don't want to intrude in their private life:-)

How does this sound? If this is accepted, I would resend my patch-series 
without the above patch. And you can decide if you want to code this new 
patch or I shall do it.

If you do it, please, only do this one patch at first. After we have got 
it right, then we can add support to PXA and SuperH. Also we should 
preserve the current behaviour at least until the drivers are ported - 
just assign pointers to all sensor-provided formats to the newly-allocated 
list if the host doesn't provide an .add_formats method.

Thanks
Guennadi

>  - patch 9 : application of the framework to pxa_camera host
>  - patch 10 : application of the framework to
>  sh_mobile_ceu_camera host
> 
>  - patch 11 - 12 : fixes for YUV format handling in pxa_camera
> 
> This is the ground of the discussion. I know I still have to
> add documentation around the new functions/structures. I
> need to know if this is what you have in mind, to either
> continue the work or stop and take a different path.
> 
> I should add this was tested with RGB565 and all YUV formats
> on a pxa272 with a mt9m111 (as you could have expected :)).
> 
> Now is the time to improve the translation code. Happy review.
> 
> --
> Robert
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
