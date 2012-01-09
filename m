Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:41214 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899Ab2AIWcL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Jan 2012 17:32:11 -0500
Message-ID: <4F0B6AE6.7090008@iki.fi>
Date: Tue, 10 Jan 2012 00:32:06 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, tuukkat76@gmail.com,
	dacohen@gmail.com, g.liakhovetski@gmx.de, hverkuil@xs4all.nl,
	snjw23@gmail.com
Subject: Re: [ANN] Notes on IRC meeting on new sensor control interface, 2012-01-09
 14:00 GMT+2
References: <20120104085633.GM3677@valkosipuli.localdomain> <20120109173825.GR9323@valkosipuli.localdomain> <201201092238.30469.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201201092238.30469.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote:
> On Monday 09 January 2012 18:38:25 Sakari Ailus wrote:
>> Hi all,
>>
>> We had an IRC meeting on the new sensor control interface on #v4l-meeting
>> as scheduled previously. The meeting log is available here:
>>
>> <URL:http://www.retiisi.org.uk/v4l2/v4l2-sensor-control-interface-2012-01-0
>> 9.txt>
>>
>> My notes can be found below.
>
> Thanks for the summary.
>
>> Accessing V4L2 subdev and MC interfaces in user space: user space libraries
>> ===========================================================================
>>
>> While the V4L2 subdev and Media controller kernel interface is functionally
>> comprehensive, it is a relatively low level interface for even for
>> vendor-specific user space camera libraries. The issue is intensified with
>> the extension of the pipeline configuration performed using the Media
>> controller and V4L2 subdev interfaces to cover the image processing
>> performed on the sensor: this is part of the new sensor control interface.
>>
>> As we want to encourage SoC vendors to use the V4L2, we need to make this
>> as easy as possible for them.
>>
>> The low level camera control libraries can be split into roughly two
>> categories: those which configure the image pipe and those which deal with
>> the 3A algorithms. The 3A algorithms are typically proprietary so we
>> concentrated to the pipeline configuration which is what the Media
>> controller and V4L2 subdev frameworks have been intended for.
>>
>> Two libraries already exist for this: libmediactl and libv4l2subdev. The
>> former deals with topology enumeration and link configuration whereas the
>> latter is a generic library for V4L2 subdev configuration, including format
>> configuration.
>>
>> The new sensor control interface moves the remaining policy decisions to
>> the user space: how the sensor's image pipe is configured, what pixel
>> rates are being used on the bus from the sensor to the ISP and how is the
>> blanking configured.
>>
>> The role of the new library, called libv4l2pipe, is to interpret text-based
>> configuration file containing sections for various pipeline format and link
>> configurations, as well as V4L2 controls: the link frequency is a control
>> as well; but more on that below. The library may be later on merged to
>> libv4l2pipeauto which Sakari is working on.
>>
>> Both pipeline format and link configurations are policy decisions and thus
>> can be expected to be use case specific. A format configuration is
>> dependent on a link configuration but the same link configuration can be
>> used with several format configurations. Thus the two should be defined
>> separately.
>>
>> A third kind of section will be for setting controls. The only control to
>> be set will be the link frequency control but a new type of setting
>> warrants a new section.
>>
>> A fourth section may be required as well: at this level the frame rate (or
>> frame time) range makes more sense than the low-level blanking values. The
>> blanking values can be calculated from the frame time and a flag which
>> tells whether either horizontal or vertical blanking should be preferred.
>
> How does one typically select between horizontal and vertical blanking ? Do
> mixed modes make sense ?

There are minimums and maximums for both. You can increase the frame 
time by increasing value for either or both of them --- to achieve very 
long frame times you may have to use both, but that's not very common in 
practice. I think we should have a flag to tell which one should be 
increased first --- the effect would be to have the minimum possible 
value on the other.

>> A configuration consisting of all the above sections will define the full
>> pipeline configuration. The library must also provide a way to enumerate,
>> query and set these configurations.
>>
>> With the existence of this library and the related new sensor control
>> interface, the V4L2 supports implementing digital cameras even better than
>> it used to.
>>
>> The LGPL 2.1+ license used by libmediactl, libv4l2pipeauto and the future
>> libv4l2pipe(auto) is not seen an issue for Android to adopt these libraries
>> either.
>>
>> In GStreamer middleware, libv4l2pipe is expected to be used by the camera
>> source component.
>
> Should we try to draft how a 3A library should be implemented ? Do you think
> that might have implications on libv4l2pipe ?

We should, yes. I can't see any immediate effects from that to 
libv4l2pipe. libv4l2pipe may need to provide some information to the 3A 
library but that should mostly be it.

>> The new sensor control interface
>> ================================
>>
>>
>> The common understanding was that the new sensor control interface is
>> mostly accepted. No patches have been acked since there have been lots of
>> trivial and some not so trivial issues in the patchset. There was an
>> exception to this, which is the pixel_rate field in struct
>> v4l2_mbus_framefmt.
>>
>> The field is expected to be propagated by the user while the user has no
>> valid use case to modify it. The agreement was that instead of adding the
>> field to struct v4l2_mbus_framefmt, a new control will be introduced
>> instead.
>>
>> A control has several good properties: it can be implemented where it is
>> valid: it isn't always possible to accurately specify the pixel rate in
>> some parts of the pipeline.
>>
>> Sensor drivers should provide the pixel_rate control in two subdevs: the
>> pixel array and the one which is opposed to the ISP's bus receiver. The
>> pixel array's pixel rate is mostly required in the user space whereas the
>> pixel rate in the bus transmitter subdev (which may have other
>> functionality as well) is often required by the bus receivers, as well as
>> by the rest of the ISP.
>>
>> Ideally the pixel_rate control is related to pads rather than subdevs but
>> 1) we don't have pad specific controls and 2) we don't stictly need them
>> right now since there only will be need for a single pixel_rate control
>> per subdev.
>>
>> If pixel rate management will be implemented to prevent starting pipelines
>> which would fail to stream in cases where too high pixel rates are used on
>> particular subdevs, the concept of pad-specific controls may be later
>> revisited. Making the pixel_rate control pad-specific only will change the
>> interface towards the user space if the pad where it is implemented is
>> non-zero.
>
> I'm fine with that. Let's use a control now, we'll revisit this later if
> needed.

Agreed.

-- 
Sakari Ailus
sakari.ailus@iki.fi
