Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:47729 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaI2VXk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Sep 2014 17:23:40 -0400
Message-ID: <5429CDD6.9050809@collabora.com>
Date: Mon, 29 Sep 2014 17:23:34 -0400
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: Regression: in v4l2 converter does not set the buffer.length anymore
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This was initially reported to GStreamer project:
https://bugzilla.gnome.org/show_bug.cgi?id=737521

We track this down to be a regression introduced in v4l2-utils from 
version 1.4.0. In recent GStreamer we make sure the buffer.length field 
(retreived with QUERYBUF) is bigger or equal to the expected sizeimage 
(as obtained in S_FMT). This is to fail cleanly and avoid buffer 
overflow if a driver (or libv4l2) endup doing a short allocation. Since 
1.4.0, this field is always 0 if an emulated format is selected.

Reverting patch 10213c brings back normal behaviour:
http://git.linuxtv.org/cgit.cgi/v4l-utils.git/commit/?id=10213c975afdfcc90aa7de39e66c40cd7e8a57f7

This currently makes use of any emulated format impossible in GStreamer. 
v4l2-utils 1.4.0 is being shipped at least in debian/unstable at the moment.

cheers,
Nicolas
