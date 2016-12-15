Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:39815
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756588AbcLOWvt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 17:51:49 -0500
Subject: Re: [PATCH 2/2] media: omap3isp change to devm for resources
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        sakari.ailus@linux.intel.com
References: <cover.1481829721.git.shuahkh@osg.samsung.com>
 <98a3d1794bc001f312a7db31ad03465ba697bb36.1481829722.git.shuahkh@osg.samsung.com>
 <2731467.skKvVxvkgN@avalon>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <03073060-1166-7f61-8b3f-287a9f148b40@osg.samsung.com>
Date: Thu, 15 Dec 2016 15:51:41 -0700
MIME-Version: 1.0
In-Reply-To: <2731467.skKvVxvkgN@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/15/2016 03:33 PM, Laurent Pinchart wrote:
> Hi Shuah,
> 
> Thank you for the patch.
> 
> Sakari has submitted a similar patch as part of his kref series. Please use it 
> as a base point and rework it if you want to get it merged separately. I've 
> reviewed the patch and left quite a few comments that need to be addressed.
> 

I really don't mind if Sakari uses this patch as is and makes the changes
you requested and submits devm removal as an independent patch.

My intent behind sending this one is to help him out since I already did
this patch that is on top of 4.9-rc8 without any dependencies on Sakari's
RFC patch.

thanks,
-- Shuah

> On Thursday 15 Dec 2016 12:40:08 Shuah Khan wrote:
>> Using devm resources that have external dependencies such as a dev
>> for a file handler could result in devm resources getting released
>> durin unbind while an application has the file open holding pointer
>> to the devm resource. This results in use-after-free errors when the
>> application exits.
>>
>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>> ---
>>  drivers/media/platform/omap3isp/isp.c         | 71 ++++++++++++++++--------
>>  drivers/media/platform/omap3isp/ispccp2.c     | 10 +++-
>>  drivers/media/platform/omap3isp/isph3a_aewb.c | 21 +++++---
>>  drivers/media/platform/omap3isp/isph3a_af.c   | 21 +++++---
>>  drivers/media/platform/omap3isp/isphist.c     |  5 +-
>>  5 files changed, 92 insertions(+), 36 deletions(-)
> 

