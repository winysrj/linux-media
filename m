Return-path: <linux-media-owner@vger.kernel.org>
Received: from oyp.chewa.net ([91.121.6.101]:55687 "EHLO oyp.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479Ab2ICOHi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Sep 2012 10:07:38 -0400
From: "=?utf-8?q?R=C3=A9mi?= Denis-Courmont" <remi@remlab.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH 01/10] v4l: Remove experimental tag from certain API elements
Date: Mon, 3 Sep 2012 17:07:53 +0300
Cc: linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1346680124-15169-1-git-send-email-hverkuil@xs4all.nl> <c31da93f2bf615b90086d749e3f3eae6d6c3fc41.1346679785.git.hans.verkuil@cisco.com>
In-Reply-To: <c31da93f2bf615b90086d749e3f3eae6d6c3fc41.1346679785.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201209031707.53631@leon.remlab.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le lundi 3 septembre 2012 16:48:35, Hans Verkuil a écrit :
> From: Sakari Ailus <sakari.ailus@iki.fi>
> 
> Remove experimantal tag from the following API elements:
> 
> V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY buffer type.
> V4L2_CAP_VIDEO_OUTPUT_OVERLAY capability flag.
> VIDIOC_ENUM_FRAMESIZES IOCTL.

The patch correctly but silently clears ENUM_FRAMEINTERVALS too...

> VIDIOC_G_ENC_INDEX IOCTL.
> VIDIOC_ENCODER_CMD and VIDIOC_TRY_ENCODER_CMD IOCTLs.
> VIDIOC_DECODER_CMD and VIDIOC_TRY_DECODER_CMD IOCTLs.

-- 
Rémi Denis-Courmont
http://www.remlab.net/
