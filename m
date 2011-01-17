Return-path: <mchehab@pedra>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:42576 "HELO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751715Ab1AQKdW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jan 2011 05:33:22 -0500
From: Qing Xu <qingx@marvell.com>
To: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Mon, 17 Jan 2011 02:33:17 -0800
Subject: soc-camera s_fmt question?
Message-ID: <7BAC95F5A7E67643AAFB2C31BEE662D014040BF23F@SC-VEXCH2.marvell.com>
References: <AANLkTimucMmO8Vb_y4xnhehQt+mamNMmXyY_qfrVOSo7@mail.gmail.com>
 <AANLkTinv64SL4HavFRK-s2Tr4CTGPH4iQ9bz7=40v1Hc@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

We are now nearly complete porting our camera driver to align with soc-camera framework, however, we encounter a problem when it works with our application during switch format from preview to still capture, application's main calling sequence is as follow:
1) s_fmt /* preview @ YUV, VGA */
2) request buffer (buffer count = 6)
2) queue buffer
3) stream on
4) q-buf, dq-buf...
5) stream off

6) s_fmt /* still capture @ jpeg, 2592x1944*/
7) request buffer (buffer count = 3)
8) same as 3)->5)...

The point is in soc_camera_s_fmt_vid_cap() {
        if (icd->vb_vidq.bufs[0]) {
                dev_err(&icd->dev, "S_FMT denied: queue initialised\n");
                ret = -EBUSY;
                goto unlock;
        }
}
We didn't find vb_vidq.bufs[0] be free, (it is freed in videobuf_mmap_free(), and in __videobuf_mmap_setup, but no one calls videobuf_mmap_free(), and in __videobuf_mmap_setup it is freed at first and then allocated sequentially), so we always fail at calling s_fmt.
My idea is to implement soc_camera_reqbufs(buffer count = 0), to provide application opportunity to free this buffer node, refer to v4l2 spec, http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-reqbufs.html
"A count value of zero frees all buffers, after aborting or finishing any DMA in progress, an implicit VIDIOC_STREAMOFF."

What do you think?

Any ideas will be appreciated!
Thanks!
Qing Xu

Email: qingx@marvell.com
Application Processor Systems Engineering,
Marvell Technology Group Ltd.

