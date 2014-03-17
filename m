Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2223 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932991AbaCQNMN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Mar 2014 09:12:13 -0400
Message-ID: <5326F49B.2050203@xs4all.nl>
Date: Mon, 17 Mar 2014 14:11:55 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: laurent.pinchart@ideasonboard.com, pawel@osciak.com
Subject: Re: [REVIEWv3 PATCH for v3.15 0/5] v4l2 core sparse error/warning
 fixes
References: <1395060863-42211-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1395060863-42211-1-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/17/2014 01:54 PM, Hans Verkuil wrote:
> These five patches fix sparse errors and warnings coming from the v4l2
> core. There are more, but those seem to be problems with sparse itself (see
> my posts from Saturday on that topic).
> 
> Please take a good look at patch 3/5 in particular: that fixes sparse
> errors introduced by my vb2 changes, and required some rework to get it
> accepted by sparse without errors or warnings.
> 
> The rework required the introduction of more type-specific call_*op macros,
> but on the other hand the fail_op macros could be dropped. Sort of one
> step backwards, one step forwards.
> 
> If someone can think of a smarter solution for this, then please let me
> know.
> 
> Regards,
> 
> 	Hans
> 
> Changes since v1:
> 

Forgot to mention:

- in patch 1/5 moved v4l2_subdev_notify from v4l2-subdev.h to v4l2-device.h
  and made it a static inline function as per Laurent's suggestion.

> - added patch 2/5: the call_ptr_memop function checks for IS_ERR_OR_NULL
>   to see if a pointer is valid or not. The __qbuf_dmabuf code only used
>   IS_ERR. Made this consistent with both call_ptr_memop and the other
>   pointer checks elsewhere in the vb2 core code.
> 
> - fixed a small typo in a comment that Pawel remarked upon.
> 
> - Rewrote patch 5/5: Laurent wanted to keep the __user annotation with the
>   user_ptr. The reason I hadn't done that was that I couldn't make it work,
>   but I had an idea that moving the __user annotation before the '**' might
>   do the trick, and that helped indeed.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

