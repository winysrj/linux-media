Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.pmeerw.net ([87.118.82.44]:41387 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932082AbaGUMfo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 08:35:44 -0400
Received: from localhost (localhost [127.0.0.1])
	by pmeerw.net (Postfix) with ESMTP id 2823EC50120
	for <linux-media@vger.kernel.org>; Mon, 21 Jul 2014 14:35:39 +0200 (CEST)
Date: Mon, 21 Jul 2014 14:35:39 +0200 (CEST)
From: Peter Meerwald <pmeerw@pmeerw.net>
To: linux-media@vger.kernel.org
Message-ID: <alpine.DEB.2.01.1407211419320.18226@pmeerw.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

how can I query the supported pixel format(s) of a sensor connected via 
media-ctl and exposed via /dev/videoX

there is 
VIDIOC_ENUM_FMT (which fails)
and
VIDIOC_SUBDEV_ENUM_MBUS_CODE (which works, but on a subdev, not on 
/dev/videoX)

v4l2_subdev_video_ops has .enum_mbus_fmt (this is SoC camera stuff?)

v4l2_subdev_pad_ops has .enum_mbus_code


the application just sees /dev/videoX and cannot do VIDIOC_ENUM_FMT
what is the logic behind this?
shouldn't a compabatibility layer be added turning VIDIOC_ENUM_FMT into 
VIDIOC_SUBDEV_ENUM_MBUS_CODE?

thanks, p.

-- 

Peter Meerwald
+43-664-2444418 (mobile)
