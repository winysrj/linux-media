Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:50868 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab3ADEyG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Jan 2013 23:54:06 -0500
Received: by mail-la0-f49.google.com with SMTP id fk20so8922125lab.8
        for <linux-media@vger.kernel.org>; Thu, 03 Jan 2013 20:54:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <67872310.6yRVsVsClR@amdc1227>
References: <1357132642-24588-1-git-send-email-vikas.sajjan@linaro.org>
	<1357132642-24588-3-git-send-email-vikas.sajjan@linaro.org>
	<67872310.6yRVsVsClR@amdc1227>
Date: Fri, 4 Jan 2013 10:24:04 +0530
Message-ID: <CAD025yQHuW3O-Wqwjjsf79UcXjxezUZEwoY-P1J5Fqb+OB+gHA@mail.gmail.com>
Subject: Re: [PATCH 2/2] [RFC] video: display: Adding frame related ops to
 MIPI DSI video source struct
From: Vikas Sajjan <vikas.sajjan@linaro.org>
To: Tomasz Figa <t.figa@samsung.com>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	inki.dae@samsung.com, tomi.valkeinen@ti.com,
	laurent.pinchart@ideasonboard.com, aditya.ps@samsung.com,
	sunil joshi <joshi@samsung.com>,
	Jesse Barker <jesse.barker@linaro.org>,
	Rob Clark <rob.clark@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mr. Figa,

Thanks for reviewing.

On 3 January 2013 16:29, Tomasz Figa <t.figa@samsung.com> wrote:
> Hi Vikas,
>
> On Wednesday 02 of January 2013 18:47:22 Vikas C Sajjan wrote:
>> From: Vikas Sajjan <vikas.sajjan@linaro.org>
>>
>> Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
>> ---
>>  include/video/display.h |    6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/include/video/display.h b/include/video/display.h
>> index b639fd0..fb2f437 100644
>> --- a/include/video/display.h
>> +++ b/include/video/display.h
>> @@ -117,6 +117,12 @@ struct dsi_video_source_ops {
>>
>>       void (*enable_hs)(struct video_source *src, bool enable);
>>
>> +     /* frame related */
>> +     int (*get_frame_done)(struct video_source *src);
>> +     int (*clear_frame_done)(struct video_source *src);
>> +     int (*set_early_blank_mode)(struct video_source *src, int power);
>> +     int (*set_blank_mode)(struct video_source *src, int power);
>> +
>
> I'm not sure if all those extra ops are needed in any way.
>
> Looking and Exynos MIPI DSIM driver, set_blank_mode is handling only
> FB_BLANK_UNBLANK status, which basically equals to the already existing
> enable operation, while set_early_blank mode handles only
> FB_BLANK_POWERDOWN, being equal to disable callback.
>

Right, exynos_mipi_dsi_blank_mode() only supports FB_BLANK_UNBLANK as
of now, but FB_BLANK_NORMAL will be supported in future.
If not for Exynos, i think it will be need for other SoCs which
support  FB_BLANK_UNBLANK and FB_BLANK_NORMAL.

> Both get_frame_done and clear_frame_done do not look at anything used at
> the moment and if frame done status monitoring will be ever needed, I
> think a better way should be implemented.
>
You are right, as of now Exynos MIPI DSI Panels are NOT using these
callbacks, but as you mentioned we will need frame done status
monitoring anyways, so i included these callbacks here. Will check, if
we can implement any better method.

> Best regards,
> --
> Tomasz Figa
> Samsung Poland R&D Center
> SW Solution Development, Linux Platform
>



-- 
Thanks and Regards
 Vikas Sajjan
