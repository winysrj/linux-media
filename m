Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:54477 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729387AbeK0UGY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 15:06:24 -0500
Subject: Re: [PATCH 1/3] media: imx274: don't declare events, they are not
 implemented
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
References: <20181127083445.27737-1-luca@lucaceresoli.net>
 <20181127083859.zljff4wk4hikel56@paasikivi.fi.intel.com>
From: Luca Ceresoli <luca@lucaceresoli.net>
Message-ID: <dcd7ded2-7876-c017-0d8c-1f3d159e5d2f@lucaceresoli.net>
Date: Tue, 27 Nov 2018 10:09:08 +0100
MIME-Version: 1.0
In-Reply-To: <20181127083859.zljff4wk4hikel56@paasikivi.fi.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 27/11/18 09:38, Sakari Ailus wrote:
> Hi Luca,
> 
> On Tue, Nov 27, 2018 at 09:34:43AM +0100, Luca Ceresoli wrote:
>> The V4L2_SUBDEV_FL_HAS_EVENTS flag should not be set, event are just
>> not implemented.
>>
>> Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
> 
> The driver supports controls, and so control events can be subscribed and
> received by the user. Therefore I don't see a reason to remove the flag.

Thanks, good to know.

Would it be worth adding a note where V4L2_SUBDEV_FL_HAS_EVENTS is
#defined, to make this clear?

-- 
Luca
