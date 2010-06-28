Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:44716 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab0F1GUX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jun 2010 02:20:23 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id o5S6KJls026073
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 28 Jun 2010 01:20:22 -0500
Received: from dbde70.ent.ti.com (localhost [127.0.0.1])
	by dbdp20.itg.ti.com (8.13.8/8.13.8) with ESMTP id o5S6KIhE014654
	for <linux-media@vger.kernel.org>; Mon, 28 Jun 2010 11:50:19 +0530 (IST)
From: "Taneja, Archit" <archit@ti.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Guruswamy, Senthilvadivu" <svadivu@ti.com>,
	"Mittal, Mukund" <mmittal@ti.com>
Date: Mon, 28 Jun 2010 11:50:18 +0530
Subject: V4L2 display for manual update panels
Message-ID: <FCCFB4CDC6E5564B9182F639FC356087030597BB26@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Is anyone aware of a V4L2 display driver which supports manual update
panels, i.e. panels which require an explicit device->driver->update
call?
An auto update panel would be one which does not require the V4L2 driver
requesting for the next frame, the display drivers below the V4l2 layer
will handle this updation of the frame and notifying the v4l2 isr to unblock
the dqbuf ioctl.
This manual update feature is needed for panels which support DSI command
mode interface; in this case, it is generally the responsibility of the display
driver users (V4L2, FB etc) to give a explicit manual update call.


Thanks,

Archit

