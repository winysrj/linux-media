Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60402 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338Ab2ADOIh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2012 09:08:37 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: I2C and SPI subdevs unregistration
Date: Wed, 4 Jan 2012 15:08:52 +0100
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201201041508.53792.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Do you know why I2C and SPI devices are unregistered in 
v4l2_device_unregister() but not in v4l2_device_unregister_subdev() ? If I 
call the later manually before calling v4l2_device_unregister(), the I2C and 
SPI devices won't be unregistered. Is that expected ?

-- 
Regards,

Laurent Pinchart
