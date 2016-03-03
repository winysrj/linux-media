Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:34544 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757972AbcCCVSQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Mar 2016 16:18:16 -0500
Subject: Re: [PATCH v3 13/22] media: Change v4l-core to check if source is
 free
To: Olli Salonen <olli.salonen@iki.fi>
References: <cover.1455233150.git.shuahkh@osg.samsung.com>
 <d9c55486ee5daff0caf19c1eab8ca8856d79ff5d.1455233154.git.shuahkh@osg.samsung.com>
 <CAAZRmGziEGkywO5fU8aQqk6gFC8EWrY0VJA84PMCDj5crtiO3w@mail.gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <56D8AA16.7040909@osg.samsung.com>
Date: Thu, 3 Mar 2016 14:18:14 -0700
MIME-Version: 1.0
In-Reply-To: <CAAZRmGziEGkywO5fU8aQqk6gFC8EWrY0VJA84PMCDj5crtiO3w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/03/2016 01:39 PM, Olli Salonen wrote:
> Hello Shuah,
> 
> This patch seems to cause issues with my setup. Basically, when I try
> to tune to a channel, I get an oops. I'm using TechnoTrend CT2-4650
> PCIe DVB-T tuner (cx23885).
> 
> Here's the oops:
> 
> [  548.443272] BUG: unable to handle kernel NULL pointer dereference
> at 0000000000000010
> [  548.452036] IP: [<ffffffffc020ffc9>]
> v4l_vb2q_enable_media_source+0x9/0x50 [videodev]

Hi Olli,

Will you be able to use gdb and tell me which source line is
the cause? Could you give this following patch a try and if it
fixes the problem?

thanks,
-- Shuah

diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
index 643686d..a39a3cd 100644
--- a/drivers/media/v4l2-core/v4l2-mc.c
+++ b/drivers/media/v4l2-core/v4l2-mc.c
@@ -214,6 +214,8 @@ int v4l_vb2q_enable_media_source(struct vb2_queue *q)
 {
        struct v4l2_fh *fh = q->owner;
 
-       return v4l_enable_media_source(fh->vdev);
+       if (fh && fh->vdev)
+               return v4l_enable_media_source(fh->vdev);
+       return 0;
 }
 EXPORT_SYMBOL_GPL(v4l_vb2q_enable_media_source);
shuah@anduin:~/lkml/linux_media_feb27_2016$ git diff > temp.diff
shuah@anduin:~/lkml/linux_media_feb27_2016$ cat temp.diff
diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
index 643686d..a39a3cd 100644
--- a/drivers/media/v4l2-core/v4l2-mc.c
+++ b/drivers/media/v4l2-core/v4l2-mc.c
@@ -214,6 +214,8 @@ int v4l_vb2q_enable_media_source(struct vb2_queue *q)
 {
 	struct v4l2_fh *fh = q->owner;
 
-	return v4l_enable_media_source(fh->vdev);
+	if (fh && fh->vdev)
+		return v4l_enable_media_source(fh->vdev);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l_vb2q_enable_media_source);



-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
