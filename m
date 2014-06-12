Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:65346 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616AbaFLBEZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jun 2014 21:04:25 -0400
Message-ID: <5398FC95.1070504@mentor.com>
Date: Wed, 11 Jun 2014 18:04:21 -0700
From: Steve Longerbeam <steve_longerbeam@mentor.com>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>,
	Steve Longerbeam <slongerbeam@gmail.com>
CC: <linux-media@vger.kernel.org>
Subject: Re: [PATCH 00/43] i.MX6 Video capture
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com> <1402485696.4107.107.camel@paszta.hi.pengutronix.de>
In-Reply-To: <1402485696.4107.107.camel@paszta.hi.pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/11/2014 04:21 AM, Philipp Zabel wrote:
> Hi Steve,
> 
> Am Samstag, den 07.06.2014, 14:56 -0700 schrieb Steve Longerbeam:
>> Hi all,
>>
>> This patch set adds video capture support for the Freescale i.MX6 SOC.
>>
>> It is a from-scratch standardized driver that works with community
>> v4l2 utilities, such as v4l2-ctl, v4l2-cap, and the v4l2src gstreamer
>> plugin. It uses the latest v4l2 interfaces (subdev, videobuf2).
>> Please see Documentation/video4linux/mx6_camera.txt for it's full list
>> of features!
> 
> That's quite a series to digest! I'll quickly go over the points that
> jumped at me and then look at the core code (especially 08/43 and 39/43)
> in detail.
> 
>> The first 38 patches:
>>
>> - prepare the ipu-v3 driver for video capture support. The current driver
>>   contains only video display functionality to support the imx DRM drivers.
>>   At some point ipu-v3 should be moved out from under staging/imx-drm since
>>   it will no longer only support DRM.
> 
> The move out of staging is now merged into drm-next with
> c1a6e9fe82b46159af8cc4cf34fb51ee47862f05.
> After this is merged into mainline, there should be no need to push i.MX
> capture support through staging. It would be helpful if you could rebase
> on top of that.
> 


Hi Philipp and Sascha,

First of all, thanks for the detailed review.

I think it's obvious that this patch set should be split into two: first,
the changes to IPU core driver submitted to drm-next, and the capture driver
to media-tree.

Or, do you prefer I submit the IPU core patches to your own pengutronix git
tree, and we can correspond on one of your internal mailing lists? I can
then leave it to you to push those changes to drm-next.

I agree with most of your feedback, and most is specific to the IPU core
changes. We can discuss those in detail elsewhere, but just in summary here,
some of your comments seem to conflict:

1. Regarding the input muxes to the CSI and IC, Philipp you acked those
functions but would like to see these muxes as v4l2 subdevs and configured
in the DT, but Sascha, you had a comment that this should be a job for
mediactrl.

2. Philipp, you would like to see CSI, IC, and SMFC units moved out of IPU
core and become v4l2 subdevs. I agree with that, but drm-next has ipu-smfc
as part of IPU core, and SMFC is most definitely v4l2 capture specific.


Steve
