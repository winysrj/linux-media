Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:54046 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751957AbbIIJcU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Sep 2015 05:32:20 -0400
Message-ID: <55EFFC86.4060500@xs4all.nl>
Date: Wed, 09 Sep 2015 11:31:50 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Chetan Nanda <chetannanda@gmail.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: Videobuf2's vb2_dqbuf return (-EINVAL) error on streamoff
References: <CAPrYoTFMoZELC0o05e3xwvuROt_DAbf8Qc5m=_dyVUyeex10Ug@mail.gmail.com>
In-Reply-To: <CAPrYoTFMoZELC0o05e3xwvuROt_DAbf8Qc5m=_dyVUyeex10Ug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/09/15 11:19, Chetan Nanda wrote:
> [Sorry if duplicate, as my last mail rejected because of HTML content]
> 
> Hi,
> 
> I am working on a V4L2 based video decoder driver,
> 
> At user side there are two contexts.
> One is queuing/dequeuing buffers from driver (in a separate thread)
> and other is the main context, from where I am calling streamon,
> streamoff.
> 
> When I call a streamoff from main context and thread is blocking on
> dqbuf, This cause the blocking thread to unblock from dqbuf with an
> error (EINVAL).
> 
> Seems this error coming from videobuf2-core, as streamoff will unblock
> the waiting thread, and this thread will go and check (in function
> __vb2_wait_for_done_vb) for q->streaming and will return error as
> q->streaming will be set to false on streamoff.
> 
> Is it the right behavior of vb2_dqbuf to return error when streamoff is called?

Yes. No more buffers will arrive, so you want blocking waits to wake up.

Typically you would want to exit the dequeuing thread or do other clean up
actions.

> Or is it a right way to have this kind of mechanism i.e.on userside
> one thread is queue/dequeue buffers while another is doing streamoff.

This approach is fine.

Regards,

	Hans

> 
> Thanks for your help and idea.
> 
> Thanks,
> Chetan Nanda
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
