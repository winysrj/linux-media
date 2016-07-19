Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:62229 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753197AbcGSP4K convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 11:56:10 -0400
From: Jean Christophe TROTIN <jean-christophe.trotin@st.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "kernel@stlinux.com" <kernel@stlinux.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Yannick FERTRE <yannick.fertre@st.com>,
	Hugues FRUCHET <hugues.fruchet@st.com>
Date: Tue, 19 Jul 2016 17:55:57 +0200
Subject: Re: [PATCH v2 2/3] [media] hva: multi-format video encoder V4L2
 driver
Message-ID: <578E4D8D.7070708@st.com>
References: <1468250057-16395-1-git-send-email-jean-christophe.trotin@st.com>
 <1468250057-16395-3-git-send-email-jean-christophe.trotin@st.com>
 <28f37284-0c57-7d22-a32d-5627079c86d5@xs4all.nl>
In-Reply-To: <28f37284-0c57-7d22-a32d-5627079c86d5@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for your comments.
I've started to take them into account.
I've got a question about V4L2_FIELD_ANY in buf_prepare (please see below).

[snip]

 >> +static int hva_buf_prepare(struct vb2_buffer *vb)
 >> +{
 >> +     struct hva_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
 >> +     struct device *dev = ctx_to_dev(ctx);
 >> +     struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 >> +
 >> +     if (vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
 >> +             struct hva_frame *frame = to_hva_frame(vbuf);
 >> +
 >> +             if (vbuf->field == V4L2_FIELD_ANY)
 >> +                     vbuf->field = V4L2_FIELD_NONE;
 >
 > Anything other than FIELD_NONE should result in an error since no interlaced 
is supported.
 > FIELD_ANY is an incorrect value as well.
 >

In videodev2.h, V4L2_FIELD_ANY is commented as "driver can choose from none, 
top, bottom, interlaced depending on whatever it thinks is approximate ...": I 
understand this comment as if vbuf->field is equal to V4L2_FIELD_ANY, then the 
driver can choose to force it to V4L2_FIELD_NONE. Furthermore, it's coded in the 
same way in vim2m.c (vim2m_buf_prepare).
Finally, if I remove these 2 lines, I've got the following error with the 
v4l2-compliance:
Streaming ioctls:
		VIDIOC_G_INPUT returned -1 (Inappropriate ioctl for device)
		VIDIOC_ENUMINPUT returned -1 (Inappropriate ioctl for device)
	test read/write: OK (Not Supported)
		VIDIOC_QUERYCAP returned 0 (Success)
		[snip]
		VIDIOC_QUERYBUF returned 0 (Success)
		VIDIOC_QBUF returned -1 (Invalid argument)
		fail: 
/local/home/frq08988/views/opensdk-2.1.4.1/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-buffers.cpp(773): 
buf.qbuf(node)
		fail: 
/local/home/frq08988/views/opensdk-2.1.4.1/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-buffers.cpp(971): 
setupM2M(node, m2m_q)
	test MMAP: FAIL

Don't you think that I could keep these two lines?

 >> +             if (vbuf->field != V4L2_FIELD_NONE) {
 >> +                     dev_dbg(dev,
 >> +                             "%s frame[%d] prepare: %d field not supported\n",
 >> +                             ctx->name, vb->index, vbuf->field);
 >> +                     return -EINVAL;
 >> +             }
 >> +
 >> +             if (!frame->prepared) {
 >> +                     /* get memory addresses */
 >> +                     frame->vaddr = vb2_plane_vaddr(&vbuf->vb2_buf, 0);
 >> +                     frame->paddr = vb2_dma_contig_plane_dma_addr(
 >> +                                     &vbuf->vb2_buf, 0);
 >> +                     frame->info = ctx->frameinfo;
 >> +                     frame->prepared = true;
 >> +
 >> +                     dev_dbg(dev,
 >> +                             "%s frame[%d] prepared; virt=%p, phy=%pad\n",
 >> +                             ctx->name, vb->index,
 >> +                             frame->vaddr, &frame->paddr);
 >> +             }
 >> +     } else {
 >> +             struct hva_stream *stream = to_hva_stream(vbuf);
 >> +
 >> +             if (!stream->prepared) {
 >> +                     /* get memory addresses */
 >> +                     stream->vaddr = vb2_plane_vaddr(&vbuf->vb2_buf, 0);
 >> +                     stream->paddr = vb2_dma_contig_plane_dma_addr(
 >> +                                     &vbuf->vb2_buf, 0);
 >> +                     stream->size = vb2_plane_size(&vbuf->vb2_buf, 0);
 >> +                     stream->prepared = true;
 >> +
 >> +                     dev_dbg(dev,
 >> +                             "%s stream[%d] prepared; virt=%p, phy=%pad\n",
 >> +                             ctx->name, vb->index,
 >> +                             stream->vaddr, &stream->paddr);
 >> +             }
 >> +     }
 >> +
 >> +     return 0;
 >> +}
 >> +

[snip]

Regards,
Jean-Christophe.
