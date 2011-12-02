Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:53362 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756801Ab1LBQFH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Dec 2011 11:05:07 -0500
MIME-Version: 1.0
In-Reply-To: <4ED8D374.1030206@mm-sol.com>
References: <1322698500-29924-1-git-send-email-saaguirre@ti.com>
 <1322698500-29924-4-git-send-email-saaguirre@ti.com> <4ED8D374.1030206@mm-sol.com>
From: "Aguirre, Sergio" <saaguirre@ti.com>
Date: Fri, 2 Dec 2011 10:04:42 -0600
Message-ID: <CAKnK67REjC110pywXA+Uy_6N7UEibsci=EDbsUw3CqrQWp+ZKA@mail.gmail.com>
Subject: Re: [PATCH v2 03/11] v4l: Introduce sensor operation for getting
 interface configuration
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stan,

On Fri, Dec 2, 2011 at 7:32 AM, Stanimir Varbanov <svarbanov@mm-sol.com> wrote:
> Hi, Sergio
>
> This change in interface is not used from the omap4iss driver.
>
> You could drop it from the patch set, if so.

Oops, yes... I used to depend on this for my soc_camera implementation before...

You're absolutely right, i'll remove it in the next iteration.

Merci!

>
> On 12/01/2011 02:14 AM, Sergio Aguirre wrote:
>> From: Stanimir Varbanov <svarbanov@mm-sol.com>
>>
>> Introduce g_interface_parms sensor operation for getting sensor
>> interface parameters. These parameters are needed from the host side
>> to determine it's own configuration.
>>
>> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
>> ---
>>  include/media/v4l2-subdev.h |   42 ++++++++++++++++++++++++++++++++++++++++++
>>  1 files changed, 42 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
>> index f0f3358..0d322ed 100644
>> --- a/include/media/v4l2-subdev.h
>> +++ b/include/media/v4l2-subdev.h
>> @@ -362,6 +362,42 @@ struct v4l2_subdev_vbi_ops {
>>       int (*s_sliced_fmt)(struct v4l2_subdev *sd, struct v4l2_sliced_vbi_format *fmt);
>>  };
>>
>> +/* Which interface the sensor use to provide it's image data */
>> +enum v4l2_subdev_sensor_iface {
>> +     V4L2_SUBDEV_SENSOR_PARALLEL,
>> +     V4L2_SUBDEV_SENSOR_SERIAL,
>> +};
>> +
>> +/* Each interface could use the following modes */
>> +/* Image sensor provides horizontal and vertical sync signals */
>> +#define V4L2_SUBDEV_SENSOR_MODE_PARALLEL_SYNC        0
>> +/* BT.656 interface. Embedded sync */
>> +#define V4L2_SUBDEV_SENSOR_MODE_PARALLEL_ITU 1
>> +/* MIPI CSI1 */
>> +#define V4L2_SUBDEV_SENSOR_MODE_SERIAL_CSI1  2
>> +/* MIPI CSI2 */
>> +#define V4L2_SUBDEV_SENSOR_MODE_SERIAL_CSI2  3
>> +
>> +struct v4l2_subdev_sensor_serial_parms {
>> +     unsigned char lanes;            /* number of lanes used */
>> +     unsigned char channel;          /* virtual channel */
>> +     unsigned int phy_rate;          /* output rate at CSI phy in bps */
>> +     unsigned int pix_clk;           /* pixel clock in Hz */
>> +};
>> +
>> +struct v4l2_subdev_sensor_parallel_parms {
>> +     unsigned int pix_clk;           /* pixel clock in Hz */
>> +};
>> +
>> +struct v4l2_subdev_sensor_interface_parms {
>> +     enum v4l2_subdev_sensor_iface if_type;
>> +     unsigned int if_mode;
>> +     union {
>> +             struct v4l2_subdev_sensor_serial_parms serial;
>> +             struct v4l2_subdev_sensor_parallel_parms parallel;
>> +     } parms;
>> +};
>> +
>>  /**
>>   * struct v4l2_subdev_sensor_ops - v4l2-subdev sensor operations
>>   * @g_skip_top_lines: number of lines at the top of the image to be skipped.
>> @@ -371,10 +407,16 @@ struct v4l2_subdev_vbi_ops {
>>   * @g_skip_frames: number of frames to skip at stream start. This is needed for
>>   *              buggy sensors that generate faulty frames when they are
>>   *              turned on.
>> + * @g_interface_parms: get sensor interface parameters. The sensor subdev should
>> + *                  fill this structure with current interface params. These
>> + *                  interface parameters are needed on host side to configure
>> + *                  it's own hardware receivers.
>>   */
>>  struct v4l2_subdev_sensor_ops {
>>       int (*g_skip_top_lines)(struct v4l2_subdev *sd, u32 *lines);
>>       int (*g_skip_frames)(struct v4l2_subdev *sd, u32 *frames);
>> +     int (*g_interface_parms)(struct v4l2_subdev *sd,
>> +                     struct v4l2_subdev_sensor_interface_parms *parms);
>>  };
>>
>>  /*
>
>
> --
> best regards,
> Stan
