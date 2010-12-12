Return-path: <mchehab@gaivota>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:57201 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752071Ab0LLCsG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Dec 2010 21:48:06 -0500
Subject: Re: user accesses in ivtv-fileops.c:ivtv_v4l2_write ?
From: Andy Walls <awalls@md.metrocast.net>
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: hverkuil@xs4all.nl, ivtv-devel@ivtvdriver.org,
	linux-media@vger.kernel.org
In-Reply-To: <20101128174022.GA4401@gallifrey>
References: <20101128174022.GA4401@gallifrey>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 11 Dec 2010 20:49:38 -0500
Message-ID: <1292118578.21588.13.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Sun, 2010-11-28 at 17:40 +0000, Dr. David Alan Gilbert wrote:
> Hi,
>   Sparse pointed me at the following line in ivtv-fileops.c's ivtv_v4l2_write:
> 
>                 ivtv_write_vbi(itv, (const struct v4l2_sliced_vbi_data *)user_buf, elems);
> 

Hi David,

Let me know if this patch works for your sparse build and adequately
addresses the problem.

It might be easiest to review this patch by starting at the bottom and
working your way up.

Regards,
Andy


ivtv: ivtv_write_vbi() should use copy_from_user() for user data buffers

ivtv_write_vbi() is used to output VBI data to a TV screen using the
CX23415's decoder.  It was used for both VBI data that came from the
driver internally and VBI data that came from the user, but did not use
copy_from_user() for reading the VBI data from the user buffers.

This change adds a new version of the function,
ivtv_write_vbi_from_user(), that uses copy_from_user() to read the VBI
data provided via user buffers.

This should resolve an sparse build warning reported by Dave Gilbert.

Reported-by: Dr. David Alan Gilbert <linux@treblig.org>
Signed-off-by: Andy Walls <awalls@md.metrocast.net>


diff --git a/drivers/media/video/ivtv/ivtv-fileops.c b/drivers/media/video/ivtv/ivtv-fileops.c
index d727485..4f46b00 100644
--- a/drivers/media/video/ivtv/ivtv-fileops.c
+++ b/drivers/media/video/ivtv/ivtv-fileops.c
@@ -570,7 +570,8 @@ ssize_t ivtv_v4l2_write(struct file *filp, const char __user *user_buf, size_t c
 		int elems = count / sizeof(struct v4l2_sliced_vbi_data);
 
 		set_bit(IVTV_F_S_APPL_IO, &s->s_flags);
-		ivtv_write_vbi(itv, (const struct v4l2_sliced_vbi_data *)user_buf, elems);
+		ivtv_write_vbi_from_user(itv,
+		   (const struct v4l2_sliced_vbi_data __user *)user_buf, elems);
 		return elems * sizeof(struct v4l2_sliced_vbi_data);
 	}
 
diff --git a/drivers/media/video/ivtv/ivtv-vbi.c b/drivers/media/video/ivtv/ivtv-vbi.c
index e1c347e..7275f2d 100644
--- a/drivers/media/video/ivtv/ivtv-vbi.c
+++ b/drivers/media/video/ivtv/ivtv-vbi.c
@@ -92,54 +92,91 @@ static int odd_parity(u8 c)
 	return c & 1;
 }
 
-void ivtv_write_vbi(struct ivtv *itv, const struct v4l2_sliced_vbi_data *sliced, size_t cnt)
+static void ivtv_write_vbi_line(struct ivtv *itv,
+				const struct v4l2_sliced_vbi_data *d,
+				struct vbi_cc *cc, int *found_cc)
 {
 	struct vbi_info *vi = &itv->vbi;
-	struct vbi_cc cc = { .odd = { 0x80, 0x80 }, .even = { 0x80, 0x80 } };
-	int found_cc = 0;
-	size_t i;
-
-	for (i = 0; i < cnt; i++) {
-		const struct v4l2_sliced_vbi_data *d = sliced + i;
 
-		if (d->id == V4L2_SLICED_CAPTION_525 && d->line == 21) {
-			if (d->field) {
-				cc.even[0] = d->data[0];
-				cc.even[1] = d->data[1];
-			} else {
-				cc.odd[0] = d->data[0];
-				cc.odd[1] = d->data[1];
-			}
-			found_cc = 1;
+	if (d->id == V4L2_SLICED_CAPTION_525 && d->line == 21) {
+		if (d->field) {
+			cc->even[0] = d->data[0];
+			cc->even[1] = d->data[1];
+		} else {
+			cc->odd[0] = d->data[0];
+			cc->odd[1] = d->data[1];
 		}
-		else if (d->id == V4L2_SLICED_VPS && d->line == 16 && d->field == 0) {
-			struct vbi_vps vps;
-
-			vps.data[0] = d->data[2];
-			vps.data[1] = d->data[8];
-			vps.data[2] = d->data[9];
-			vps.data[3] = d->data[10];
-			vps.data[4] = d->data[11];
-			if (memcmp(&vps, &vi->vps_payload, sizeof(vps))) {
-				vi->vps_payload = vps;
-				set_bit(IVTV_F_I_UPDATE_VPS, &itv->i_flags);
-			}
+		*found_cc = 1;
+	} else if (d->id == V4L2_SLICED_VPS && d->line == 16 && d->field == 0) {
+		struct vbi_vps vps;
+
+		vps.data[0] = d->data[2];
+		vps.data[1] = d->data[8];
+		vps.data[2] = d->data[9];
+		vps.data[3] = d->data[10];
+		vps.data[4] = d->data[11];
+		if (memcmp(&vps, &vi->vps_payload, sizeof(vps))) {
+			vi->vps_payload = vps;
+			set_bit(IVTV_F_I_UPDATE_VPS, &itv->i_flags);
 		}
-		else if (d->id == V4L2_SLICED_WSS_625 && d->line == 23 && d->field == 0) {
-			int wss = d->data[0] | d->data[1] << 8;
+	} else if (d->id == V4L2_SLICED_WSS_625 &&
+		   d->line == 23 && d->field == 0) {
+		int wss = d->data[0] | d->data[1] << 8;
 
-			if (vi->wss_payload != wss) {
-				vi->wss_payload = wss;
-				set_bit(IVTV_F_I_UPDATE_WSS, &itv->i_flags);
-			}
+		if (vi->wss_payload != wss) {
+			vi->wss_payload = wss;
+			set_bit(IVTV_F_I_UPDATE_WSS, &itv->i_flags);
 		}
 	}
-	if (found_cc && vi->cc_payload_idx < ARRAY_SIZE(vi->cc_payload)) {
-		vi->cc_payload[vi->cc_payload_idx++] = cc;
+}
+
+static void ivtv_write_vbi_cc_lines(struct ivtv *itv, const struct vbi_cc *cc)
+{
+	struct vbi_info *vi = &itv->vbi;
+
+	if (vi->cc_payload_idx < ARRAY_SIZE(vi->cc_payload)) {
+		memcpy(&vi->cc_payload[vi->cc_payload_idx], cc,
+		       sizeof(struct vbi_cc));
+		vi->cc_payload_idx++;
 		set_bit(IVTV_F_I_UPDATE_CC, &itv->i_flags);
 	}
 }
 
+static void ivtv_write_vbi(struct ivtv *itv,
+			   const struct v4l2_sliced_vbi_data *sliced,
+			   size_t cnt)
+{
+	struct vbi_cc cc = { .odd = { 0x80, 0x80 }, .even = { 0x80, 0x80 } };
+	int found_cc = 0;
+	size_t i;
+
+	for (i = 0; i < cnt; i++)
+		ivtv_write_vbi_line(itv, sliced + i, &cc, &found_cc);
+
+	if (found_cc)
+		ivtv_write_vbi_cc_lines(itv, &cc);
+}
+
+void ivtv_write_vbi_from_user(struct ivtv *itv,
+			      const struct v4l2_sliced_vbi_data __user *sliced,
+			      size_t cnt)
+{
+	struct vbi_cc cc = { .odd = { 0x80, 0x80 }, .even = { 0x80, 0x80 } };
+	int found_cc = 0;
+	size_t i;
+	struct v4l2_sliced_vbi_data d;
+
+	for (i = 0; i < cnt; i++) {
+		if (copy_from_user(&d, sliced + i,
+				   sizeof(struct v4l2_sliced_vbi_data)))
+			break;
+		ivtv_write_vbi_line(itv, sliced + i, &cc, &found_cc);
+	}
+
+	if (found_cc)
+		ivtv_write_vbi_cc_lines(itv, &cc);
+}
+
 static void copy_vbi_data(struct ivtv *itv, int lines, u32 pts_stamp)
 {
 	int line = 0;
diff --git a/drivers/media/video/ivtv/ivtv-vbi.h b/drivers/media/video/ivtv/ivtv-vbi.h
index 970567b..eda38d0 100644
--- a/drivers/media/video/ivtv/ivtv-vbi.h
+++ b/drivers/media/video/ivtv/ivtv-vbi.h
@@ -20,7 +20,9 @@
 #ifndef IVTV_VBI_H
 #define IVTV_VBI_H
 
-void ivtv_write_vbi(struct ivtv *itv, const struct v4l2_sliced_vbi_data *sliced, size_t count);
+void ivtv_write_vbi_from_user(struct ivtv *itv,
+			      const struct v4l2_sliced_vbi_data __user *sliced,
+			      size_t count);
 void ivtv_process_vbi_data(struct ivtv *itv, struct ivtv_buffer *buf,
 			   u64 pts_stamp, int streamtype);
 int ivtv_used_line(struct ivtv *itv, int line, int field);


