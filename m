Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754942AbeE2I3g (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 May 2018 04:29:36 -0400
Date: Tue, 29 May 2018 13:59:32 +0530
From: Vinod <vkoul@kernel.org>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: camera control interface
Message-ID: <20180529082932.GH5666@vkoul-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

I am writing a driver for camera control inteface which is an i2c
controller. So looking up the code I think it can be a v4l subdev,
right? Can it be an independent i2c master and not v4l subdev?

Second the control sports GPIOs. It can support  a set of
synchronization primitives so it's possible to drive I2C clients and
GPIOs with hardware controlled timing to allow for sync control of
sensors hooked and also for fancy strobe. How would we represent these
gpios in v4l2 and allow the control, any ideas on that.

Thanks
-- 
~Vinod
