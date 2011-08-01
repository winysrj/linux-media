Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44210 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab1HAWSx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Aug 2011 18:18:53 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [GIT PATCH FOR v3.1] uvcvideo: Set alternate setting 0 on resume if the bus has been reset
Date: Tue, 2 Aug 2011 00:19:03 +0200
Cc: Ming Lei <tom.leiming@gmail.com>, linux-media@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-usb@vger.kernel.org, Jeremy Kerr <jeremy.kerr@canonical.com>
References: <CACVXFVPHfskUCxhznpATknNxokmL5hft-b+KoxWiMzprVmuJ4w@mail.gmail.com> <201108011326.31648.laurent.pinchart@ideasonboard.com> <4E36E4B9.80701@redhat.com>
In-Reply-To: <4E36E4B9.80701@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108020019.03470.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 46540f7ac646ada7f22912ea7ea9b761ff5c4718:

  [media] ir-mce_kbd-decoder: include module.h for its facilities (2011-07-29 
12:52:23 -0300)

are available in the git repository at:
  git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-stable

Ming Lei (1):
      uvcvideo: Set alternate setting 0 on resume if the bus has been reset

 drivers/media/video/uvc/uvc_driver.c |    2 +-
 drivers/media/video/uvc/uvc_video.c  |   10 +++++++++-
 drivers/media/video/uvc/uvcvideo.h   |    2 +-
 3 files changed, 11 insertions(+), 3 deletions(-)

-- 
Regards,

Laurent Pinchart
