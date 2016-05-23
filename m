Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:33073 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056AbcEWLfO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2016 07:35:14 -0400
Received: by mail-io0-f180.google.com with SMTP id t40so99260563ioi.0
        for <linux-media@vger.kernel.org>; Mon, 23 May 2016 04:35:14 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 23 May 2016 12:35:13 +0100
Message-ID: <CAMzoamZ+bnvJ=yUOW9V3QqBRQ1+ucsUKiVZENS8euXf3jHOG3g@mail.gmail.com>
Subject: drivers/media/v4l2-core/v4l2-ioctl.c:2174: duplicate expression ?
From: David Binderman <linuxdev.baldrick@gmail.com>
To: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	dcb314@hotmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello there,

linux-next/drivers/media/v4l2-core/v4l2-ioctl.c:2174] ->
[linux-next/drivers/media/v4l2-core/v4l2-ioctl.c:2174]: (style) Same
expression on both sides of '&&'.

Source code is

    if (WARN_ON(!ops->vidioc_cropcap && !ops->vidioc_cropcap))

Suggest either remove the duplication or test some other field.

Regards

David Binderman
