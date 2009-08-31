Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:39541 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754282AbZHaU1N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2009 16:27:13 -0400
Received: from dlep35.itg.ti.com ([157.170.170.118])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id n7VKRAvQ022903
	for <linux-media@vger.kernel.org>; Mon, 31 Aug 2009 15:27:15 -0500
Received: from dlep20.itg.ti.com (localhost [127.0.0.1])
	by dlep35.itg.ti.com (8.13.7/8.13.7) with ESMTP id n7VKR9mo005813
	for <linux-media@vger.kernel.org>; Mon, 31 Aug 2009 15:27:09 -0500 (CDT)
Received: from dlee73.ent.ti.com (localhost [127.0.0.1])
	by dlep20.itg.ti.com (8.12.11/8.12.11) with ESMTP id n7VKR9hm008748
	for <linux-media@vger.kernel.org>; Mon, 31 Aug 2009 15:27:09 -0500 (CDT)
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Mon, 31 Aug 2009 15:27:08 -0500
Subject: RE: Behavior of ENUM_STD/G_STD ioctl
Message-ID: <A69FA2915331DC488A831521EAE36FE40154EDC7B0@dlee06.ent.ti.com>
References: <19F8576C6E063C45BE387C64729E73940436A4A9FF@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E73940436A4A9FF@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Vaibhav,

A minor correction....


Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
new phone: 301-407-9583
Old Phone : 301-515-3736 (will be deprecated)
email: m-karicheri2@ti.com

>-----Original Message-----
>From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>owner@vger.kernel.org] On Behalf Of Hiremath, Vaibhav
>Sent: Monday, August 31, 2009 2:26 PM
>To: linux-media@vger.kernel.org
>Subject: Behavior of ENUM_STD/G_STD ioctl
>
>Hi,
>
>I am working on OMAP3517 which has CCDC module which is almost similar to
>Davinci (DM6446). I have ported davinci capture driver (Submitted by
>Murali) to OMAP3517, and I am almost done with it, except some hardware
>related issues (which requires some follow-ups with HW team).
>
>During this I came across one observation, in vpfe_camera.c file which is


should be read as vpfe_capture.c

>bridge driver assumes the default standard without looking/referring to
>underneath sub-device (It choose index 0 in the v4l2_std array maintained
>by bridge driver). If I understand correctly as per V4L2 Spec, the driver
>does not need to implement enum_std/g_std callback functions, since V4L2
>layer handles this and returns these fields respectively.
>
>Now the question I have here is, how enum_std/g_std, to be more specific
>tvnorm/current_norm should be handled by driver?
>
>1) During probe (or open) bridge driver should get the current standard
>which is being active from the underneath sub-device and update the fields
>tvnorm/current_norm accordingly. After that whenever application call
>enum_std/g_std the V4L2 layer can handle it and for s_std anyway bridge
>driver passing it to sub device.
>
>2) Application must call s_std and that's where all the path will get
>synchronized (what sub-device has with what V4L2 layer has against bridge
>driver)
>
>I believe driver should follow option 1, especially in our case (TVP5146
>video decoder) where it has a capability to lock the signal and return the
>status of detected standard.
>
>Can anybody conform how this should be handled?
>
>Thanks,
>Vaibhav
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

