Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39863 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab1IFIMM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2011 04:12:12 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "LBM" <lbm9527@qq.com>
Subject: Re: use soc-camera mt9m111 with omap3isp
Date: Tue, 6 Sep 2011 10:12:11 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <tencent_3AABBD0600E40EFF5735DBE0@qq.com>
In-Reply-To: <tencent_3AABBD0600E40EFF5735DBE0@qq.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109061012.12254.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lee,

On Tuesday 06 September 2011 07:07:34 LBM wrote:
> hi my friend
> i use the omap3530 board from "ema-tech",which is the third of TI.
> Now i use the mt9m111,it's very difficulty for me to get the images
> from this sensor ,becaus it just a soc-camera. can you tell me how to use
> this sensor with our omap3isp?

You will need to implement the subdev pad-level operation in the mt9m111 
driver and make the soc-camera dependencies optional.

> if you  did something about it,can you give me the codes?

I'm not aware of any patch that implements this.

-- 
Regards,

Laurent Pinchart
