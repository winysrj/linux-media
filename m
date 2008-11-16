Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAGDOmWU009424
	for <video4linux-list@redhat.com>; Sun, 16 Nov 2008 08:24:48 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mAGDOQbo017327
	for <video4linux-list@redhat.com>; Sun, 16 Nov 2008 08:24:26 -0500
Date: Sun, 16 Nov 2008 14:24:31 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <8763mo6irz.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0811161409350.4368@axis700.grange>
References: <1226521783-19806-1-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0811160142140.21494@axis700.grange>
	<8763mo6irz.fsf@free.fr>
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

On Sun, 16 Nov 2008, Robert Jarzmik wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> > Ok, I looked at your patches, I even have reviewed #8 and #9 (at least 
> > partially.) But I think I won't send those reviews. I have a different 
> > idea now:-) Don't worry, it probably won't mean more work for you. It will 
> > mean some more work for me, and some work for you too, but, simpler than 
> > what you have done in your patches, if we agree to my idea, of course:
> >
> > 1. On the first call to soc_camera_open() we generate a list of possible 
> > pixel formats.
> Ack.
> 
> > 2. on format enumeration we just walk the generated above list, so, I 
> > don't see a need to let host drivers overload this function. If we agree, 
> > this can stay central in soc_camera.c for all, then we drop my patch 
> > "soc-camera: move pixel format handling to host drivers (part 2)," adding 
> > .enum_fmt method to struct soc_camera_host_ops.
> Ack.
> 
> > 3. try_fmt and set_fmt are handled by the host driver, and that one 
> > decides which format to request from the sensor.
> >
> > Now, seeing all the complexity in your patch-series, I would like to 
> > simplify it. I don't think we need to export to struct soc_camera_device 
> > the list of host-provided format conversions (your
> >
> > 	const struct soc_camera_format_translate *translate_fmt;
> >
> > pointer.) So I would drop soc_camera_format_generate() and let host's 
> > ->add_extra_formats() method do all the work - add both format types 
> > "special" and "pass-through." And because it now would handle not only 
> > extra formats, it should be called just "add_formats" or "get_formats" or 
> > "generate_formats"... Then available_formats I would just make a list of 
> > pointers to struct soc_camera_data_format, so the host driver would just 
> > either assign a pointer to a sensor provided format struct in case of 
> > pass-through, or a pointer to its own struct. Hosts would then just define 
> > a static array of these "extra" structs, similar to sensors. And we don't 
> > need your struct soc_camera_computed_format - how the host generates the 
> > required format and which format it requests from the sensor is their 
> > intimate business, we don't want to intrude in their private life:-)
> >
> > How does this sound? If this is accepted, I would resend my patch-series 
> > without the above patch. And you can decide if you want to code this new 
> > patch or I shall do it.
> 
> Sounds good. Let me add one constraint though. There should be somewhere (at
> format generation for example) a debug way to show (printk, ...) each format
> translation between host format and sensor format.
> 
> This was in the patch serie if soc_camera format generation function, and
> provided tracability to the translation process.

Yes, I saw this, and although it does look useful, I tend not to add the 
whole host format - sensor format infrastructure alone for this debug 
feature. I would restrict this generated format list to user (host) 
formats only - without exposing which sensor format the host has decided 
to use for it. We can either add this debug functionality either on a 
per-host basis, or implement a debug hook in host drivers? In any case I 
would prefer not to make this a part of the infrastructure for debugging 
alone.

> Would you also duplicate current_fmt, so that the current host format and sensor
> current format are available at sight ?

Why? Give me a real reason (apart from debugging) why we need to know in 
soc_camera.c which formats the host requests from the sensor for a 
specific output format or which format is currently configured on the 
sensor?

> > If you do it, please, only do this one patch at first. After we have got 
> > it right, then we can add support to PXA and SuperH. Also we should 
> > preserve the current behaviour at least until the drivers are ported - 
> > just assign pointers to all sensor-provided formats to the newly-allocated 
> > list if the host doesn't provide an .add_formats method.
> I'll wait for your patches this time, and won't generate a new one. Would you
> please, once your first throw is ready, post a full serie as I did, so that I
> can apply it all for test and review ? ;)

Well, would it be enough if I put the current state somewhere up as a 
quilt patch series, for instance? I don't want to repost all patches on 
each iteration.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
