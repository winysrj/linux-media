Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:34881 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417Ab3AJLcR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jan 2013 06:32:17 -0500
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Inki Dae <inki.dae@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: sunil joshi <joshi@samsung.com>, dri-devel@lists.freedesktop.org,
	Rob Clark <rob.clark@linaro.org>, tomi.valkeinen@ti.com,
	aditya.ps@samsung.com, Vikas Sajjan <vikas.sajjan@linaro.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] [RFC] video: display: Adding frame related ops to MIPI DSI video source struct
In-Reply-To: <CAAQKjZMsH3xNdTD5D7L90KJhYforgEvL0_6rBKXNyPyB_P04iQ@mail.gmail.com>
References: <1357132642-24588-1-git-send-email-vikas.sajjan@linaro.org> <67872310.6yRVsVsClR@amdc1227> <CAD025yQHuW3O-Wqwjjsf79UcXjxezUZEwoY-P1J5Fqb+OB+gHA@mail.gmail.com> <3145597.3X0nZfdYRE@avalon> <CAAQKjZMsH3xNdTD5D7L90KJhYforgEvL0_6rBKXNyPyB_P04iQ@mail.gmail.com>
Date: Thu, 10 Jan 2013 13:33:11 +0200
Message-ID: <87ehhtxog8.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 10 Jan 2013, Inki Dae <inki.dae@samsung.com> wrote:
> 2013/1/10 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
>> Hi Vikas,
>>
>> Thank you for the patch.
>>
>> On Friday 04 January 2013 10:24:04 Vikas Sajjan wrote:
>>> On 3 January 2013 16:29, Tomasz Figa <t.figa@samsung.com> wrote:
>>> > On Wednesday 02 of January 2013 18:47:22 Vikas C Sajjan wrote:
>>> >> From: Vikas Sajjan <vikas.sajjan@linaro.org>
>>> >>
>>> >> Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
>>> >> ---
>>> >>
>>> >>  include/video/display.h |    6 ++++++
>>> >>  1 file changed, 6 insertions(+)
>>> >>
>>> >> diff --git a/include/video/display.h b/include/video/display.h
>>> >> index b639fd0..fb2f437 100644
>>> >> --- a/include/video/display.h
>>> >> +++ b/include/video/display.h
>>> >> @@ -117,6 +117,12 @@ struct dsi_video_source_ops {
>>> >>
>>> >>       void (*enable_hs)(struct video_source *src, bool enable);
>>> >>
>>> >> +     /* frame related */
>>> >> +     int (*get_frame_done)(struct video_source *src);
>>> >> +     int (*clear_frame_done)(struct video_source *src);
>>> >> +     int (*set_early_blank_mode)(struct video_source *src, int power);
>>> >> +     int (*set_blank_mode)(struct video_source *src, int power);
>>> >> +
>>> >
>>> > I'm not sure if all those extra ops are needed in any way.
>>> >
>>> > Looking and Exynos MIPI DSIM driver, set_blank_mode is handling only
>>> > FB_BLANK_UNBLANK status, which basically equals to the already existing
>>> > enable operation, while set_early_blank mode handles only
>>> > FB_BLANK_POWERDOWN, being equal to disable callback.
>>>
>>> Right, exynos_mipi_dsi_blank_mode() only supports FB_BLANK_UNBLANK as
>>> of now, but FB_BLANK_NORMAL will be supported in future.
>>> If not for Exynos, i think it will be need for other SoCs which
>>> support FB_BLANK_UNBLANK and FB_BLANK_NORMAL.
>>
>> Could you please explain in a bit more details what the set_early_blank_mode
>> and set_blank_mode operations do ?
>>
>>> > Both get_frame_done and clear_frame_done do not look at anything used at
>>> > the moment and if frame done status monitoring will be ever needed, I
>>> > think a better way should be implemented.
>>>
>>> You are right, as of now Exynos MIPI DSI Panels are NOT using these
>>> callbacks, but as you mentioned we will need frame done status monitoring
>>> anyways, so i included these callbacks here. Will check, if we can implement
>>> any better method.
>>
>> Do you expect the entity drivers (and in particular the panel drivers) to
>> require frame done notification ? If so, could you explain your use case(s) ?
>>
>
> Hi Laurent,
>
> As you know, there are two types of MIPI-DSI based lcd panels, RGB and
> CPU mode. In case of CPU mode lcd panel, it has its own framebuffer
> internally and the image in the framebuffer is transferred on lcd
> panel in 60Hz itself. But for this, there is something we should
> consider. The display controller with CPU mode doens't transfer image
> data to MIPI-DSI controller itself. So we should set trigger bit of
> the display controller to 1 to do it and also check whether the data
> transmission in the framebuffer is done on lcd panel to avoid tearing
> issue and some confliction issue(A) between read and write operations
> like below,

Quite right. Just to elaborate, in the MIPI DSI spec the two types are
called Video Mode and Command Mode display modules, of which the latter
has a framebuffer of its own. Update of the display module framebuffer
has to dodge the scanning of the buffer by the display module's
controller to avoid tearing. For that, info about the controller's
scanline is required. There are basically three ways for this:

1) polling the scanline using DCS get_scan_line command

2) enabling tearing effect reporting, and turning over bus ownership to
the display module for subsequent tearing effect signal (vertical
blanking) reporting by the module at the specified scanline

3) external GPIO line (outside of DSI PHY spec) to report tearing effect
signal

For an example, drivers/video/omap2/displays/panel-taal.c supports
option #2 via OMAP DSI and option #3 independently.


BR,
Jani.


>
> lcd_panel_frame_done_interrrupt_handler()
> {
>         ...
>         if (mipi-dsi frame done)
>                 trigger display controller;
>         ...
> }
>
> A. the issue that LCD panel can access its own framebuffer while some
> new data from MIPI-DSI controller is being written in the framebuffer.
>
> But I think there might be better way to avoid such thing.
>
> Thanks,
> Inki Dae
>
>> --
>> Regards,
>>
>> Laurent Pinchart
>>
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> http://lists.freedesktop.org/mailman/listinfo/dri-devel
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
