Return-path: <linux-media-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3592 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab1LSKVE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Dec 2011 05:21:04 -0500
From: "Zhu, Mingcheng" <mingchen@quicinc.com>
To: Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: query video dev node name using the V4L2 device driver name
Date: Mon, 19 Dec 2011 10:21:03 +0000
Message-ID: <3D233F78EE854A4BA3D34C11AD4FAC1FDEF5E3@nasanexd01b.na.qualcomm.com>
References: <20111215095015.GC3677@valkosipuli.localdomain>
 <201112151354.53360.laurent.pinchart@ideasonboard.com>
 <20111215215033.GG3677@valkosipuli.localdomain>
 <201112190131.10973.laurent.pinchart@ideasonboard.com>
 <20111219071723.GL3677@valkosipuli.localdomain>
In-Reply-To: <20111219071723.GL3677@valkosipuli.localdomain>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent and Sakari,

Current media entity contains a few fields to identify a dev node (name, type, group_id). The entity name is the v4l2 dev node name such as "/dev/video0" "/dev/video1". There is no information who is "/dev/video0" and who is /dev/video1". This makes that, after query the media_entity the application still could not figure out who is /dev/video1".

However in V4L2 devices, there is a driver name that the vendor can assign a specific name such "WIFI CAPTURE" or BACK_CAMERA" to the driver name. Is it possible to add the driver name into the media_entity? This makes that, if the userspace application knows the driver name it can use the driver name to find the dev node.


Thanks,

Mingcheng


