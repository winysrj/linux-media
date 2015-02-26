Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:45298 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751526AbbBZFSo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2015 00:18:44 -0500
From: Sudip JAIN <sudip.jain@st.com>
To: Jeremiah Mahler <jmmahler@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 26 Feb 2015 13:18:31 +0800
Subject: RE: 0001-media-vb2-Fill-vb2_buffer-with-bytesused-from-user.patch;
 kernel version 3.10.69
Message-ID: <AE3729EDFAD6D548827A31E3191F1E5B0138E8DF@EAPEX1MAIL1.st.com>
References: <AE3729EDFAD6D548827A31E3191F1E5B0138E8D7@EAPEX1MAIL1.st.com>,<20150225182308.GB27977@hudson.localdomain>
In-Reply-To: <20150225182308.GB27977@hudson.localdomain>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Jeremiah,

Please find the patch  "inline"

commit 3390900680e5182998916c8fa231bc79cd84046b
Author: Sudip Jain <sudip.jain@st.com>
Date:   Thu Feb 26 10:40:34 2015 +0530

    media: vb2: Fill vb2_buffer with bytesused from user
    
    In vb2_qbuf for dmabuf memory type, userside bytesused is not read to
    vb2 buffer. This leads garbage value being copied from __qbuf_dmabuf()
    back to user in __fill_v4l2_buffer().
    
    As a default case, the vb2 framework must trust the userside value,
    and also allow driver's buffer prepare function prefer modify/update
    or not to.
    
    Applied on kernel version 3.10.69
    
    Change-Id: Ieda389403898935f59c2e2994106f3e5238cfefd
    Signed-off-by: Sudip Jain <sudip.jain@st.com>

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 5e47ba4..54fe9c9 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -919,6 +919,8 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
                                        b->m.planes[plane].m.fd;
                                v4l2_planes[plane].length =
                                        b->m.planes[plane].length;
+                               v4l2_planes[plane].bytesused =
+                                       b->m.planes[plane].bytesused;
                                v4l2_planes[plane].data_offset =
                                        b->m.planes[plane].data_offset;
                        }
@@ -943,6 +945,7 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
                if (b->memory == V4L2_MEMORY_DMABUF) {
                        v4l2_planes[0].m.fd = b->m.fd;
                        v4l2_planes[0].length = b->length;
+                       v4l2_planes[0].bytesused = b->bytesused;
                        v4l2_planes[0].data_offset = 0;
                }

Thanks,
Sudip
________________________________________
From: Jeremiah Mahler [jmmahler@gmail.com]
Sent: Wednesday, February 25, 2015 11:53 PM
To: Sudip JAIN
Cc: linux-media@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: 0001-media-vb2-Fill-vb2_buffer-with-bytesused-from-user.patch

Sudip,

On Wed, Feb 25, 2015 at 03:29:22PM +0800, Sudip JAIN wrote:
> Dear Maintainer,
>
> PFA attached patch that prevents user from being returned garbage bytesused value from vb2 framework.
>
> Regards,
> Sudip Jain
>

Patches should never be submitted as attachments, they should be inline.

See Documentation/SubmittingPatches for more info.

[...]

--
- Jeremiah Mahler
