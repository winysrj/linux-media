Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:49711 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728757AbeKOXAd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Nov 2018 18:00:33 -0500
Message-ID: <1542286367.4915.19.camel@pengutronix.de>
Subject: Re: [PATCH v4l-utils] v4l2-compliance: test orphaned buffer support
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Date: Thu, 15 Nov 2018 13:52:47 +0100
In-Reply-To: <a7ff5286-2232-3d64-28d2-c46bd30cad5f@xs4all.nl>
References: <20181114143833.19267-1-p.zabel@pengutronix.de>
         <a7ff5286-2232-3d64-28d2-c46bd30cad5f@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2018-11-15 at 11:21 +0100, Hans Verkuil wrote:
> On 11/14/18 15:38, Philipp Zabel wrote:
> > Test that V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS is reported equally for
> > both MMAP and DMABUF memory types. If supported, try to orphan buffers
> > by calling reqbufs(0) before unmapping or closing DMABUF fds.
> > 
> > Also close exported DMABUF fds and free buffers in testDmaBuf if
> > orphaned buffers are not supported.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >  contrib/freebsd/include/linux/videodev2.h   |  1 +
> >  include/linux/videodev2.h                   |  1 +
> >  utils/common/v4l2-info.cpp                  |  1 +
> >  utils/v4l2-compliance/v4l2-compliance.h     |  1 +
> >  utils/v4l2-compliance/v4l2-test-buffers.cpp | 35 +++++++++++++++++----
> >  5 files changed, 33 insertions(+), 6 deletions(-)
> > 
> > diff --git a/contrib/freebsd/include/linux/videodev2.h b/contrib/freebsd/include/linux/videodev2.h
> > index 9928c00e4b68..33153b53c175 100644
> > --- a/contrib/freebsd/include/linux/videodev2.h
> > +++ b/contrib/freebsd/include/linux/videodev2.h
> > @@ -907,6 +907,7 @@ struct v4l2_requestbuffers {
> >  #define V4L2_BUF_CAP_SUPPORTS_USERPTR	(1 << 1)
> >  #define V4L2_BUF_CAP_SUPPORTS_DMABUF	(1 << 2)
> >  #define V4L2_BUF_CAP_SUPPORTS_REQUESTS	(1 << 3)
> > +#define V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS (1 << 4)
> >  
> >  /**
> >   * struct v4l2_plane - plane info for multi-planar buffers
> > diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> > index 79418cd39480..a39300cacb6a 100644
> > --- a/include/linux/videodev2.h
> > +++ b/include/linux/videodev2.h
> > @@ -873,6 +873,7 @@ struct v4l2_requestbuffers {
> >  #define V4L2_BUF_CAP_SUPPORTS_USERPTR	(1 << 1)
> >  #define V4L2_BUF_CAP_SUPPORTS_DMABUF	(1 << 2)
> >  #define V4L2_BUF_CAP_SUPPORTS_REQUESTS	(1 << 3)
> > +#define V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS (1 << 4)
> >  
> >  /**
> >   * struct v4l2_plane - plane info for multi-planar buffers
> > diff --git a/utils/common/v4l2-info.cpp b/utils/common/v4l2-info.cpp
> > index 258e5446f030..3699c35cb9d6 100644
> > --- a/utils/common/v4l2-info.cpp
> > +++ b/utils/common/v4l2-info.cpp
> > @@ -200,6 +200,7 @@ static const flag_def bufcap_def[] = {
> >  	{ V4L2_BUF_CAP_SUPPORTS_USERPTR, "userptr" },
> >  	{ V4L2_BUF_CAP_SUPPORTS_DMABUF, "dmabuf" },
> >  	{ V4L2_BUF_CAP_SUPPORTS_REQUESTS, "requests" },
> > +	{ V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS, "orphaned-bufs" },
> >  	{ 0, NULL }
> >  };
> >  
> > diff --git a/utils/v4l2-compliance/v4l2-compliance.h b/utils/v4l2-compliance/v4l2-compliance.h
> > index def185f17261..88ec260a9bcc 100644
> > --- a/utils/v4l2-compliance/v4l2-compliance.h
> > +++ b/utils/v4l2-compliance/v4l2-compliance.h
> > @@ -119,6 +119,7 @@ struct base_node {
> >  	__u32 valid_buftypes;
> >  	__u32 valid_buftype;
> >  	__u32 valid_memorytype;
> > +	bool has_orphaned_bufs;
> 
> I'd rename that to supports_orphaned_bufs.

Ok.

> >  };
> >  
> >  struct node : public base_node, public cv4l_fd {
> > diff --git a/utils/v4l2-compliance/v4l2-test-buffers.cpp b/utils/v4l2-compliance/v4l2-test-buffers.cpp
> > index c59a56d9ced7..6174015cb4e7 100644
> > --- a/utils/v4l2-compliance/v4l2-test-buffers.cpp
> > +++ b/utils/v4l2-compliance/v4l2-test-buffers.cpp
> > @@ -400,8 +400,11 @@ int testReqBufs(struct node *node)
> >  		mmap_valid = !ret;
> >  		if (mmap_valid)
> >  			caps = q.g_capabilities();
> > -		if (caps)
> > +		if (caps) {
> >  			fail_on_test(mmap_valid ^ !!(caps & V4L2_BUF_CAP_SUPPORTS_MMAP));
> > +			if (caps & V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS)
> > +				node->has_orphaned_bufs = true;
> > +		}
> >  
> >  		q.init(i, V4L2_MEMORY_USERPTR);
> >  		ret = q.reqbufs(node, 0);
> > @@ -418,8 +421,11 @@ int testReqBufs(struct node *node)
> >  		fail_on_test(!mmap_valid && dmabuf_valid);
> >  		// Note: dmabuf is only supported with vb2, so we can assume a
> >  		// non-0 caps value if dmabuf is supported.
> > -		if (caps || dmabuf_valid)
> > +		if (caps || dmabuf_valid) {
> >  			fail_on_test(dmabuf_valid ^ !!(caps & V4L2_BUF_CAP_SUPPORTS_DMABUF));
> > +			if (node->has_orphaned_bufs)
> > +				fail_on_test(userptr_valid ^ !!(caps & V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS));
> 
> Huh? I'm not sure what you are testing here.

I intended to test that if MMAP supports orphaned buffers, DMABUF should
as well, but stopped halfway. Otherwise we'd have to keep separate flags
for MMAP and DMABUF.

> > +		}
> >  
> >  		fail_on_test((can_stream && !is_overlay) && !mmap_valid && !userptr_valid && !dmabuf_valid);
> >  		fail_on_test((!can_stream || is_overlay) && (mmap_valid || userptr_valid || dmabuf_valid));
> > @@ -967,12 +973,22 @@ int testMmap(struct node *node, unsigned frame_count)
> 
> The setupM2M function should check if m2m_q also sets the V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS.
> I.e. this capability for m2m_q must match node->has_orphaned_bufs.
> 
> It makes no sense if it is set for the capture queue but not the output queue
> for m2m devices. And since this has to be set manually in the drivers (at least
> for now), this needs to be checked by v4l2-compliance.

I'll add a check for this.

> >  		fail_on_test(captureBufs(node, q, m2m_q, frame_count, true));
> >  		fail_on_test(node->streamoff(q.g_type()));
> >  		fail_on_test(node->streamoff(q.g_type()));
> > -		q.munmap_bufs(node);
> > -		fail_on_test(q.reqbufs(node, 0));
> > +		if (node->has_orphaned_bufs) {
> > +			fail_on_test(q.reqbufs(node, 0));
> > +			q.munmap_bufs(node);
> > +		} else {
> > +			q.munmap_bufs(node);
> > +			fail_on_test(q.reqbufs(node, 0));
> 
> This 'else' can be improved:
> 
> 		} else if (!q.reqbufs(node, 0)) {
> 			// It's either a bug or this driver should set
> 			// V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS
> 			warn("Can free buffers even if still mmap()ed\n");
> 			q.munmap_bufs(node);
> 		} else {
> 			q.munmap_bufs(node);
> 			fail_on_test(q.reqbufs(node, 0));

Ok.

> > +		}
> >  		if (node->is_m2m) {
> >  			fail_on_test(node->streamoff(m2m_q.g_type()));
> > -			m2m_q.munmap_bufs(node);
> > -			fail_on_test(m2m_q.reqbufs(node, 0));
> > +			if (node->has_orphaned_bufs) {
> > +				fail_on_test(m2m_q.reqbufs(node, 0));
> > +				m2m_q.munmap_bufs(node);
> > +			} else {
> > +				m2m_q.munmap_bufs(node);
> > +				fail_on_test(m2m_q.reqbufs(node, 0));
> > +			}
> >  		}
> >  	}
> >  	return 0;
> > @@ -1201,6 +1217,13 @@ int testDmaBuf(struct node *expbuf_node, struct node *node, unsigned frame_count
> >  		fail_on_test(captureBufs(node, q, m2m_q, frame_count, true));
> >  		fail_on_test(node->streamoff(q.g_type()));
> >  		fail_on_test(node->streamoff(q.g_type()));
> > +		if (node->has_orphaned_bufs) {
> > +			fail_on_test(q.reqbufs(node, 0));
> > +			exp_q.close_exported_fds();
> > +		} else {
> 
> Something similar to the MMAP case should be done here as well.
> 
> If nothing else, that checks that if V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS
> is *not* set, then q.reqbufs(node, 0) should fail.

Will do. Thank you for the comments!

regards
Philipp
