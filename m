Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:48302 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757461AbcB1Onw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Feb 2016 09:43:52 -0500
Subject: Re: [patch 1/2] [media] tvp5150: off by one
To: Dan Carpenter <dan.carpenter@oracle.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <20160227105109.GD14086@mwanda>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <56D3079D.4040306@osg.samsung.com>
Date: Sun, 28 Feb 2016 11:43:41 -0300
MIME-Version: 1.0
In-Reply-To: <20160227105109.GD14086@mwanda>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Dan,

On 02/27/2016 07:51 AM, Dan Carpenter wrote:
> The ->input_ent[] array has TVP5150_INPUT_NUM elements so the > here
> should be >=.
>
> Fixes: f7b4b54e6364 ('[media] tvp5150: add HW input connectors support')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>

Thanks for the patch but Mauro already posted the same change before:

http://www.spinics.net/lists/linux-media/msg97721.html

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
