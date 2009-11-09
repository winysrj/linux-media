Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:38848 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755089AbZKIRVX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2009 12:21:23 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Mon, 9 Nov 2009 11:21:27 -0600
Subject: RE: S_FMT @ sensor driver & bridge driver
Message-ID: <A69FA2915331DC488A831521EAE36FE401558ABB3F@dlee06.ent.ti.com>
References: <A69FA2915331DC488A831521EAE36FE401558AB985@dlee06.ent.ti.com>
 <200911091615.43017.hverkuil@xs4all.nl>
In-Reply-To: <200911091615.43017.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,


Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
phone: 301-407-9583
email: m-karicheri2@ti.com

>-----Original Message-----
>From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
>Sent: Monday, November 09, 2009 10:16 AM
>To: Karicheri, Muralidharan
>Cc: linux-media@vger.kernel.org
>Subject: Re: S_FMT @ sensor driver & bridge driver
>
>On Monday 09 November 2009 15:48:35 Karicheri, Muralidharan wrote:
>> Hello,
>>
>> Currently the S_FMT IOCTL is used to configure the image resolution
>> and (there by scaler settings) at the sensor (example MT9T031).
>> Platforms like TI's DMxxx VPFE has Resizer in the pipeline that can
>> be used as well by application to either zoom in a specific region
>> of the capture image from the sensor or scale it up for some other
>> reason. To do this we need to issue two S_FMT commands, 1st to set
>> the capture frame resolution at the sensor and second to configure
>> resize ration at the SOC Resizer. With the current API, I don't see
>> a way this can be done. I wish we had some extra bytes in the S_FMT
>structure to add a flag that can indicate if S_FMT applies to the
>> sensor or at the SOC (bridge). One way to implement this is to add
>> a control to tell the bridge driver to send a specific IOCTL command
>> to the sensor. Another use of such a command will be for control.
>> For example if a specific control such as White balance is available
>> at the SOC pipeline as well as at the sensor, then application can
>> use the above control to direct that IOCTL command to the specific
>> device.
>>
>> You might argue that Media controller will allow you to direct
>> such commands directly to the target device. This is true for
>> control example I have mentioned above. But when applying
>> S_FMT at the sensor, we might want to passing it through the
>> bridge driver (as is the case with VPFE) so that it can request
>> extra lines to be captured as overhead to allow processing the
>> frame at the SOC pipeline in real time. So I do see this control
>> command staying even after we have media controller. Let me know
>> if you disagree with this proposal or have alternative to implement
>> the same. If I don't hear anything against this approach, I would
>> like to send patch to implement this control for vpfe capture
>> driver.
>
>I don't think this is a good idea. This is something that is highly
>hw dependent and as such should be done as part of the hw-specific
>subdev API that we will get in the future.
>
>The S_FMT ioctl is really a best-effort when it comes to SoCs. I.e.
>the S_FMT driver implementation should just try to do the best setup
>it can do (within reason).
>
>I wonder if we shouldn't start implementing the code needed to get subdev
>device nodes: if we have those, then it becomes much easier to start
>implementing hw-specific features. We don't need the media controller for
>that initially.
>
It is hardware dependent. I strongly feel we need to have device node for
sub device so that we can make changes to existing drivers like to ccdc to
remove the experimental ioctl and add the same to the sub device driver.
Assuming we have a device node, do you think we could add the extra line
requirement that I had mentioned to the platform data of the sub device?

So application does the following to start streaming in the sensor

1) Issue S_FMT to the sensor (mt9t031 for example)
	(set resolution to 1280x720), sub device driver adds extra lines if
	 needed for a specific platform)
2) Issue a S_FMT to the video node. At this point, bridge driver issue
	g_fmt() to the sensor sub device to get current image size, frame
	format, pixel format etc. Set the resizer resize ration based on the
	sensor input image size and required final image size at the video
	node.
If this is fine, then what it takes to add device node to a sub device?
I know that Laurent is already working on the Media controller and adding
video node to sub device is one of the development items. Probably a
patch to add video node to sub device can then be pushed first so that
drivers can leverage on this framework to implement hardware dependent
features. Otherwise, we need something on the interim to implement the
above feature in vpfe capture.
 
>Regards,
>
>	Hans
>
>--
>Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

