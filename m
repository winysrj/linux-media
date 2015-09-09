Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f171.google.com ([209.85.160.171]:32809 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbbIIJTY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Sep 2015 05:19:24 -0400
Received: by ykei199 with SMTP id i199so5608151yke.0
        for <linux-media@vger.kernel.org>; Wed, 09 Sep 2015 02:19:23 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 9 Sep 2015 14:49:23 +0530
Message-ID: <CAPrYoTFMoZELC0o05e3xwvuROt_DAbf8Qc5m=_dyVUyeex10Ug@mail.gmail.com>
Subject: Videobuf2's vb2_dqbuf return (-EINVAL) error on streamoff
From: Chetan Nanda <chetannanda@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[Sorry if duplicate, as my last mail rejected because of HTML content]

Hi,

I am working on a V4L2 based video decoder driver,

At user side there are two contexts.
One is queuing/dequeuing buffers from driver (in a separate thread)
and other is the main context, from where I am calling streamon,
streamoff.

When I call a streamoff from main context and thread is blocking on
dqbuf, This cause the blocking thread to unblock from dqbuf with an
error (EINVAL).

Seems this error coming from videobuf2-core, as streamoff will unblock
the waiting thread, and this thread will go and check (in function
__vb2_wait_for_done_vb) for q->streaming and will return error as
q->streaming will be set to false on streamoff.

Is it the right behavior of vb2_dqbuf to return error when streamoff is called?

Or is it a right way to have this kind of mechanism i.e.on userside
one thread is queue/dequeue buffers while another is doing streamoff.

Thanks for your help and idea.

Thanks,
Chetan Nanda
