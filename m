Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35267 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbcFFGGj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jun 2016 02:06:39 -0400
Subject: Re: [PATCH] userspace API definitions for auto-focus coil
To: Pavel Machek <pavel@ucw.cz>, Sakari Ailus <sakari.ailus@iki.fi>
References: <20160524091746.GA14536@amd>
 <20160525212659.GK26360@valkosipuli.retiisi.org.uk>
 <20160527205140.GA26767@amd>
 <20160531212222.GP26360@valkosipuli.retiisi.org.uk>
 <20160531213437.GA28397@amd>
 <20160601152439.GQ26360@valkosipuli.retiisi.org.uk>
 <20160601220840.GA21946@amd>
 <20160602074544.GR26360@valkosipuli.retiisi.org.uk>
 <20160602193027.GB7984@amd>
 <20160602212746.GT26360@valkosipuli.retiisi.org.uk>
 <20160605190716.GA11321@amd>
Cc: pali.rohar@gmail.com, sre@kernel.org,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
	aaro.koskinen@iki.fi, patrikbachan@gmail.com, serge@hallyn.com,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	devicetree@vger.kernel.org
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Message-ID: <575512E5.5030000@gmail.com>
Date: Mon, 6 Jun 2016 09:06:29 +0300
MIME-Version: 1.0
In-Reply-To: <20160605190716.GA11321@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On  5.06.2016 22:07, Pavel Machek wrote:
> Add userspace API definitions.
>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
>
> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> index b6a357a..23011cc 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -974,4 +975,9 @@ enum v4l2_detect_md_mode {
>   #define V4L2_CID_DETECT_MD_THRESHOLD_GRID	(V4L2_CID_DETECT_CLASS_BASE + 3)
>   #define V4L2_CID_DETECT_MD_REGION_GRID		(V4L2_CID_DETECT_CLASS_BASE + 4)
>
> +/* Control IDs specific to the AD5820 driver as defined by V4L2 */
> +#define V4L2_CID_FOCUS_AD5820_BASE 	(V4L2_CTRL_CLASS_CAMERA | 0x10af)
> +#define V4L2_CID_FOCUS_AD5820_RAMP_TIME	(V4L2_CID_FOCUS_AD5820_BASE+0)
> +#define V4L2_CID_FOCUS_AD5820_RAMP_MODE	(V4L2_CID_FOCUS_AD5820_BASE+1)
> +
>   #endif
>

Sakari, what about adding those as standard camera controls? It seems 
ad5820 is not the only VCM driver to implement "antiringing" controls, 
http://rohmfs.rohm.com/en/products/databook/datasheet/ic/motor/mobile_module/bu64241gwz-e.pdf 
is another example I found by quick search.

What about:

#define V4L2_CID_FOCUS_STEP_MODE xxx
enum v4l2_cid_focus_step_mode {
V4L2_CID_FOCUS_STEP_MODE_DIRECT,
V4L2_CID_FOCUS_STEP_MODE_LINEAR,
V4L2_CID_FOCUS_STEP_MODE_AUTO
};
#define V4L2_CID_FOCUS_STEP_TIME xxx+1

Also, how the userspace(or the kernel) is notified by v4l that there is 
an event? The point is - I think it is a good idea to notify when VCM 
has completed its movement, we can start a timer based on the current 
position, mode, step time etc and notify after the pre-calculated 
movement time.

Here ftp://ftp.analog.com/pub/evalcd/AD5820_v1_0/AD5820_Quickstart.pdf 
can be found the modes/timings description for ad5820 along with the 
equations needed to calculate timings etc.

Ivo



