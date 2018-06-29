Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:39856 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752811AbeF2SHb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 14:07:31 -0400
Message-ID: <02c613919fec816e1166823372c8f1d9c94a3488.camel@collabora.com>
Subject: Re: [PATCH 1/2] v4l-helpers: Don't close the fd in {}_s_fd
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Date: Fri, 29 Jun 2018 15:07:23 -0300
In-Reply-To: <6b727801-5055-928d-4005-39caaf09200f@xs4all.nl>
References: <20180628192557.22966-1-ezequiel@collabora.com>
         <6b727801-5055-928d-4005-39caaf09200f@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey Hans,

On Fri, 2018-06-29 at 09:03 +0200, Hans Verkuil wrote:
> On 06/28/2018 09:25 PM, Ezequiel Garcia wrote:
> > When creating a second node via copy or assignment:
> > 
> >     node2 = node
> > 
> > The node being assigned to, i.e. node2, obtains the fd.
> > This causes a later call to node2.media_open to close()
> > the fd, thus unintendenly closing the original node fd,
> > via the call path (e.g. for media devices):
> > 
> >   node2.media_open
> >      v4l_media_open
> >         v4l_media_s_fd
> > 
> > Similar call paths apply for other device types.
> > Fix this by removing the close in xxx_s_fd.
> 
> I fixed this in a different way by overloading the assignment
> operator
> and calling dup(fd). That solves this as well.
> 

This patch is also needed to prevent the compliance tool
from unintendenly closing a descriptor.

diff --git a/utils/common/v4l-helpers.h b/utils/common/v4l-helpers.h
index 27683a3d286d..45ed997379a1 100644
--- a/utils/common/v4l-helpers.h
+++ b/utils/common/v4l-helpers.h
@@ -118,7 +118,11 @@ static inline int v4l_wrap_open(struct v4l_fd *f,
const char *file, int oflag, .
 
 static inline int v4l_wrap_close(struct v4l_fd *f)
 {
-       return close(f->fd);
+       int ret;
+
+       ret = close(f->fd);
+       f->fd = -1;
+       return ret;
 }
 
 static inline ssize_t v4l_wrap_read(struct v4l_fd *f, void *buffer,
size_t n)

Regards,
Eze
