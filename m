Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:33465 "EHLO
        mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751330AbeFFGSR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2018 02:18:17 -0400
Received: by mail-vk0-f47.google.com with SMTP id 200-v6so2992170vkc.0
        for <linux-media@vger.kernel.org>; Tue, 05 Jun 2018 23:18:17 -0700 (PDT)
Received: from mail-vk0-f43.google.com (mail-vk0-f43.google.com. [209.85.213.43])
        by smtp.gmail.com with ESMTPSA id n134-v6sm5651688vkf.7.2018.06.05.23.18.14
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Jun 2018 23:18:15 -0700 (PDT)
Received: by mail-vk0-f43.google.com with SMTP id b77-v6so2981997vkb.5
        for <linux-media@vger.kernel.org>; Tue, 05 Jun 2018 23:18:14 -0700 (PDT)
MIME-Version: 1.0
References: <20180316205512.GA6069@amd> <c2a7e1f3-589d-7186-2a85-545bfa1c4536@xs4all.nl>
 <20180319102354.GA12557@amd> <20180319074715.5b700405@vento.lan>
 <c0fa64ac-4185-0e15-c938-0414e9f07c42@xs4all.nl> <20180319120043.GA20451@amd>
 <ac65858f-7bf3-4faf-6ebd-c898b6107791@xs4all.nl> <20180319095544.7e235a3e@vento.lan>
 <20180515200117.GA21673@amd> <20180515190314.2909e3be@vento.lan> <20180602210145.GB20439@amd>
In-Reply-To: <20180602210145.GB20439@amd>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 6 Jun 2018 15:18:03 +0900
Message-ID: <CAAFQd5ACz1DNW07-vk6rCffC0aNcUG_9+YVNK9HmOTg0+-3yzg@mail.gmail.com>
Subject: Re: [RFC, libv4l]: Make libv4l2 usable on devices with complex pipeline
To: Pavel Machek <pavel@ucw.cz>
Cc: mchehab+samsung@kernel.org, mchehab@s-opensource.com,
        Hans Verkuil <hverkuil@xs4all.nl>, pali.rohar@gmail.com,
        sre@kernel.org, Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

Thanks for coming up with this proposal. Please see my comments below.

On Sun, Jun 3, 2018 at 6:01 AM Pavel Machek <pavel@ucw.cz> wrote:
>
> Hi!
>
> Ok, can I get any comments on this one?
> v4l2_open_complex("/file/with/descriptor", 0) can be used to open
> whole pipeline at once, and work if it as if it was one device.

I'm not convinced if we should really be piggy backing on libv4l, but
it's just a matter of where we put the code added by your patch, so
let's put that aside.

Who would be calling this function?

The scenario that I could think of is:
- legacy app would call open(/dev/video?), which would be handled by
libv4l open hook (v4l2_open()?),
- v4l2_open() would check if given /dev/video? figures in its list of
complex pipelines, for example by calling v4l2_open_complex() and
seeing if it succeeds,
- if it succeeds, the resulting fd would represent the complex
pipeline, otherwise it would just open the requested node directly.

I guess that could give some basic camera functionality on OMAP3-like hardware.

For most of the current generation of imaging subsystems (e.g. Intel
IPU3, Rockchip RKISP1) it's not enough. The reason is that there is
more to be handled by userspace than just setting controls:
 - configuring pixel formats, resolutions, crops, etc. through the
whole pipeline - I guess that could be preconfigured per use case
inside the configuration file, though,
 - forwarding buffers between capture and processing pipelines, i.e.
DQBUF raw frame from CSI2 video node and QBUF to ISP video node,
 - handling metadata CAPTURE and OUTPUT buffers controlling the 3A
feedback loop - this might be optional if all we need is just ability
to capture some frames, but required for getting good quality,
 - actually mapping legacy controls into the above metadata,

I guess it's just a matter of adding further code to handle those,
though. However, it would build up a separate legacy framework that
locks us up into the legacy USB camera model, while we should rather
be leaning towards a more flexible framework, such as Android Camera
HALv3 or Pipewire. On top of such framework, we could just have a very
thin layer to emulate the legacy, single video node, camera.

Other than that, I agree that we should be able to have pre-generated
configuration files and use them to build and setup the pipeline.
That's actually what we have in camera HALs on Chrome OS (Android
camera HALv3 model adopted to Chrome OS).

Some minor comments for the code follow.

[snip]
> +int v4l2_get_fd_for_control(int fd, unsigned long control)
> +{
> +       int index = v4l2_get_index(fd);
> +       struct v4l2_controls_map *map;
> +       int lo = 0;
> +       int hi;
> +
> +       if (index < 0)
> +               return fd;
> +
> +       map = devices[index].map;
> +       if (!map)
> +               return fd;
> +       hi = map->num_controls;
> +
> +       while (lo < hi) {
> +               int i = (lo + hi) / 2;
> +               if (map->map[i].control == control) {
> +                       return map->map[i].fd;
> +               }
> +               if (map->map[i].control > control) {
> +                       hi = i;
> +                       continue;
> +               }
> +               if (map->map[i].control < control) {
> +                       lo = i+1;
> +                       continue;
> +               }
> +               printf("Bad: impossible condition in binary search\n");
> +               exit(1);
> +       }

Could we use bsearch() here?

> +       return fd;
> +}
> +
>  int v4l2_ioctl(int fd, unsigned long int request, ...)
>  {
>         void *arg;
>         va_list ap;
>         int result, index, saved_err;
> -       int is_capture_request = 0, stream_needs_locking = 0;
> +       int is_capture_request = 0, stream_needs_locking = 0,
> +           is_subdev_request = 0;
>
>         va_start(ap, request);
>         arg = va_arg(ap, void *);
> @@ -1076,18 +1115,20 @@ int v4l2_ioctl(int fd, unsigned long int request, ...)
>            ioctl, causing it to get sign extended, depending upon this behavior */
>         request = (unsigned int)request;
>
> +       /* FIXME */
>         if (devices[index].convert == NULL)
>                 goto no_capture_request;
>
>         /* Is this a capture request and do we need to take the stream lock? */
>         switch (request) {
> -       case VIDIOC_QUERYCAP:
>         case VIDIOC_QUERYCTRL:
>         case VIDIOC_G_CTRL:
>         case VIDIOC_S_CTRL:
>         case VIDIOC_G_EXT_CTRLS:
> -       case VIDIOC_TRY_EXT_CTRLS:
>         case VIDIOC_S_EXT_CTRLS:
> +               is_subdev_request = 1;
> +       case VIDIOC_QUERYCAP:
> +       case VIDIOC_TRY_EXT_CTRLS:

I'm not sure why we are moving those around. Is this perhaps related
to the FIXME comment above? If so, it would be helpful to have some
short explanation next to it.

>         case VIDIOC_ENUM_FRAMESIZES:
>         case VIDIOC_ENUM_FRAMEINTERVALS:
>                 is_capture_request = 1;
> @@ -1151,10 +1192,15 @@ int v4l2_ioctl(int fd, unsigned long int request, ...)
>         }
>
>         if (!is_capture_request) {
> +         int sub_fd;
>  no_capture_request:
> +                 sub_fd = fd;
> +               if (is_subdev_request) {
> +                 sub_fd = v4l2_get_fd_for_control(index, ((struct v4l2_queryctrl *) arg)->id);
> +               }

nit: Looks like something weird going on here with indentation.

>                 result = devices[index].dev_ops->ioctl(
>                                 devices[index].dev_ops_priv,
> -                               fd, request, arg);
> +                               sub_fd, request, arg);
>                 saved_err = errno;
>                 v4l2_log_ioctl(request, arg, result);
>                 errno = saved_err;
> @@ -1782,3 +1828,195 @@ int v4l2_get_control(int fd, int cid)
>                         (qctrl.maximum - qctrl.minimum) / 2) /
>                 (qctrl.maximum - qctrl.minimum);
>  }
> +
> +

nit: Double blank line.

> +int v4l2_open_pipeline(struct v4l2_controls_map *map, int v4l2_flags)
> +{
> +       int index;
> +       int i;
> +
> +       for (i=0; i<map->num_controls; i++) {
> +               if (map->map[i].fd <= 0) {
> +                       V4L2_LOG_ERR("v4l2_open_pipeline: Bad fd in map.\n");
> +                       return -1;
> +               }
> +               if (i>=1 && map->map[i].control <= map->map[i-1].control) {
> +                       V4L2_LOG_ERR("v4l2_open_pipeline: Controls not sorted.\n");
> +                       return -1;

I guess we could just sort them at startup with qsort()?

Best regards,
Tomasz
