Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:58042 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750870AbcF0JHR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2016 05:07:17 -0400
Subject: Re: [PATCH] v4l2-compliance: Improve test readability when fail
To: Helen Koike <helen.koike@collabora.co.uk>,
	linux-media@vger.kernel.org
References: <3986d5a5773ab05e01d63c54687ad6425df0f952.1462807597.git.helen.koike@collabora.co.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <02fd02ff-01e1-4990-5c65-a570e64fd94f@xs4all.nl>
Date: Mon, 27 Jun 2016 11:07:12 +0200
MIME-Version: 1.0
In-Reply-To: <3986d5a5773ab05e01d63c54687ad6425df0f952.1462807597.git.helen.koike@collabora.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/09/2016 05:44 PM, Helen Koike wrote:
> In case of failure, print "q.create_bufs(node, 1, &fmt) != EINVAL" instead
> of "ret != EINVAL"
> 
> Signed-off-by: Helen Koike <helen.koike@collabora.co.uk>
> ---
> 
> Hello,
> 
> I was wondering, why the q.create_bufs is expected to should return EINVAL in this test? The height and size are set to half of the original values, and the type and memory doesn't seems to change.

For all drivers currently in the kernel the buffer size that create_bufs wants should be >= the size
of the current format.

This checks if the drivers perform that test correctly.

In theory it should be possible to allocate smaller buffers as well and drivers that
allow on-the-fly format changes, but such drivers do not exist today.

If such drivers arrive, then this test should probably be modified.

Regards,

	Hans

> 
> Thank you
> 
>  utils/v4l2-compliance/v4l2-test-buffers.cpp | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/utils/v4l2-compliance/v4l2-test-buffers.cpp b/utils/v4l2-compliance/v4l2-test-buffers.cpp
> index 6c5ed55..fb14170 100644
> --- a/utils/v4l2-compliance/v4l2-test-buffers.cpp
> +++ b/utils/v4l2-compliance/v4l2-test-buffers.cpp
> @@ -955,8 +955,7 @@ int testMmap(struct node *node, unsigned frame_count)
>  				fmt.s_height(fmt.g_height() / 2);
>  				for (unsigned p = 0; p < fmt.g_num_planes(); p++)
>  					fmt.s_sizeimage(fmt.g_sizeimage(p) / 2, p);
> -				ret = q.create_bufs(node, 1, &fmt);
> -				fail_on_test(ret != EINVAL);
> +				fail_on_test(q.create_bufs(node, 1, &fmt) != EINVAL);
>  				fail_on_test(testQueryBuf(node, cur_fmt.type, q.g_buffers()));
>  				fmt = cur_fmt;
>  				for (unsigned p = 0; p < fmt.g_num_planes(); p++)
> 
