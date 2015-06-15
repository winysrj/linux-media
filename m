Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:19190 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbbFOLvU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2015 07:51:20 -0400
Message-id: <557EBC30.6090902@samsung.com>
Date: Mon, 15 Jun 2015 13:51:12 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Andy Walls <awalls@md.metrocast.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Axel Lin <axel.lin@ingics.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/12] media/i2c/sr030pc30: Remove compat control ops
References: <1434126678-7978-1-git-send-email-ricardo.ribalda@gmail.com>
 <1434126678-7978-6-git-send-email-ricardo.ribalda@gmail.com>
 <557EA7A2.8060403@xs4all.nl>
In-reply-to: <557EA7A2.8060403@xs4all.nl>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 15/06/15 12:23, Hans Verkuil wrote:
> Sylwester,
> 
> Can you confirm that this is only used with bridge drivers that use the
> control framework? Actually, this driver isn't used by any bridge driver
> in the kernel tree, but it is probably in use by out-of-tree code.
> 
> I'd like your Ack (or Nack) before I merge this.
> 
> Note that eventually these legacy support ops will disappear once all
> bridge drivers in the kernel have been converted to the control framework.

This sensor driver is used on board type which has been scratched long time
ago, feel free to do any changes in this code.

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>


-- 
Regards,
Sylwester
