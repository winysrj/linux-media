Return-path: <linux-media-owner@vger.kernel.org>
Received: from ms01.sssup.it ([193.205.80.99]:50826 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751382Ab0ANMAj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2010 07:00:39 -0500
Message-ID: <4B4F0762.4040007@panicking.kicks-ass.org>
Date: Thu, 14 Jan 2010 13:00:34 +0100
From: Michael Trimarchi <michael@panicking.kicks-ass.org>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
Subject: omap34xxcam question?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

Is ok that it try only the first format and size? why does it not continue and find a matching?

@@ -470,7 +471,7 @@ static int try_pix_parm(struct omap34xxcam_videodev *vdev,
                        pix_tmp_out = *wanted_pix_out;
                        rval = isp_try_fmt_cap(isp, &pix_tmp_in, &pix_tmp_out);
                        if (rval)
-                               return rval;
+                               continue;

Michael
