Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7TIHi5S019951
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 14:17:44 -0400
Received: from smtp-vbr12.xs4all.nl (smtp-vbr12.xs4all.nl [194.109.24.32])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7TIH4d8011168
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 14:17:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Date: Fri, 29 Aug 2008 20:16:48 +0200
References: <Pine.LNX.4.64.0808201138070.7589@axis700.grange>
	<200808282058.26623.hverkuil@xs4all.nl>
	<Pine.LNX.4.64.0808292013120.3521@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0808292013120.3521@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808292016.48647.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v3] soc-camera: add API documentation
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

On Friday 29 August 2008 20:16:31 Guennadi Liakhovetski wrote:
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>
> ---
>
> Ok, more comments addressed, thanks to all again, we might even get
> it in for 2.6.27? It certainly will not cause any regressions:-)

Acked-by: Hans Verkuil <hverkuil@xs4all.nl>

And apologies for hijacking your post for me rant :-)

Regards,

	Hans

>
> diff -u /dev/null b/Documentation/video4linux/soc-camera.txt
> --- /dev/null	2008-08-29 08:10:06.483001029 +0200
> +++ b/Documentation/video4linux/soc-camera.txt	2008-08-29
> 19:56:41.000000000 +0200 @@ -0,0 +1,120 @@
> +			Soc-Camera Subsystem
> +			====================
> +
> +Terminology
> +-----------
> +
> +The following terms are used in this document:
> + - camera / camera device / camera sensor - a video-camera sensor
> chip, capable +   of connecting to a variety of systems and
> interfaces, typically uses i2c for +   control and configuration, and
> a parallel or a serial bus for data. + - camera host - an interface,
> to which a camera is connected. Typically a +   specialised
> interface, present on many SoCs, e.g., PXA27x and PXA3xx, SuperH, +  
> AVR32, i.MX27, i.MX31.
> + - camera host bus - a connection between a camera host and a
> camera. Can be +   parallel or serial, consists of data and control
> lines, e.g., clock, vertical +   and horizontal synchronization
> signals.
> +
> +Purpose of the soc-camera subsystem
> +-----------------------------------
> +
> +The soc-camera subsystem provides a unified API between camera host
> drivers and +camera sensor drivers. It implements a V4L2 interface to
> the user, currently +only the mmap method is supported.
> +
> +This subsystem has been written to connect drivers for
> System-on-Chip (SoC) +video capture interfaces with drivers for CMOS
> camera sensor chips to enable +the reuse of sensor drivers with
> various hosts. The subsystem has been designed +to support multiple
> camera host interfaces and multiple cameras per interface, +although
> most applications have only one camera sensor.
> +
> +Existing drivers
> +----------------
> +
> +As of 2.6.27-rc4 there are two host drivers in the mainline:
> pxa_camera.c for +PXA27x SoCs and sh_mobile_ceu_camera.c for SuperH
> SoCs, and four sensor drivers: +mt9m001.c, mt9m111.c, mt9v022.c and a
> generic soc_camera_platform.c driver. This +list is not supposed to
> be updated, look for more examples in your tree. +
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
> +.add and .remove methods are called when a sensor is attached to or
> detached +from the host, apart from performing host-internal tasks
> they shall also call +sensor driver's .init and .release methods
> respectively. .suspend and .resume +methods implement host's
> power-management functionality and its their +responsibility to call
> respective sensor's methods. .try_bus_param and +.set_bus_param are
> used to negotiate physical connection parameters between the +host
> and the sensor. .init_videobuf is called by soc-camera core when a
> +video-device is opened, further video-buffer management is
> implemented completely +by the specific camera host driver. The rest
> of the methods are called from +respective V4L2 operations.
> +
> +Camera API
> +----------
> +
> +Sensor drivers can use struct soc_camera_link, typically provided by
> the +platform, and used to specify to which camera host bus the
> sensor is connected, +and arbitrarily provide platform .power and
> .reset methods for the camera. +soc_camera_device_register() and
> soc_camera_device_unregister() functions are +used to add a sensor
> driver to or remove one from the system. The registration +function
> takes a pointer to struct soc_camera_device as the only parameter.
> +This struct can be initialized as follows:
> +
> +	/* link to driver operations */
> +	icd->ops	= &mt9m001_ops;
> +	/* link to the underlying physical (e.g., i2c) device */
> +	icd->control	= &client->dev;
> +	/* window geometry */
> +	icd->x_min	= 20;
> +	icd->y_min	= 12;
> +	icd->x_current	= 20;
> +	icd->y_current	= 12;
> +	icd->width_min	= 48;
> +	icd->width_max	= 1280;
> +	icd->height_min	= 32;
> +	icd->height_max	= 1024;
> +	icd->y_skip_top	= 1;
> +	/* camera bus ID, typically obtained from platform data */
> +	icd->iface	= icl->bus_id;
> +
> +struct soc_camera_ops provides .probe and .remove methods, which are
> called by +the soc-camera core, when a camera is matched against or
> removed from a camera +host bus, .init, .release, .suspend, and
> .resume are called from the camera host +driver as discussed above.
> Other members of this struct provide respective V4L2 +functionality.
> +
> +struct soc_camera_device also links to an array of struct
> soc_camera_data_format, +listing pixel formats, supported by the
> camera.
> +
> +--
> +Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
