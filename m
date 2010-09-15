Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:36916 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab0IOUZj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Sep 2010 16:25:39 -0400
Received: by ewy23 with SMTP id 23so363057ewy.19
        for <linux-media@vger.kernel.org>; Wed, 15 Sep 2010 13:25:38 -0700 (PDT)
Message-ID: <4C912BB3.90107@osciak.com>
Date: Wed, 15 Sep 2010 22:25:23 +0200
From: Pawel Osciak <pawel@osciak.com>
MIME-Version: 1.0
To: han jonghun <jonghun79.han@gmail.com>
CC: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, t.fujak@samsung.com
Subject: Re: [PATCH v1 7/7] v4l: videobuf2: add CMA allocator
References: <1284023988-23351-1-git-send-email-p.osciak@samsung.com>	<1284023988-23351-8-git-send-email-p.osciak@samsung.com> <AANLkTi=QYNNLqAYZcwECpa8Fxmpxt05i_0M_v+wk=+PJ@mail.gmail.com>
In-Reply-To: <AANLkTi=QYNNLqAYZcwECpa8Fxmpxt05i_0M_v+wk=+PJ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On 09/15/2010 10:55 AM, han jonghun wrote:
> Hello,
>
> In vb2_cma_put if buf->refcount is 0, cma_free is called.
> But vb2_cma_put is usually called from munmap.
> In my opinion cma_free should be called from VIDIOC_REQBUFS(0) not munmap.
>

cma_free has to be called from both, since we do not always call
VIDIOC_REQBUFS(0) after finishing. If an application just closes
the file descriptor (or even dies), we need a way to clean up the
memory.

-- 
Best regards,
Pawel Osciak
