Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:64847 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab3AJFhO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jan 2013 00:37:14 -0500
Received: by mail-lb0-f181.google.com with SMTP id ge1so193529lbb.40
        for <linux-media@vger.kernel.org>; Wed, 09 Jan 2013 21:37:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <3145597.3X0nZfdYRE@avalon>
References: <1357132642-24588-1-git-send-email-vikas.sajjan@linaro.org>
	<67872310.6yRVsVsClR@amdc1227>
	<CAD025yQHuW3O-Wqwjjsf79UcXjxezUZEwoY-P1J5Fqb+OB+gHA@mail.gmail.com>
	<3145597.3X0nZfdYRE@avalon>
Date: Thu, 10 Jan 2013 11:07:12 +0530
Message-ID: <CAD025yRoraqb_zvxfX-oNKHXpM7v=d9S1XUfNs2PLrP8fM3wYA@mail.gmail.com>
Subject: Re: [PATCH 2/2] [RFC] video: display: Adding frame related ops to
 MIPI DSI video source struct
From: Vikas Sajjan <vikas.sajjan@linaro.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Tomasz Figa <t.figa@samsung.com>, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, inki.dae@samsung.com,
	tomi.valkeinen@ti.com, aditya.ps@samsung.com,
	sunil joshi <joshi@samsung.com>,
	Jesse Barker <jesse.barker@linaro.org>,
	Rob Clark <rob.clark@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 10 January 2013 05:05, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Vikas,
>
> Thank you for the patch.
>
> On Friday 04 January 2013 10:24:04 Vikas Sajjan wrote:
>> On 3 January 2013 16:29, Tomasz Figa <t.figa@samsung.com> wrote:
>> > On Wednesday 02 of January 2013 18:47:22 Vikas C Sajjan wrote:
>> >> From: Vikas Sajjan <vikas.sajjan@linaro.org>
>> >>
>> >> Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
>> >> ---
>> >>
>> >>  include/video/display.h |    6 ++++++
>> >>  1 file changed, 6 insertions(+)
>> >>
>> >> diff --git a/include/video/display.h b/include/video/display.h
>> >> index b639fd0..fb2f437 100644
>> >> --- a/include/video/display.h
>> >> +++ b/include/video/display.h
>> >> @@ -117,6 +117,12 @@ struct dsi_video_source_ops {
>> >>
>> >>       void (*enable_hs)(struct video_source *src, bool enable);
>> >>
>> >> +     /* frame related */
>> >> +     int (*get_frame_done)(struct video_source *src);
>> >> +     int (*clear_frame_done)(struct video_source *src);
>> >> +     int (*set_early_blank_mode)(struct video_source *src, int power);
>> >> +     int (*set_blank_mode)(struct video_source *src, int power);
>> >> +
>> >
>> > I'm not sure if all those extra ops are needed in any way.
>> >
>> > Looking and Exynos MIPI DSIM driver, set_blank_mode is handling only
>> > FB_BLANK_UNBLANK status, which basically equals to the already existing
>> > enable operation, while set_early_blank mode handles only
>> > FB_BLANK_POWERDOWN, being equal to disable callback.
>>
>> Right, exynos_mipi_dsi_blank_mode() only supports FB_BLANK_UNBLANK as
>> of now, but FB_BLANK_NORMAL will be supported in future.
>> If not for Exynos, i think it will be need for other SoCs which
>> support FB_BLANK_UNBLANK and FB_BLANK_NORMAL.
>
> Could you please explain in a bit more details what the set_early_blank_mode
> and set_blank_mode operations do ?
>

with reference to Mr. Inki Dae's patch and discussion
http://lkml.indiana.edu/hypermail/linux/kernel/1109.1/00413.html
http://lkml.indiana.edu/hypermail/linux/kernel/1109.1/02247.html

set_early_blank_mode:
  - sets the framebuffer blank mode.
  - this callback should be called prior to fb_blank() by a client
driver only if needed
set_blank_mode:
  - sets framebuffer blank mode
  -  this callback should be called after fb_blank() by a client
driver only if needed.

In case of MIPI-DSI based video mode LCD Panel, for lcd power off, the
power off commands should be transferred to lcd panel with display and
mipi-dsi controller enabled, because the commands is set to lcd panel
at vsync porch period, hence set_early_blank_mode() was introduced and
should be called prior to fb_blank() as mentioned in the above 2
links.

I think Mr. Inki Dae can throw more light on this.

>> > Both get_frame_done and clear_frame_done do not look at anything used at
>> > the moment and if frame done status monitoring will be ever needed, I
>> > think a better way should be implemented.
>>
>> You are right, as of now Exynos MIPI DSI Panels are NOT using these
>> callbacks, but as you mentioned we will need frame done status monitoring
>> anyways, so i included these callbacks here. Will check, if we can implement
>> any better method.
>
> Do you expect the entity drivers (and in particular the panel drivers) to
> require frame done notification ? If so, could you explain your use case(s) ?
>
In our Exynos MIPI DSIM H/W, once MIPI DSIM transfers whole image
frame, interrupt will raised to indicate the same.
as part of the mipi_dsim_master_ops() we have get_dsim_frame_done()
and clear_dsim_frame_done() ops. But as of now we are also _NOT_ using
these ops in any particular use case. So i guess as of now we can park
it, later if we find any need for the same we can add it.

> --
> Regards,
>
> Laurent Pinchart
>

--
Thanks and Regards
 Vikas Sajjan
 SAMSUNG Research India - Banglore.
