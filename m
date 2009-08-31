Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:37525 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbZHaS0j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2009 14:26:39 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id n7VIQYcR023723
	for <linux-media@vger.kernel.org>; Mon, 31 Aug 2009 13:26:40 -0500
Received: from dbde70.ent.ti.com (localhost [127.0.0.1])
	by dbdp20.itg.ti.com (8.13.8/8.13.8) with ESMTP id n7VIQXlp025223
	for <linux-media@vger.kernel.org>; Mon, 31 Aug 2009 23:56:34 +0530 (IST)
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Mon, 31 Aug 2009 23:56:29 +0530
Subject: Behavior of ENUM_STD/G_STD ioctl
Message-ID: <19F8576C6E063C45BE387C64729E73940436A4A9FF@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am working on OMAP3517 which has CCDC module which is almost similar to Davinci (DM6446). I have ported davinci capture driver (Submitted by Murali) to OMAP3517, and I am almost done with it, except some hardware related issues (which requires some follow-ups with HW team). 

During this I came across one observation, in vpfe_camera.c file which is bridge driver assumes the default standard without looking/referring to underneath sub-device (It choose index 0 in the v4l2_std array maintained by bridge driver). If I understand correctly as per V4L2 Spec, the driver does not need to implement enum_std/g_std callback functions, since V4L2 layer handles this and returns these fields respectively. 

Now the question I have here is, how enum_std/g_std, to be more specific tvnorm/current_norm should be handled by driver?

1) During probe (or open) bridge driver should get the current standard which is being active from the underneath sub-device and update the fields tvnorm/current_norm accordingly. After that whenever application call enum_std/g_std the V4L2 layer can handle it and for s_std anyway bridge driver passing it to sub device.

2) Application must call s_std and that's where all the path will get synchronized (what sub-device has with what V4L2 layer has against bridge driver)

I believe driver should follow option 1, especially in our case (TVP5146 video decoder) where it has a capability to lock the signal and return the status of detected standard.

Can anybody conform how this should be handled?

Thanks,
Vaibhav
