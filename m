Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:36755 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbcEXVTs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 17:19:48 -0400
Received: by mail-wm0-f50.google.com with SMTP id n129so150938553wmn.1
        for <linux-media@vger.kernel.org>; Tue, 24 May 2016 14:19:48 -0700 (PDT)
MIME-Version: 1.0
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 24 May 2016 23:19:27 +0200
Message-ID: <CAPybu_3+PsND193UKfrP7Hy_Qs7gu=QWRxZcmfiDaDRmiC6h4g@mail.gmail.com>
Subject: RFC: HSV format
To: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

HSV is a  cylindrical-coordinate representation of a color. It is very
useful for computer vision because the Hue component can be used to
segment a scene.

My plan was to add a format in videodev2.h and then add support for
vivid, libv4l2-convert and qv4l2.

There are also plans to prepare a patch for opencv to use this format
without any software conversion, and also for Gstreamer... but all
these changes depend on the changes on videodev2.h

The question is how open would be the linux-media community for such a
change, considering that there is no real device driver using it in
tree ( Our hardware is currently out of tree_

Today we only have an HSV format on v4l2-mediabus.h
V4L2_MBUS_FROM_MEDIA_BUS_FMT(AHSV8888_1X32), but no HSV format on
videodev2.h


Thanks!!!



-- 
Ricardo Ribalda
