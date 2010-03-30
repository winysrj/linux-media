Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway12.websitewelcome.com ([67.18.137.84]:46384 "HELO
	gateway12.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754731Ab0C3Uzu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Mar 2010 16:55:50 -0400
Message-ID: <4BB263C4.4040900@sensoray.com>
Date: Tue, 30 Mar 2010 13:49:08 -0700
From: dean <dean@sensoray.com>
MIME-Version: 1.0
To: David Ellingsworth <david@identd.dyndns.org>
CC: mchehab@infradead.org, laurent.pinchart@ideasonboard.com,
	isely@pobox.com, andre.goddard@gmail.com,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] s2255drv: cleanup of driver disconnect code
References: <tkrat.7f9b79c0eafb6d4f@sensoray.com> <30353c3d1003300821n4b38f974w57ab6858252aa50f@mail.gmail.com>
In-Reply-To: <30353c3d1003300821n4b38f974w57ab6858252aa50f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for this and the other feedback.

The concern, without knowing the full history, is if video_device_alloc 
changes to do more than just allocate the whole structure with a single 
call to kzalloc?  Otherwise, why have this extra indirection and 
overhead in most V4L drivers?

The majority of V4L drivers are using video_device_alloc.  Very few 
(bw-qcam.h, c-qcam.c, cpia.h, pvrusb2, usbvideo) are using "struct 
video_device" statically similar to solution 1.  Three drivers(zoran, 
radio-gemtek, saa5249) are allocating their own video_device structure 
directly with kzalloc similar to solution #2.

The call definitely needs checked, but I'd like some more feedback on this.

Thanks and best regards,

Dean




David Ellingsworth wrote:
> This patch looks good, but there was one other thing that caught my eye.
>
> In s2255_probe_v4l, video_device_alloc is called for each video
> device, which is nothing more than a call to kzalloc, but the result
> of the call is never verified.
>
> Given that this driver has a fixed number of video device nodes, the
> array of video_device structs could be allocated within the s2255_dev
> struct. This would remove the extra calls to video_device_alloc,
> video_device_release, and the additional error checks that should have
> been there. If you'd prefer to keep the array of video_device structs
> independent of the s2255_dev struct, an alternative would be to
> dynamically allocate the entire array at once using kcalloc and store
> only the pointer to the array in the s2255_dev struct. In my opinion,
> either of these methods would be better than calling
> video_device_alloc for each video device that needs to be registered.
>
> Regards,
>
> David Ellingsworth
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

