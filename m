Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:38897 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750833AbbIKJU5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 05:20:57 -0400
Message-ID: <55F29CB1.9090802@xs4all.nl>
Date: Fri, 11 Sep 2015 11:19:45 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Junghak Sung <jh1009.sung@samsung.com>,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	pawel@osciak.com
CC: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com
Subject: Re: [RFC PATCH v4 2/8] [media] videobuf2: Restructure vb2_buffer
 (1/3)
References: <1441797597-17389-1-git-send-email-jh1009.sung@samsung.com> <1441797597-17389-3-git-send-email-jh1009.sung@samsung.com>
In-Reply-To: <1441797597-17389-3-git-send-email-jh1009.sung@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/09/2015 01:19 PM, Junghak Sung wrote:
> Remove v4l2 stuff - v4l2_buf, v4l2_plane - from struct vb2_buffer.
> 
> Add new member variables - bytesused, length, offset, userptr, fd,
> data_offset - to struct vb2_plane in order to cover all information
> of v4l2_plane.
> struct vb2_plane {
>         <snip>
>         unsigned int            bytesused;
>         unsigned int            length;
>         union {
>                 unsigned int    offset;
>                 unsigned long   userptr;
>                 int             fd;
>         } m;
>         unsigned int            data_offset;
> }
> 
> Replace v4l2_buf with new member variables - index, type, memory - which
> are common fields for buffer management.
> struct vb2_buffer {
>         <snip>
>         unsigned int            index;
>         unsigned int            type;
>         unsigned int            memory;
>         unsigned int            num_planes;
>         struct vb2_plane        planes[VIDEO_MAX_PLANES];
>         <snip>
> };
> 
> v4l2 specific fields - flags, field, timestamp, timecode,
> sequence - are moved to vb2_v4l2_buffer in videobuf2-v4l2.c
> struct vb2_v4l2_buffer {
>         struct vb2_buffer       vb2_buf;
> 
>         __u32                   flags;
>         __u32                   field;
>         struct timeval          timestamp;
>         struct v4l2_timecode    timecode;
>         __u32                   sequence;
> };
> 
> This patch includes only changes inside of the videobuf2.
> So, in practice, we need to fold this patch and following two patches
> when merging upstream, to avoid breaking git bisectability.
> 
> Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
> Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
> Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
> Acked-by: Inki Dae <inki.dae@samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans


