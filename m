Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35186 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753785AbeBFX3L (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Feb 2018 18:29:11 -0500
Received: by mail-wr0-f194.google.com with SMTP id w50so3753220wrc.2
        for <linux-media@vger.kernel.org>; Tue, 06 Feb 2018 15:29:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <c7771c44-a9ff-0207-38f6-28bcc06ccdee@xs4all.nl>
References: <1517948874-21681-1-git-send-email-tharvey@gateworks.com> <c7771c44-a9ff-0207-38f6-28bcc06ccdee@xs4all.nl>
From: Tim Harvey <tharvey@gateworks.com>
Date: Tue, 6 Feb 2018 15:29:09 -0800
Message-ID: <CAJ+vNU1oiM0Y0rO-DHi57nVOqnw60A7pn_1=h5b46-BrY7_p2Q@mail.gmail.com>
Subject: Re: [PATCH v8 0/7] TDA1997x HDMI video reciver
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 6, 2018 at 1:21 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 02/06/2018 09:27 PM, Tim Harvey wrote:
>
> <snip>
>
>> v4l2-compliance test results:
>>  - with the following kernel patches:
>>    v4l2-subdev: clear reserved fields
>>  . v4l2-subdev: without controls return -ENOTTY
>>
>> v4l2-compliance SHA   : b2f8f9049056eb6f9e028927dacb2c715a062df8
>> Media Driver Info:
>>       Driver name      : imx-media
>>       Model            : imx-media
>>       Serial           :
>>       Bus info         :
>>       Media version    : 4.15.0
>>       Hardware revision: 0x00000000 (0)
>>       Driver version   : 4.15.0
>> Interface Info:
>>       ID               : 0x0300008f
>>       Type             : V4L Sub-Device
>> Entity Info:
>>       ID               : 0x00000003 (3)
>>       Name             : tda19971 2-0048
>>       Function         : Unknown
>
> This is missing. It should be one of these:
>
> https://hverkuil.home.xs4all.nl/spec/uapi/mediactl/media-types.html#media-entity-type
>
> However, we don't have a proper function defined.
>
> I would suggest adding a new MEDIA_ENT_F_DTV_DECODER analogous to MEDIA_ENT_F_ATV_DECODER.
>
> It would be a new patch adding this + documentation.

Hows this look for adding to my next series:

Author: Tim Harvey <tharvey@gateworks.com>
Date:   Tue Feb 6 14:12:52 2018 -0800

    [media] add digital video decoder video interface entity functions

    Add a new media entity function definition for digital TV decoders:
    MEDIA_ENT_F_DTV_DECODER

    Signed-off-by: Tim Harvey <tharvey@gateworks.com>

--- a/Documentation/media/uapi/mediactl/media-types.rst
+++ b/Documentation/media/uapi/mediactl/media-types.rst
@@ -321,6 +321,17 @@ Types and flags used to represent the media graph elements
          MIPI CSI-2, ...), and outputs them on its source pad to an output
          video bus of another type (eDP, MIPI CSI-2, parallel, ...).

+    -  ..  row 31
+
+       ..  _MEDIA-ENT-F-DTV-DECODER:
+
+       -  ``MEDIA_ENT_F_DTV_DECODER``
+
+       -  Digital video decoder. The basic function of the video decoder is
+         to accept digital video from a wide variety of sources
+         and output it in some digital video standard, with appropriate
+         timing signals.
+
 ..  tabularcolumns:: |p{5.5cm}|p{12.0cm}|

 .. _media-entity-flag:
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index b9b9446..6653e88 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -152,6 +152,7 @@ struct media_device_info {
  * MEDIA_ENT_F_IF_VID_DECODER and/or MEDIA_ENT_F_IF_AUD_DECODER.
  */
 #define MEDIA_ENT_F_TUNER              (MEDIA_ENT_F_OLD_SUBDEV_BASE + 5)
+#define MEDIA_ENT_F_DTV_DECODER
(MEDIA_ENT_F_OLD_SUBDEV_BASE + 6)

 #define MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN        MEDIA_ENT_F_OLD_SUBDEV_BASE


Assigning this now shows a function but does not resolve the media
compliance results:

--- a/drivers/media/i2c/tda1997x.c
+++ b/drivers/media/i2c/tda1997x.c
@@ -2586,6 +2586,7 @@ static int tda1997x_probe(struct i2c_client *client,
                 id->name, i2c_adapter_id(client->adapter),
                 client->addr);
        sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
+       sd->entity.function = MEDIA_ENT_F_DTV_DECODER;
        sd->entity.ops = &tda1997x_media_ops;

        /* set allowed mbus modes based on chip, bus-type, and bus-width */


root@ventana:~# v4l2-compliance -u1
v4l2-compliance SHA   : b2f8f9049056eb6f9e028927dacb2c715a062df8
Media Driver Info:
        Driver name      : imx-media
        Model            : imx-media
        Serial           :
        Bus info         :
        Media version    : 4.15.0
        Hardware revision: 0x00000000 (0)
        Driver version   : 4.15.0
Interface Info:
        ID               : 0x0300008f
        Type             : V4L Sub-Device
Entity Info:
        ID               : 0x00000003 (3)
        Name             : tda19971 2-0048
        Function         : Unknown (00020006)
        Pad 0x01000004   : Source
          Link 0x0200006f: to remote pad 0x1000063 of entity
'ipu1_csi0_mux': Data

...

root@ventana:~# v4l2-compliance -m0 -M
v4l2-compliance SHA   : b2f8f9049056eb6f9e028927dacb2c715a062df8
Media Driver Info:
        Driver name      : imx-media
        Model            : imx-media
        Serial           :
        Bus info         :
        Media version    : 4.15.0
        Hardware revision: 0x00000000 (0)
        Driver version   : 4.15.0

Compliance test for device /dev/media0:

Required ioctls:
        test MEDIA_IOC_DEVICE_INFO: OK

Allow for multiple opens:
        test second /dev/media0 open: OK
        test MEDIA_IOC_DEVICE_INFO: OK
        test for unlimited opens: OK

Media Controller ioctls:
                fail: v4l2-test-media.cpp(141): ent.function ==
MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN
        test MEDIA_IOC_G_TOPOLOGY: FAIL
                fail: v4l2-test-media.cpp(256):
v2_entities_set.find(ent.id) == v2_entities_set.end()
        test MEDIA_IOC_ENUM_ENTITIES/LINKS: FAIL
        test MEDIA_IOC_SETUP_LINK: OK

Total: 7, Succeeded: 5, Failed: 2, Warnings: 0

>
<snip>
>>
>> Sub-Device ioctls (Source Pad 0):
>>       test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK
>>       test Try VIDIOC_SUBDEV_G/S_FMT: OK
>>       test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
>>       test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK
>>       test Active VIDIOC_SUBDEV_G/S_FMT: OK
>>       test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
>>       test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)
>>
>> Control ioctls:
>>       test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK (Not Supported)
>>       test VIDIOC_QUERYCTRL: OK (Not Supported)
>>       test VIDIOC_G/S_CTRL: OK (Not Supported)
>>       test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
>>       test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
>>       test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>>       Standard Controls: 0 Private Controls: 0
>
> Why doesn't this show anything? You have at least one control, so this should
> reflect that. Does 'v4l2-ctl -d /dev/v4l-subdev1 -l' show any controls?
>
> I think sd->ctrl_handler is never set to the v4l2_ctrl_handler pointer.
>
> Have you ever tested the controls?
>
> Looking closer I also notice that the control handler is never freed. Or
> checked for errors when it is created in the probe function. Hmm, I should
> have caught that earlier.
>

Yes thanks - I missed this also:

--- a/drivers/media/i2c/tda1997x.c
+++ b/drivers/media/i2c/tda1997x.c
@@ -2726,6 +2726,12 @@ static int tda1997x_probe(struct i2c_client *client,
                        &tda1997x_ctrl_ops,
                        V4L2_CID_DV_RX_RGB_RANGE, V4L2_DV_RGB_RANGE_FULL, 0,
                        V4L2_DV_RGB_RANGE_AUTO);
+       state->sd.ctrl_handler = hdl;
+       if (hdl->error) {
+               ret = hdl->error;
+               goto err_free_handler;
+       }
+       v4l2_ctrl_handler_setup(hdl);

        /* initialize source pads */
        state->pads[TDA1997X_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
@@ -2774,6 +2780,8 @@ static int tda1997x_probe(struct i2c_client *client,

 err_free_media:
        media_entity_cleanup(&sd->entity);
+err_free_handler:
+       v4l2_ctrl_handler_free(&state->hdl);
 err_free_mutex:
        cancel_delayed_work(&state->delayed_work_enable_hpd);
        mutex_destroy(&state->page_lock);
@@ -2801,6 +2809,7 @@ static int tda1997x_remove(struct i2c_client *client)

        v4l2_async_unregister_subdev(sd);
        media_entity_cleanup(&sd->entity);
+       v4l2_ctrl_handler_free(&state->hdl);
        regulator_bulk_disable(TDA1997X_NUM_SUPPLIES, state->supplies);
        i2c_unregister_device(state->client_cec);
        cancel_delayed_work(&state->delayed_work_enable_hpd);

root@ventana:~# v4l2-ctl -d /dev/v4l-subdev1 --list-ctrls

Digital Video Controls

                  power_present 0x00a00964 (bitmask): max=0x00000001
default=0x00000000 value=0x00000000 flags=read-only
      rx_rgb_quantization_range 0x00a00965 (menu)   : min=0 max=2
default=0 value=2
             rx_it_content_type 0x00a00966 (menu)   : min=0 max=4
default=4 value=0 flags=read-only, volatile

And various sets/gets appear to work as designed (found that I wasn't
updating the csc when quantiation range was changed via ctrl and fixed
it).

Regards,

Tim
