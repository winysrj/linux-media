Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:16473 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097AbcHKTbk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 15:31:40 -0400
Subject: Re: [PATCH 0/2] [media] tvp5150: use .registered callback to register
 entity and links
To: Javier Martinez Canillas <javier@osg.samsung.com>,
	linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
References: <1470932896-25843-1-git-send-email-javier@osg.samsung.com>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <57ACD297.1070408@linux.intel.com>
Date: Thu, 11 Aug 2016 22:31:35 +0300
MIME-Version: 1.0
In-Reply-To: <1470932896-25843-1-git-send-email-javier@osg.samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Javier Martinez Canillas wrote:
> Hello,
>
> Sakari pointed out in "[PATCH 2/8] [media] v4l2-async: call registered_async
> after subdev registration" [0] that the added .registered_async callback isn't
> needed since the v4l2 core already has an internal_ops .registered callback.
>
> I missed that there was already this when added the .registered_async callback,
> sorry about that.
>
> This small series convert the tvp5150 driver to use the proper .registered and
> remove .registered_async since isn't needed.

Thanks!

For both:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
