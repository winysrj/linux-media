Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:4842 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751060AbdB1OAi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 09:00:38 -0500
Subject: Re: [PATCH 4/6] omap3isp: Disable streaming at driver unbind time
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
References: <1487604142-27610-1-git-send-email-sakari.ailus@linux.intel.com>
 <1487604142-27610-5-git-send-email-sakari.ailus@linux.intel.com>
 <1825906.3DC6oLSMPM@avalon>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <a9989567-8792-480d-88e0-73ddecf0a742@linux.intel.com>
Date: Tue, 28 Feb 2017 16:00:01 +0200
MIME-Version: 1.0
In-Reply-To: <1825906.3DC6oLSMPM@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> Hi Sakari,
>
> Thank you for the patch.
>
> On Monday 20 Feb 2017 17:22:20 Sakari Ailus wrote:
>> Once the driver is unbound accessing the hardware is not allowed anymore.
>> Due to this, disable streaming when the device driver is unbound. The
>> states of the associated objects related to Media controller and videobuf2
>> frameworks are updated as well, just like if the application disabled
>> streaming explicitly.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>
> This looks mostly good to me, although I'm a bit concerned about race
> conditions related to buffer handling. I don't think this patch introduces any
> new one though, so
>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>
> We'll have to go through buffer management at some point in the near future,
> including from a V4L2 API point of view I think.

Thanks for the review!

Are you happy with me sending a pull request on the set, or would you 
prefer to pick the omap3isp patches? In the latter case I'll send a fix 
for the issue in the first patch.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
