Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:48751 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbeH0Xpe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Aug 2018 19:45:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-media@vger.kernel.org
Cc: y2038@lists.linaro.org, awalls@md.metrocast.net,
        hans.verkuil@cisco.com, mchehab@kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/5] media: dvb: dmxdev: move compat_ioctl handling to dmxdev.c
Date: Mon, 27 Aug 2018 21:56:22 +0200
Message-Id: <20180827195649.4170969-2-arnd@arndb.de>
In-Reply-To: <20180827195649.4170969-1-arnd@arndb.de>
References: <20180827195649.4170969-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All dmx ioctls are compatible, and they are only implemented
in one file, so we can replace the list of commands in
fs/compat_ioctl.c with a single line in dmxdev.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/dvb-core/dmxdev.c |  1 +
 fs/compat_ioctl.c               | 12 ------------
 2 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index d548f98c7a67..1544e8cef564 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -1265,6 +1265,7 @@ static const struct file_operations dvb_demux_fops = {
 	.owner = THIS_MODULE,
 	.read = dvb_demux_read,
 	.unlocked_ioctl = dvb_demux_ioctl,
+	.compat_ioctl = dvb_demux_ioctl,
 	.open = dvb_demux_open,
 	.release = dvb_demux_release,
 	.poll = dvb_demux_poll,
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 0c46ce224590..e38e6c785459 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1180,18 +1180,6 @@ COMPATIBLE_IOCTL(AUDIO_CLEAR_BUFFER)
 COMPATIBLE_IOCTL(AUDIO_SET_ID)
 COMPATIBLE_IOCTL(AUDIO_SET_MIXER)
 COMPATIBLE_IOCTL(AUDIO_SET_STREAMTYPE)
-COMPATIBLE_IOCTL(DMX_START)
-COMPATIBLE_IOCTL(DMX_STOP)
-COMPATIBLE_IOCTL(DMX_SET_FILTER)
-COMPATIBLE_IOCTL(DMX_SET_PES_FILTER)
-COMPATIBLE_IOCTL(DMX_SET_BUFFER_SIZE)
-COMPATIBLE_IOCTL(DMX_GET_PES_PIDS)
-COMPATIBLE_IOCTL(DMX_GET_STC)
-COMPATIBLE_IOCTL(DMX_REQBUFS)
-COMPATIBLE_IOCTL(DMX_QUERYBUF)
-COMPATIBLE_IOCTL(DMX_EXPBUF)
-COMPATIBLE_IOCTL(DMX_QBUF)
-COMPATIBLE_IOCTL(DMX_DQBUF)
 COMPATIBLE_IOCTL(VIDEO_STOP)
 COMPATIBLE_IOCTL(VIDEO_PLAY)
 COMPATIBLE_IOCTL(VIDEO_FREEZE)
-- 
2.18.0
