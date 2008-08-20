Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7KKTJjZ010714
	for <video4linux-list@redhat.com>; Wed, 20 Aug 2008 16:29:19 -0400
Received: from smtp2-g19.free.fr (smtp2-g19.free.fr [212.27.42.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7KKTFsR019026
	for <video4linux-list@redhat.com>; Wed, 20 Aug 2008 16:29:15 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <Pine.LNX.4.64.0808201138070.7589@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Wed, 20 Aug 2008 22:29:13 +0200
In-Reply-To: <Pine.LNX.4.64.0808201138070.7589@axis700.grange> (Guennadi
	Liakhovetski's message of "Wed\,
	20 Aug 2008 11\:40\:39 +0200 \(CEST\)")
Message-ID: <874p5fzazq.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH RFC] soc-camera: add API documentation
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

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> +Existing drivers
> +----------------
> +
> +Currently there are two host drivers in the mainline: pxa_camera.c for PXA27x
> +SoCs and sh_mobile_ceu_camera.c for SuperH SoCs, and four sensor drivers:
> +mt9m001.c, mt9m111.c, mt9v022.c and a generic soc_camera_platform.c driver.
> +Please, use these driver as examples when developing new ones.
                           ^
                           maybe an s here ?
> +Camera host API
> +---------------
> +
> +A host camera driver is registered using the
> +
> +soc_camera_host_register(struct soc_camera_host *);
> +
> +function. The host object can be initialized as follows:
> +
> +static struct soc_camera_host pxa_soc_camera_host = {
> +	.drv_name	= PXA_CAM_DRV_NAME,
> +	.ops		= &pxa_soc_camera_host_ops,
> +};
> +
> +All camera host methods are passed in a struct soc_camera_host_ops:
> +
> +static struct soc_camera_host_ops pxa_soc_camera_host_ops = {
> +	.owner		= THIS_MODULE,
> +	.add		= pxa_camera_add_device,
> +	.remove		= pxa_camera_remove_device,
> +	.suspend	= pxa_camera_suspend,
> +	.resume		= pxa_camera_resume,
> +	.set_fmt_cap	= pxa_camera_set_fmt_cap,
> +	.try_fmt_cap	= pxa_camera_try_fmt_cap,
> +	.init_videobuf	= pxa_camera_init_videobuf,
> +	.reqbufs	= pxa_camera_reqbufs,
> +	.poll		= pxa_camera_poll,
> +	.querycap	= pxa_camera_querycap,
> +	.try_bus_param	= pxa_camera_try_bus_param,
> +	.set_bus_param	= pxa_camera_set_bus_param,
> +};
> +
> +.add and .remove methods are called when a sensor is attached to or detached
> +from the host, apart from performing host-internal tasks they shall also call
> +sensor driver's .init and .release methods respectively. .suspend and .resume
> +methods implement host's power-management functionality and its their
> +responsibility to call respective sensor's methods. .try_bus_param and
> +.set_bus_param are used to negotiate physical connection parameters between the
> +host and the sensor. .init_videobuf is called by soc-camera core when a
> +video-device is opened, further video-buffer management is implemented completely
> +by the specific camera host driver. The rest of the methods are called from
> +respective V4L2 operations.

Maybe a concrete example to help people with concepts of SoCs, hosts, host
driver, camera driver, and so on ...
Like (to be translated to correct english) :

---
Let's assume our hardware system is :
 - an Intel CPU, the PXA270, which does provide a hardware bus for camera
 - a camera chip, which is a Micron MT9M001 CMOS sensor
 - the wires connecting the camera chip (8 for data + 4 control) to the PXA270

The driver involved in camera management are :
 - the host driver, in pxa_camera.c, which handles any camera attached to the
 pxa270
 - the camera driver, in mt9m001.c, which interacts with the camera giving it
 orders to poweron/poweroff, choose output definition, ...
 - the glue binding the host driver to the camera driver (soc_camera.c)
---

Note that it may be only me, and my personnal obsession of real examples to
illustrate. I really like the explanation in that doc :)

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
