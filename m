Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:9850 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941154AbcJSO1j (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 10:27:39 -0400
Subject: Re: [PATCH v2 1/1] doc-rst: v4l: Add documentation on CSI-2 bus
 configuration
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se
References: <1476870150.3054.28.camel@pengutronix.de>
 <1476881994-32118-1-git-send-email-sakari.ailus@linux.intel.com>
 <1476887059.3054.42.camel@pengutronix.de>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <580782D8.9080906@linux.intel.com>
Date: Wed, 19 Oct 2016 17:27:36 +0300
MIME-Version: 1.0
In-Reply-To: <1476887059.3054.42.camel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/19/16 17:24, Philipp Zabel wrote:
> Am Mittwoch, den 19.10.2016, 15:59 +0300 schrieb Sakari Ailus:
>> Document the interface between the CSI-2 transmitter and receiver drivers.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> ---
>> Hi Philipp,
>>
>> Indeed the pixel rate is used by some driver as well.
>>
>> How about this one instead?
>>
>> The HTML page is available here (without CCS unfortunately):
>>
>> <URL:http://www.retiisi.org.uk/v4l2/tmp/csi2.html>
>>
>> since v1:
>>  
>> - Add PIXEL_RATE to the required controls.
>>
>> - Document how pixel rate is calculated from the link frequency.
>>
>>  Documentation/media/kapi/csi2.rst  | 59 ++++++++++++++++++++++++++++++++++++++
>>  Documentation/media/media_kapi.rst |  1 +
>>  2 files changed, 60 insertions(+)
>>  create mode 100644 Documentation/media/kapi/csi2.rst
>>
>> diff --git a/Documentation/media/kapi/csi2.rst b/Documentation/media/kapi/csi2.rst
>> new file mode 100644
>> index 0000000..31f927d
>> --- /dev/null
>> +++ b/Documentation/media/kapi/csi2.rst
>> @@ -0,0 +1,59 @@
>> +MIPI CSI-2
>> +==========
>> +
>> +CSI-2 is a data bus intended for transferring images from cameras to
>> +the host SoC. It is defined by the `MIPI alliance`_.
>> +
>> +.. _`MIPI alliance`: http://www.mipi.org/
>> +
>> +Transmitter drivers
>> +-------------------
>> +
>> +CSI-2 transmitter, such as a sensor or a TV tuner, drivers need to
>> +provide the CSI-2 receiver with information on the CSI-2 bus
>> +configuration. These include the V4L2_CID_LINK_FREQ and
>> +V4L2_CID_PIXEL_RATE controls and
>> +(:c:type:`v4l2_subdev_video_ops`->s_stream() callback). These
>> +interface elements must be present on the sub-device represents the
>> +CSI-2 transmitter.
>> +
>> +The V4L2_CID_LINK_FREQ control is used to tell the receiver driver the
>> +frequency (and not the symbol rate) of the link. The
>> +V4L2_CID_PIXEL_RATE is may be used by the receiver to obtain the pixel
>> +rate the transmitter uses. The
>> +:c:type:`v4l2_subdev_video_ops`->s_stream() callback provides an
>> +ability to start and stop the stream.
>> +
>> +The value of the V4L2_CID_PIXEL_RATE is calculated as follows::
>> +
>> +	pixel_rate = link_freq * 2 * nr_of_lanes
> 
> This is the total bps, which must be divided by the bits per pixel
> depending on the selected MEDIA_BUS_FMT, for example
> /16 for MEDIA_BUS_FMT_UYVY8_1X16, or /24 for MEDIA_BUS_FMT_RGB888_1X24,
> to obtain pixel_rate.

Uh, indeed. I'll change this.

> 
>> +where
>> +
>> +.. list-table:: variables in pixel rate calculation
>> +   :header-rows: 1
>> +
>> +   * - variable or constant
>> +     - description
>> +   * - link_freq
>> +     - The value of the V4L2_CID_LINK_FREQ integer64 menu item.
>> +   * - nr_of_lanes
>> +     - Number of data lanes used on the CSI-2 link. This can
>> +       be obtained from the OF endpoint configuration.
> 
> I suppose the number of lanes should be calculated as
> 	nr_of_lanes = DIV_ROUND_UP(pixel_rate * bpp, link_freq * 2)
> in the receiver driver? Not all lanes configured in the device tree have
> to be used, depending on the configured link frequencies and bus format.

Do we have any user for that yet?

I know there's hardware where this would be necessary in order to
support all image sizes and formats for instance, but there's no driver yet.

If we don't need to expose this to the user --- I don't think we do ---
we could use frame descriptors to do that.

> 
>> +   * - 2
>> +     - Two bits are transferred per clock cycle per lane.
>> +
>> +The transmitter drivers must configure the CSI-2 transmitter to *LP-11
>> +mode* whenever the transmitter is powered on but not active. Some
>> +transmitters do this automatically but some have to be explicitly
>> +programmed to do so.
>> +
>> +Receiver drivers
>> +----------------
>> +
>> +Before the receiver driver may enable the CSI-2 transmitter by using
>> +the :c:type:`v4l2_subdev_video_ops`->s_stream(), it must have powered
>> +the transmitter up by using the
>> +:c:type:`v4l2_subdev_core_ops`->s_power() callback. This may take
>> +place either indirectly by using :c:func:`v4l2_pipeline_pm_use` or
>> +directly.
>> diff --git a/Documentation/media/media_kapi.rst b/Documentation/media/media_kapi.rst
>> index f282ca2..bc06389 100644
>> --- a/Documentation/media/media_kapi.rst
>> +++ b/Documentation/media/media_kapi.rst
>> @@ -33,3 +33,4 @@ For more details see the file COPYING in the source distribution of Linux.
>>      kapi/rc-core
>>      kapi/mc-core
>>      kapi/cec-core
>> +    kapi/csi2
> 
> regards
> Philipp
> 


-- 
Sakari Ailus
sakari.ailus@linux.intel.com
