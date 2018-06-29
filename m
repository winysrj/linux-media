Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:52312 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932209AbeF2HDM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 03:03:12 -0400
Subject: Re: [PATCH 1/2] v4l-helpers: Don't close the fd in {}_s_fd
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
References: <20180628192557.22966-1-ezequiel@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <6b727801-5055-928d-4005-39caaf09200f@xs4all.nl>
Date: Fri, 29 Jun 2018 09:03:07 +0200
MIME-Version: 1.0
In-Reply-To: <20180628192557.22966-1-ezequiel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/28/2018 09:25 PM, Ezequiel Garcia wrote:
> When creating a second node via copy or assignment:
> 
>     node2 = node
> 
> The node being assigned to, i.e. node2, obtains the fd.
> This causes a later call to node2.media_open to close()
> the fd, thus unintendenly closing the original node fd,
> via the call path (e.g. for media devices):
> 
>   node2.media_open
>      v4l_media_open
>         v4l_media_s_fd
> 
> Similar call paths apply for other device types.
> Fix this by removing the close in xxx_s_fd.

I fixed this in a different way by overloading the assignment operator
and calling dup(fd). That solves this as well.

Regards,

	Hans

> 
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> ---
>  utils/common/v4l-helpers.h | 9 ---------
>  1 file changed, 9 deletions(-)
> 
> diff --git a/utils/common/v4l-helpers.h b/utils/common/v4l-helpers.h
> index c37b72712126..83d8d7d9c073 100644
> --- a/utils/common/v4l-helpers.h
> +++ b/utils/common/v4l-helpers.h
> @@ -444,9 +444,6 @@ static inline int v4l_s_fd(struct v4l_fd *f, int fd, const char *devname, bool d
>  	struct v4l2_queryctrl qc;
>  	struct v4l2_selection sel;
>  
> -	if (f->fd >= 0)
> -		f->close(f);
> -
>  	f->fd = fd;
>  	f->direct = direct;
>  	if (fd < 0)
> @@ -492,9 +489,6 @@ static inline int v4l_open(struct v4l_fd *f, const char *devname, bool non_block
>  
>  static inline int v4l_subdev_s_fd(struct v4l_fd *f, int fd, const char *devname)
>  {
> -	if (f->fd >= 0)
> -		f->close(f);
> -
>  	f->fd = fd;
>  	f->direct = false;
>  	if (fd < 0)
> @@ -525,9 +519,6 @@ static inline int v4l_subdev_open(struct v4l_fd *f, const char *devname, bool no
>  
>  static inline int v4l_media_s_fd(struct v4l_fd *f, int fd, const char *devname)
>  {
> -	if (f->fd >= 0)
> -		f->close(f);
> -
>  	f->fd = fd;
>  	f->direct = false;
>  	if (fd < 0)
> 
