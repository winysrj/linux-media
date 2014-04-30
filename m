Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55961 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758698AbaD3OPG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Apr 2014 10:15:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1WfVHr-00073G-GE
	for linux-media@vger.kernel.org; Wed, 30 Apr 2014 16:15:03 +0200
Received: from kirindi.eng.uwo.ca ([129.100.227.105])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 30 Apr 2014 16:15:03 +0200
Received: from asanka424 by kirindi.eng.uwo.ca with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 30 Apr 2014 16:15:03 +0200
To: linux-media@vger.kernel.org
From: Asanka <asanka424@gmail.com>
Subject: Logitech c920 exposure settings with V4L2
Date: Wed, 30 Apr 2014 14:10:02 +0000 (UTC)
Message-ID: <loom.20140430T155857-177@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
I am not sure my previous message was posted. So I am reposting with outputs.

I am trying to change exposure settings to manual and then to aperture
priority. I want to read the exposure absolute value set by the camera when
its in auto (aperture priority) mode. However after I switched from manual
to auto mode I keep getting the old value set my me in manual mode. This is
my output.

$ v4l2-ctl --device=/dev/video0 --set-ctrl=exposure_auto=1
$ v4l2-ctl --device=/dev/video0 --set-ctrl=exposure_absolute=2500
$ v4l2-ctl --device=/dev/video0 --get-ctrl=exposure_absolute
exposure_absolute: 2500
$ v4l2-ctl --device=/dev/video0 --set-ctrl=exposure_auto=3
$ v4l2-ctl --device=/dev/video0 --get-ctrl=exposure_absolute
exposure_absolute: 2500

Can anyone help me with this.

Thanks.
Asanka

