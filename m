Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:46228 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab0CHMpF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Mar 2010 07:45:05 -0500
Received: from vaebh106.NOE.Nokia.com (vaebh106.europe.nokia.com [10.160.244.32])
	by mgw-mx06.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o28CipId009203
	for <linux-media@vger.kernel.org>; Mon, 8 Mar 2010 14:45:01 +0200
Received: from [172.22.211.19] (masi.nmp.nokia.com [172.22.211.19])
	by mgw-sa02.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o28CiQVp031931
	for <linux-media@vger.kernel.org>; Mon, 8 Mar 2010 14:44:26 +0200
Subject: v4l2 subdevices and fops
From: m7aalton <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <4B84BA3A.3090809@redhat.com>
References: <1243448117.8697.790.camel@alkaloid.netup.ru>
	 <20090601045241.2e27b26a@pedra.chehab.org>
	 <1266854419.16063.92.camel@alkaloid.netup.ru> <4B84BA3A.3090809@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Mar 2010 14:44:25 +0200
Message-ID: <1268052265.27183.83.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

I'm writing a radio driver which uses subdevice file operations to
handle RDS reception and transmission. Some IOCTL call-backs to the main
device are easy to pass to the subdevice driver. To me it seems that
adding the fops pointer to the following struct in v4l2-subdev.h would
make passing the file operation call-backs equally convenient.

struct v4l2_subdev_ops {
	const struct v4l2_subdev_core_ops  *core;
	const struct v4l2_subdev_tuner_ops *tuner;
	const struct v4l2_subdev_audio_ops *audio;
	const struct v4l2_subdev_video_ops *video;
	const struct v4l2_subdev_pad_ops   *pad;
};

Could I expand the above struct in the way I described? Have I missed
something? Do you understand what I'm saying? :-)

Cheers,
Matti 

