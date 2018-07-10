Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:52670 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751233AbeGJICC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 04:02:02 -0400
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Marco Franchi <marco.franchi@nxp.com>,
        Icenowy Zheng <icenowy@aosc.io>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Tom Saeger <tom.saeger@oracle.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Benoit Parrot <bparrot@ti.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Pawel Osciak <posciak@chromium.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Randy Li <ayaka@soulik.info>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v5 01/22] v4l2-ctrls: add v4l2_ctrl_request_hdl_find/put/ctrl_find functions
Date: Tue, 10 Jul 2018 10:00:53 +0200
Message-Id: <20180710080114.31469-2-paul.kocialkowski@bootlin.com>
In-Reply-To: <20180710080114.31469-1-paul.kocialkowski@bootlin.com>
References: <20180710080114.31469-1-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hverkuil@xs4all.nl>

If a driver needs to find/inspect the controls set in a request then
it can use these functions.

E.g. to check if a required control is set in a request use this in the
req_validate() implementation:

	int res = -EINVAL;

	hdl = v4l2_ctrl_request_hdl_find(req, parent_hdl);
	if (hdl) {
		if (v4l2_ctrl_request_hdl_ctrl_find(hdl, ctrl_id))
			res = 0;
		v4l2_ctrl_request_hdl_put(hdl);
	}
	return res;

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 25 ++++++++++++++++
 include/media/v4l2-ctrls.h           | 44 +++++++++++++++++++++++++++-
 2 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 86a6ae54ccaa..198b7e924d21 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -2976,6 +2976,31 @@ static const struct media_request_object_ops req_ops = {
 	.release = v4l2_ctrl_request_release,
 };
 
+struct v4l2_ctrl_handler *v4l2_ctrl_request_hdl_find(struct media_request *req,
+					struct v4l2_ctrl_handler *parent)
+{
+	struct media_request_object *obj;
+	
+	if (WARN_ON(req->state != MEDIA_REQUEST_STATE_VALIDATING &&
+		    req->state != MEDIA_REQUEST_STATE_QUEUED))
+		return NULL;
+
+	obj = media_request_object_find(req, &req_ops, parent);
+	if (obj)
+		return container_of(obj, struct v4l2_ctrl_handler, req_obj);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(v4l2_ctrl_request_hdl_find);
+
+struct v4l2_ctrl *
+v4l2_ctrl_request_hdl_ctrl_find(struct v4l2_ctrl_handler *hdl, u32 id)
+{
+	struct v4l2_ctrl_ref *ref = find_ref_lock(hdl, id);
+
+	return (ref && ref->req == ref) ? ref : NULL;
+}
+EXPORT_SYMBOL_GPL(v4l2_ctrl_request_hdl_ctrl_find);
+
 static int v4l2_ctrl_request_bind(struct media_request *req,
 			   struct v4l2_ctrl_handler *hdl,
 			   struct v4l2_ctrl_handler *from)
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index de70cc3a1b80..34ee3167d7dd 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -1111,7 +1111,49 @@ void v4l2_ctrl_request_setup(struct media_request *req,
  * request object.
  */
 void v4l2_ctrl_request_complete(struct media_request *req,
-				struct v4l2_ctrl_handler *hdl);
+				struct v4l2_ctrl_handler *parent);
+
+/**
+ * v4l2_ctrl_request_hdl_find - Find the control handler in the request
+ *
+ * @req: The request
+ * @parent: The parent control handler ('priv' in media_request_object_find())
+ *
+ * This function finds the control handler in the request. It may return
+ * NULL if not found. When done, you must call v4l2_ctrl_request_put_hdl()
+ * with the returned handler pointer.
+ *
+ * If the request is not in state VALIDATING or QUEUED, then this function
+ * will always return NULL.
+ */
+struct v4l2_ctrl_handler *v4l2_ctrl_request_hdl_find(struct media_request *req,
+					struct v4l2_ctrl_handler *parent);
+
+/**
+ * v4l2_ctrl_request_hdl_put - Put the control handler
+ *
+ * @hdl: Put this control handler
+ *
+ * This function released the control handler previously obtained from'
+ * v4l2_ctrl_request_hdl_find().
+ */
+static inline void v4l2_ctrl_request_hdl_put(struct v4l2_ctrl_handler *hdl)
+{
+	if (hdl)
+		media_request_object_put(&hdl->req_obj);
+}
+
+/**
+ * v4l2_ctrl_request_ctrl_find() - Find a control with the given ID.
+ *
+ * @hdl: The control handler from the request.
+ * @id: The ID of the control to find.
+ *
+ * This function returns a pointer to the control if this control is
+ * part of the request or NULL otherwise.
+ */
+struct v4l2_ctrl *
+v4l2_ctrl_request_hdl_ctrl_find(struct v4l2_ctrl_handler *hdl, u32 id);
 
 /* Helpers for ioctl_ops */
 
-- 
2.17.1
