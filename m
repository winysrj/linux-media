Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48074 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab3EOBcZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 May 2013 21:32:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: jean-philippe francois <jp.francois@cynove.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: omap3-isp : panic using previewer from V4L input
Date: Wed, 15 May 2013 03:32:43 +0200
Message-ID: <1579245.NgheaxZSaI@avalon>
In-Reply-To: <CAGGh5h0eAdk+2pHcNn+xBgpvWmGgTa87_WN5GP-64Gexm-oK_Q@mail.gmail.com>
References: <CAGGh5h00H10F7GWgjyhN_5Zn8JNMXRptt4FF+u=NHDdTXFD2MA@mail.gmail.com> <CAGGh5h1zzF7mKgof=jcEBHVmnG9i-A=xpzc9Ri8bHL5xe7bnuQ@mail.gmail.com> <CAGGh5h0eAdk+2pHcNn+xBgpvWmGgTa87_WN5GP-64Gexm-oK_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean-Philippe,

On Tuesday 14 May 2013 11:29:39 jean-philippe francois wrote:
> Hi Laurent,
> 
> I have a beagle xm board, but no sensor board. Is it possible to have
> the omap3-isp initialised ?

Yes it is. You will just need to call omap3_init_camera() in your board code 
with a pointer to platform data that contain an empty list of subdevs. 
Something like

static struct isp_v4l2_subdevs_group beagle_camera_subdevs[] = {
	{ },
};

static struct isp_platform_data beagle_isp_platform_data = {
	.subdevs = beagle_camera_subdevs,
};

static int __init beagle_camera_init(void)
{
	if (!machine_is_omap3_beagle())
		return 0;

	omap3_init_camera(&beagle_isp_platform_data);

	return 0;
}
late_initcall(beagle_camera_init);

should do (you will also need to include the appropriate headers).

> I would like to try my program on a beagle board to eliminate any
> hardware related problem.
> From the board file in mainline kernel, it seems omap3_init_camera is
> not called, do you know any kernel tree where isp is initialized for beagle
> board ?

-- 
Regards,

Laurent Pinchart

