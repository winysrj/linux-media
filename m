Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:51170 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751923AbeEGQeJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2018 12:34:09 -0400
Received: by mail-it0-f66.google.com with SMTP id p3-v6so12534661itc.0
        for <linux-media@vger.kernel.org>; Mon, 07 May 2018 09:34:09 -0700 (PDT)
Subject: Re: [PATCH v3 00/13] media: imx: Switch to subdev notifiers
To: Hans Verkuil <hverkuil@xs4all.nl>, Yong Zhi <yong.zhi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        niklas.soderlund@ragnatech.se, Sebastian Reichel <sre@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
References: <1521592649-7264-1-git-send-email-steve_longerbeam@mentor.com>
 <9bdfbbf3-abcd-dd2e-506e-aa3ee6f14bc3@xs4all.nl>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <6826b8d8-9085-99c7-bdca-c173550685cb@gmail.com>
Date: Mon, 7 May 2018 09:34:05 -0700
MIME-Version: 1.0
In-Reply-To: <9bdfbbf3-abcd-dd2e-506e-aa3ee6f14bc3@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 05/07/2018 07:20 AM, Hans Verkuil wrote:
> Steve, Sakari,
>
> Any progress on this? The imx7 patch series depends on this so that can't
> move forward until this is merged.

Hi Hans, I've been working on the updates and will submit v4 today.

Steve


>
>
> On 21/03/18 01:37, Steve Longerbeam wrote:
>> This patchset converts the imx-media driver and its dependent
>> subdevs to use subdev notifiers.
>>
>> There are a couple shortcomings in v4l2-core that prevented
>> subdev notifiers from working correctly in imx-media:
>>
>> 1. v4l2_async_notifier_fwnode_parse_endpoint() treats a fwnode
>>     endpoint that is not connected to a remote device as an error.
>>     But in the case of the video-mux subdev, this is not an error,
>>     it is OK if some of the mux inputs have no connection. Also,
>>     Documentation/devicetree/bindings/media/video-interfaces.txt explicitly
>>     states that the 'remote-endpoint' property is optional. So the first
>>     patch is a small modification to ignore empty endpoints in
>>     v4l2_async_notifier_fwnode_parse_endpoint() and allow
>>     __v4l2_async_notifier_parse_fwnode_endpoints() to continue to
>>     parse the remaining port endpoints of the device.
>>
>> 2. In the imx-media graph, multiple subdevs will encounter the same
>>     upstream subdev (such as the imx6-mipi-csi2 receiver), and so
>>     v4l2_async_notifier_parse_fwnode_endpoints() will add imx6-mipi-csi2
>>     multiple times. This is treated as an error by
>>     v4l2_async_notifier_register() later.
>>
>>     To get around this problem, add an v4l2_async_notifier_add_subdev()
>>     which first verifies the provided asd does not already exist in the
>>     given notifier asd list or in other registered notifiers. If the asd
>>     exists, the function returns -EEXIST and it's up to the caller to
>>     decide if that is an error (in imx-media case it is never an error).
>>
>>     Patches 2-4 deal with adding that support.
>>
>> 3. Patch 5 adds v4l2_async_register_fwnode_subdev(), which is a
>>     convenience function for parsing a subdev's fwnode port endpoints
>>     for connected remote subdevs, registering a subdev notifier, and
>>     then registering the sub-device itself.
>>
>> The remaining patches update the subdev drivers to register a
>> subdev notifier with endpoint parsing, and the changes to imx-media
>> to support that.
>>
>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>> Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
>>
>> History:
>> v3:
>> - code optimization in asd_equal(), and remove unneeded braces,
>>    suggested by Sakari Ailus.
>> - add a NULL asd pointer check to v4l2_async_notifier_asd_valid().
>> - fix an error-out path in v4l2_async_register_fwnode_subdev() that
>>    forgot to put device.
>>
>> v2:
>> - don't pass an empty endpoint to the parse_endpoint callback,
>>    v4l2_async_notifier_fwnode_parse_endpoint() now just ignores them
>>    and returns success.
>> - Fix a couple compile warnings and errors seen in i386 and sh archs.
>>
>>
>> Steve Longerbeam (13):
>>    media: v4l2-fwnode: ignore endpoints that have no remote port parent
>>    media: v4l2: async: Allow searching for asd of any type
>>    media: v4l2: async: Add v4l2_async_notifier_add_subdev
>>    media: v4l2-fwnode: Switch to v4l2_async_notifier_add_subdev
>>    media: v4l2-fwnode: Add a convenience function for registering subdevs
>>      with notifiers
>>    media: platform: video-mux: Register a subdev notifier
>>    media: imx: csi: Register a subdev notifier
>>    media: imx: mipi csi-2: Register a subdev notifier
>>    media: staging/imx: of: Remove recursive graph walk
>>    media: staging/imx: Loop through all registered subdevs for media
>>      links
>>    media: staging/imx: Rename root notifier
>>    media: staging/imx: Switch to v4l2_async_notifier_add_subdev
>>    media: staging/imx: TODO: Remove one assumption about OF graph parsing
>>
>>   drivers/media/pci/intel/ipu3/ipu3-cio2.c          |  10 +-
>>   drivers/media/platform/video-mux.c                |  36 ++-
>>   drivers/media/v4l2-core/v4l2-async.c              | 268 ++++++++++++++++------
>>   drivers/media/v4l2-core/v4l2-fwnode.c             | 231 +++++++++++--------
>>   drivers/staging/media/imx/TODO                    |  29 +--
>>   drivers/staging/media/imx/imx-media-csi.c         |  11 +-
>>   drivers/staging/media/imx/imx-media-dev.c         | 134 +++--------
>>   drivers/staging/media/imx/imx-media-internal-sd.c |   5 +-
>>   drivers/staging/media/imx/imx-media-of.c          | 106 +--------
>>   drivers/staging/media/imx/imx-media.h             |   6 +-
>>   drivers/staging/media/imx/imx6-mipi-csi2.c        |  31 ++-
>>   include/media/v4l2-async.h                        |  24 +-
>>   include/media/v4l2-fwnode.h                       |  65 +++++-
>>   13 files changed, 534 insertions(+), 422 deletions(-)
>>
