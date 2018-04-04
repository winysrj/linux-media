Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43906 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751971AbeDDPc4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Apr 2018 11:32:56 -0400
Subject: Patch "media: v4l2-compat-ioctl32.c: copy clip list in put_v4l2_window32" has been added to the 3.18-stable tree
To: mchehab@s-opensource.com, alexander.levin@microsoft.com,
        gregkh@linuxfoundation.org, hans.verkuil@cisco.com,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        mchehab@infradead.org, sakari.ailus@linux.intel.com
Cc: <stable@vger.kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Wed, 04 Apr 2018 17:32:44 +0200
In-Reply-To: <b203ca17a23bf02398ef39e8f123d30b74df3523.1522260310.git.mchehab@s-opensource.com>
Message-ID: <1522855964761@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


This is a note to let you know that I've just added the patch titled

    media: v4l2-compat-ioctl32.c: copy clip list in put_v4l2_window32

to the 3.18-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     media-v4l2-compat-ioctl32.c-copy-clip-list-in-put_v4l2_window32.patch
and it can be found in the queue-3.18 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


>From foo@baz Wed Apr  4 17:30:18 CEST 2018
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Date: Wed, 28 Mar 2018 15:12:30 -0300
Subject: media: v4l2-compat-ioctl32.c: copy clip list in put_v4l2_window32
To: Linux Media Mailing List <linux-media@vger.kernel.org>, stable@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, Mauro Carvalho Chehab <mchehab@infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@s-opensource.com>, Sasha Levin <alexander.levin@microsoft.com>
Message-ID: <b203ca17a23bf02398ef39e8f123d30b74df3523.1522260310.git.mchehab@s-opensource.com>

From: Hans Verkuil <hans.verkuil@cisco.com>

commit a751be5b142ef6bcbbb96d9899516f4d9c8d0ef4 upstream.

put_v4l2_window32() didn't copy back the clip list to userspace.
Drivers can update the clip rectangles, so this should be done.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c |   59 +++++++++++++++++---------
 1 file changed, 40 insertions(+), 19 deletions(-)

--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -50,6 +50,11 @@ struct v4l2_window32 {
 
 static int get_v4l2_window32(struct v4l2_window *kp, struct v4l2_window32 __user *up)
 {
+	struct v4l2_clip32 __user *uclips;
+	struct v4l2_clip __user *kclips;
+	compat_caddr_t p;
+	u32 n;
+
 	if (!access_ok(VERIFY_READ, up, sizeof(*up)) ||
 	    copy_from_user(&kp->w, &up->w, sizeof(up->w)) ||
 	    get_user(kp->field, &up->field) ||
@@ -59,38 +64,54 @@ static int get_v4l2_window32(struct v4l2
 		return -EFAULT;
 	if (kp->clipcount > 2048)
 		return -EINVAL;
-	if (kp->clipcount) {
-		struct v4l2_clip32 __user *uclips;
-		struct v4l2_clip __user *kclips;
-		int n = kp->clipcount;
-		compat_caddr_t p;
+	if (!kp->clipcount) {
+		kp->clips = NULL;
+		return 0;
+	}
 
-		if (get_user(p, &up->clips))
+	n = kp->clipcount;
+	if (get_user(p, &up->clips))
+		return -EFAULT;
+	uclips = compat_ptr(p);
+	kclips = compat_alloc_user_space(n * sizeof(*kclips));
+	kp->clips = kclips;
+	while (n--) {
+		if (copy_in_user(&kclips->c, &uclips->c, sizeof(uclips->c)))
 			return -EFAULT;
-		uclips = compat_ptr(p);
-		kclips = compat_alloc_user_space(n * sizeof(*kclips));
-		kp->clips = kclips;
-		while (--n >= 0) {
-			if (copy_in_user(&kclips->c, &uclips->c, sizeof(uclips->c)))
-				return -EFAULT;
-			if (put_user(n ? kclips + 1 : NULL, &kclips->next))
-				return -EFAULT;
-			uclips += 1;
-			kclips += 1;
-		}
-	} else
-		kp->clips = NULL;
+		if (put_user(n ? kclips + 1 : NULL, &kclips->next))
+			return -EFAULT;
+		uclips++;
+		kclips++;
+	}
 	return 0;
 }
 
 static int put_v4l2_window32(struct v4l2_window *kp, struct v4l2_window32 __user *up)
 {
+	struct v4l2_clip __user *kclips = kp->clips;
+	struct v4l2_clip32 __user *uclips;
+	u32 n = kp->clipcount;
+	compat_caddr_t p;
+
 	if (copy_to_user(&up->w, &kp->w, sizeof(kp->w)) ||
 	    put_user(kp->field, &up->field) ||
 	    put_user(kp->chromakey, &up->chromakey) ||
 	    put_user(kp->clipcount, &up->clipcount) ||
 	    put_user(kp->global_alpha, &up->global_alpha))
 		return -EFAULT;
+
+	if (!kp->clipcount)
+		return 0;
+
+	if (get_user(p, &up->clips))
+		return -EFAULT;
+	uclips = compat_ptr(p);
+	while (n--) {
+		if (copy_in_user(&uclips->c, &kclips->c, sizeof(uclips->c)))
+			return -EFAULT;
+		uclips++;
+		kclips++;
+	}
 	return 0;
 }
 


Patches currently in stable-queue which might be from mchehab@s-opensource.com are

queue-3.18/media-v4l2-compat-ioctl32.c-copy-m.userptr-in-put_v4l2_plane32.patch
queue-3.18/media-v4l2-compat-ioctl32.c-avoid-sizeof-type.patch
queue-3.18/media-v4l2-compat-ioctl32.c-drop-pr_info-for-unknown-buffer-type.patch
queue-3.18/media-v4l2-compat-ioctl32-use-compat_u64-for-video-standard.patch
queue-3.18/media-v4l2-compat-ioctl32.c-add-missing-vidioc_prepare_buf.patch
queue-3.18/vb2-v4l2_buf_flag_done-is-set-after-dqbuf.patch
queue-3.18/media-v4l2-compat-ioctl32.c-refactor-compat-ioctl32-logic.patch
queue-3.18/media-v4l2-ctrls-fix-sparse-warning.patch
queue-3.18/media-v4l2-compat-ioctl32.c-fix-ctrl_is_pointer.patch
queue-3.18/media-v4l2-compat-ioctl32.c-move-helper-functions-to-__get-put_v4l2_format32.patch
queue-3.18/media-media-v4l2-ctrls-volatiles-should-not-generate-ch_value.patch
queue-3.18/media-v4l2-compat-ioctl32.c-don-t-copy-back-the-result-for-certain-errors.patch
queue-3.18/media-v4l2-compat-ioctl32.c-make-ctrl_is_pointer-work-for-subdevs.patch
queue-3.18/media-v4l2-compat-ioctl32.c-fix-the-indentation.patch
queue-3.18/media-v4l2-compat-ioctl32-copy-v4l2_window-global_alpha.patch
queue-3.18/media-v4l2-ioctl.c-don-t-copy-back-the-result-for-enotty.patch
queue-3.18/media-v4l2-compat-ioctl32.c-copy-clip-list-in-put_v4l2_window32.patch
queue-3.18/media-v4l2-compat-ioctl32-initialize-a-reserved-field.patch
