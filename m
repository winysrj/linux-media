Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:43452
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbcHKTdN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 15:33:13 -0400
Subject: Re: [PATCH 0/2] [media] tvp5150: use .registered callback to register
 entity and links
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-kernel@vger.kernel.org
References: <1470932896-25843-1-git-send-email-javier@osg.samsung.com>
 <57ACD297.1070408@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <3abd91de-35fa-f21f-53ef-da0ba45ea1df@osg.samsung.com>
Date: Thu, 11 Aug 2016 15:33:03 -0400
MIME-Version: 1.0
In-Reply-To: <57ACD297.1070408@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sakari,

On 08/11/2016 03:31 PM, Sakari Ailus wrote:
> Javier Martinez Canillas wrote:
>> Hello,
>>
>> Sakari pointed out in "[PATCH 2/8] [media] v4l2-async: call registered_async
>> after subdev registration" [0] that the added .registered_async callback isn't
>> needed since the v4l2 core already has an internal_ops .registered callback.
>>
>> I missed that there was already this when added the .registered_async callback,
>> sorry about that.
>>
>> This small series convert the tvp5150 driver to use the proper .registered and
>> remove .registered_async since isn't needed.
> 
> Thanks!
> 
> For both:
> 
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 

Thanks to you for pointing out my silly mistake.

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
