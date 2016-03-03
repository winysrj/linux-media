Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:41058 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753236AbcCCHUC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Mar 2016 02:20:02 -0500
Subject: Re: i.mx6 camera interface (CSI) and mainline kernel
To: Steve Longerbeam <steve_longerbeam@mentor.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Philippe De Muyter <phdm@macq.eu>
References: <20160223114943.GA10944@frolo.macqel>
 <20160223141258.GA5097@frolo.macqel> <4956050.OLrYA1VK2G@avalon>
 <56D79B49.50009@mentor.com>
Cc: linux-media@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56D7E59B.6050605@xs4all.nl>
Date: Thu, 3 Mar 2016 08:19:55 +0100
MIME-Version: 1.0
In-Reply-To: <56D79B49.50009@mentor.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/03/2016 03:02 AM, Steve Longerbeam wrote:
> On 02/25/2016 02:05 PM, Laurent Pinchart wrote:
>> Hello Philippe,
>>
>> CC'ing Philipp and Steve.
>>
>> Philipp, Steve, are you still interested in getting a driver for the i.MX6 
>> camera interface upstreamed ?
> 
> Hi Laurent, Philippe(s),
> 
> I spent a few days updating my mx6-media-staging branch at
> git@github.com:slongerbeam/linux-meibp-314.git, moved forward
> to latest master at 4.5-rc3.
> 
> So far I have retested video capture with the SabreAuto/ADV7180 and
> the SabreSD/OV5640-mipi-csi2, and video capture is working fine on
> those platforms.
> 
> There is also a mem2mem that should work fine, but haven't tested yet.
> 
> I removed camera preview support. At Mentor Graphics we have made
> quite a few changes to ipu-v3 driver to allow camera preview to initialize
> and control an overlay display plane independently of imx-drm, by adding
> a subsystem independent ipu-plane sub-unit. Note we also have a video
> output overlay driver that also makes use of ipu-plane. But those changes are
> extensive and touch imx-drm as well as ipu-v3, so I am leaving camera preview
> and the output overlay driver out (in fact, camera preview is not of much
> utility so I probably won't bring it back in upstream version).
> 
> The video capture driver is not quite ready for upstream review yet. It still:
> 
> - uses the old cropping APIs but should move forward to selection APIs.
> 
> - uses custom sensor subdev drivers for ADV7180 and OV564x. Still
>   need to switch to upstream subdevs.
> 
> - still does not implement the media device framework.

After fixing the first two items on that list, would that be a good time to
add this driver to staging?

i.MX6 is quite popular, so having support for this device upstream would be
very nice indeed.

I'd really like to see some upstream support for this SoC soon.

Regards,

	Hans

> 
> 
> Steve
> 
>>
>> On Tuesday 23 February 2016 15:12:58 Philippe De Muyter wrote:
>>> Update.
>>>
>>> On Tue, Feb 23, 2016 at 12:49:43PM +0100, Philippe De Muyter wrote:
>>>> Hello,
>>>>
>>>> We use a custom imx6 based board with a canera sensor on it.
>>>> I have written the driver for the camera sensor, based on
>>>> the freescale so-called "3.10" and even "3.14" linux versions.
>>>>
>>>> The camera works perfectly, but we would like to switch to
>>>> a mainline kernel for all the usual reasons (including being
>>>> able to contribute our fixes).
>>>>
>>>> >From an old mail thread (*), I have found two git repositories
>>>>
>>>> that used to contain not-yet-approved versions of mainline
>>>> imx6 ipu-v3 drivers :
>>>>
>>>> git://git.pengutronix.de/git/pza/linux.git test/nitrogen6x-ipu-media
>>>> https://github.com:slongerbeam/mediatree.git, mx6-camera-staging
>>>>
>>>> I have tried to compile them with the imx_v6_v7_defconfig, but both
>>>> fail directly at compile time. because of later changes in the
>>>> v4l2_subdev infrastructure, not ported to the those branches.
>>> What I wrote is true for Steve Longerbeam's branch, but for Philipp Zabel's
>>> branch the problem (so far) was only that CONFIG_MEDIA_CONTROLLER
>>> is not defined in imx_v6_v7_defconfig, but is required for a succesfull
>>> compilation of Philipp's tree.
>>>
>>>> Can someone point me to compilable versions (either not rebased
>>>> versions of those branches, or updated versions of those branches,
>>>> or yet another place to look at). ?
>>>>
>>>> Thanks in advance
>>>>
>>>> Philippe
>>>>
>>>> (*)
>>>> http://linux-media.vger.kernel.narkive.com/cZQ8NrZ2/i-mx6-status-for-ipu-> > vpu-gpu
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

