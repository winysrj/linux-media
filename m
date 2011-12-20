Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42035 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab1LTJ3s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Dec 2011 04:29:48 -0500
Received: by vcbfk14 with SMTP id fk14so4723282vcb.19
        for <linux-media@vger.kernel.org>; Tue, 20 Dec 2011 01:29:47 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 20 Dec 2011 17:29:47 +0800
Message-ID: <CAHG8p1BZtAoYWu_-3sW1dtqwmATQbNSwcxZnEqYXsD8hdhcXUg@mail.gmail.com>
Subject: about v4l2_fh_is_singular
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, sakari.ailus@iki.fi
Cc: LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Hans recommends me using v4l2_fh_is_singular in first open, but I
found it used list_is_singular(&fh->list).
Should it use &fh->vdev->fh_list or I missed something?

Regards,
Scott
