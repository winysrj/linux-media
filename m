Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36985 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab1LJEmA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Dec 2011 23:42:00 -0500
Received: by wgbdr13 with SMTP id dr13so6983961wgb.1
        for <linux-media@vger.kernel.org>; Fri, 09 Dec 2011 20:41:59 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 10 Dec 2011 10:11:59 +0530
Message-ID: <CAHFNz9+J69YqY06QRSPV+1a0gT1QSmw7cqqnW5AEarF-V5xGCw@mail.gmail.com>
Subject: v4 [PATCH 00/10] Query DVB frontend delivery capabilities
From: Manu Abraham <abraham.manu@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

 As discussed prior, the following changes help to advertise a
 frontend's delivery system capabilities.

 Sending out the patches as they are being worked out.

 The following patch series are applied against media_tree.git
 after the following commit

 commit e9eb0dadba932940f721f9d27544a7818b2fa1c5
 Author: Hans Verkuil <hans.verkuil@cisco.com>
 Date:   Tue Nov 8 11:02:34 2011 -0300

    [media] V4L menu: add submenu for platform devices
