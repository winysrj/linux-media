Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:60196 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751237AbdISLEl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 07:04:41 -0400
Subject: Re: [PATCH v13 01/25] v4l: fwnode: Move KernelDoc documentation to
 the header
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, robh@kernel.org,
        devicetree@vger.kernel.org, pavel@ucw.cz, sre@kernel.org
References: <20170915141724.23124-1-sakari.ailus@linux.intel.com>
 <20170915141724.23124-2-sakari.ailus@linux.intel.com>
 <9077921.hsjkiRftLf@avalon>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <29354478-ec46-278b-c457-4e6f3cc6848c@xs4all.nl>
Date: Tue, 19 Sep 2017 13:04:36 +0200
MIME-Version: 1.0
In-Reply-To: <9077921.hsjkiRftLf@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/19/17 12:48, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Friday, 15 September 2017 17:17:00 EEST Sakari Ailus wrote:
>> In V4L2 the practice is to have the KernelDoc documentation in the header
>> and not in .c source code files. This consequently makes the V4L2 fwnode
>> function documentation part of the Media documentation build.
>>
>> Also correct the link related function and argument naming in
>> documentation.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
>> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>> Acked-by: Pavel Machek <pavel@ucw.cz>
> 
> I'm still very opposed to this. In addition to increasing the risk of 
> documentation becoming stale, it also makes review more difficult. I'm 
> reviewing patch 05/25 of this series and I have to jump around the patch to 
> verify that the documentation matches the implementation, it's really 
> annoying.
> 
> We should instead move all function documentation from header files to source 
> files.

I disagree with this. Yes, it makes reviewing harder, but when you have to
*use* these functions as e.g. a driver developer, then having it in the
header is much more convenient.

Regards,

	Hans

> 
>> ---
>>  drivers/media/v4l2-core/v4l2-fwnode.c | 75 --------------------------------
>> include/media/v4l2-fwnode.h            | 81 +++++++++++++++++++++++++++++++-
>> 2 files changed, 80 insertions(+), 76 deletions(-)
> 
> [snip]
> 
