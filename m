Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:58164 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753108AbcGSQpl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 12:45:41 -0400
Subject: Re: [PATCH v2 2/3] [media] hva: multi-format video encoder V4L2
 driver
To: Jean Christophe TROTIN <jean-christophe.trotin@st.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1468250057-16395-1-git-send-email-jean-christophe.trotin@st.com>
 <1468250057-16395-3-git-send-email-jean-christophe.trotin@st.com>
 <28f37284-0c57-7d22-a32d-5627079c86d5@xs4all.nl> <578E4D8D.7070708@st.com>
Cc: "kernel@stlinux.com" <kernel@stlinux.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Yannick FERTRE <yannick.fertre@st.com>,
	Hugues FRUCHET <hugues.fruchet@st.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <68083983-744d-d3ae-77ef-e3be64f9ce26@xs4all.nl>
Date: Tue, 19 Jul 2016 18:45:34 +0200
MIME-Version: 1.0
In-Reply-To: <578E4D8D.7070708@st.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/19/2016 05:55 PM, Jean Christophe TROTIN wrote:
> Hi Hans,
> 
> Thank you for your comments.
> I've started to take them into account.
> I've got a question about V4L2_FIELD_ANY in buf_prepare (please see below).
> 
> [snip]
> 
>  >> +static int hva_buf_prepare(struct vb2_buffer *vb)
>  >> +{
>  >> +     struct hva_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
>  >> +     struct device *dev = ctx_to_dev(ctx);
>  >> +     struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>  >> +
>  >> +     if (vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
>  >> +             struct hva_frame *frame = to_hva_frame(vbuf);
>  >> +
>  >> +             if (vbuf->field == V4L2_FIELD_ANY)
>  >> +                     vbuf->field = V4L2_FIELD_NONE;
>  >
>  > Anything other than FIELD_NONE should result in an error since no interlaced 
> is supported.
>  > FIELD_ANY is an incorrect value as well.
>  >
> 
> In videodev2.h, V4L2_FIELD_ANY is commented as "driver can choose from none, 
> top, bottom, interlaced depending on whatever it thinks is approximate ...": I 
> understand this comment as if vbuf->field is equal to V4L2_FIELD_ANY, then the 
> driver can choose to force it to V4L2_FIELD_NONE. Furthermore, it's coded in the 
> same way in vim2m.c (vim2m_buf_prepare).
> Finally, if I remove these 2 lines, I've got the following error with the 
> v4l2-compliance:
> Streaming ioctls:
> 		VIDIOC_G_INPUT returned -1 (Inappropriate ioctl for device)
> 		VIDIOC_ENUMINPUT returned -1 (Inappropriate ioctl for device)
> 	test read/write: OK (Not Supported)
> 		VIDIOC_QUERYCAP returned 0 (Success)
> 		[snip]
> 		VIDIOC_QUERYBUF returned 0 (Success)
> 		VIDIOC_QBUF returned -1 (Invalid argument)
> 		fail: 
> /local/home/frq08988/views/opensdk-2.1.4.1/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-buffers.cpp(773): 
> buf.qbuf(node)
> 		fail: 
> /local/home/frq08988/views/opensdk-2.1.4.1/sources/v4l-utils/utils/v4l2-compliance/v4l2-test-buffers.cpp(971): 
> setupM2M(node, m2m_q)
> 	test MMAP: FAIL
> 
> Don't you think that I could keep these two lines?

Keep it for now, I dug into this a bit further and it is really a workaround for
poorly written applications that can't be bothered to set the field value to a
proper value. I think the documentation needs to be updated for this.

I might change my mind, though :-)

Regards,

	Hans
