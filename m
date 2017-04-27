Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48896 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937067AbdD0M1L (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Apr 2017 08:27:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 0/2] uvcvideo patches for v4.13
Date: Thu, 27 Apr 2017 15:28:16 +0300
Message-Id: <20170427122818.13146-1-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Please find two uvcvideo patches targeted at v4.13. Could you please take them
in your tree ?

Daniel Roschka (1):
  uvcvideo: Quirk for webcam in MacBook Pro 2016

Peter Boström (1):
  uvcvideo: Add iFunction or iInterface to device names.

 drivers/media/usb/uvc/uvc_driver.c | 34 +++++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

-- 
Regards,

Laurent Pinchart
