Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:45513 "EHLO
        mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934150AbdKQH3K (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 02:29:10 -0500
Received: by mail-it0-f42.google.com with SMTP id l196so2999135itl.4
        for <linux-media@vger.kernel.org>; Thu, 16 Nov 2017 23:29:09 -0800 (PST)
From: Alexandre Courbot <acourbot@chromium.org>
To: Gustavo Padovan <gustavo@padovan.org>
Cc: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        <linux-kernel@vger.kernel.org>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [RFC v5 09/11] [media] vb2: add infrastructure to support =?iso-8859-1?Q?out-fences?=
Date: Fri, 17 Nov 2017 16:29:04 +0900
MIME-Version: 1.0
Message-ID: <c452dc82-d7a6-4f8a-b4fe-2c98bf41106f@chromium.org>
In-Reply-To: <17276dda-817b-4977-bb6e-77a818fe5f3e@chromium.org>
References: <20171115171057.17340-1-gustavo@padovan.org>
 <20171115171057.17340-10-gustavo@padovan.org>
 <17276dda-817b-4977-bb6e-77a818fe5f3e@chromium.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, November 17, 2017 4:19:00 PM JST, Alexandre Courbot wrote:
> On Thursday, November 16, 2017 2:10:55 AM JST, Gustavo Padovan wrote:
>> From: Gustavo Padovan <gustavo.padovan@collabora.com>
>> 
>> Add vb2_setup_out_fence() and the needed members to struct vb2_buffer.
>> 
>> v3:
>> 	- Do not hold yet another ref to the out_fence (Brian Starkey)
>> 
>> v2:	- change it to reflect fd_install at DQEVENT ...
>
> out_fence_fd is allocated in this patch but not used anywhere 
> for the moment.
> For consistency, maybe move its allocation to the next patch, 
> or move the call
> to fd_install() here if that is possible? In both cases, the 
> call to get_unused_fd() can be moved right before fd_install() 
> so you don't need to
> call put_unused_fd() in the error paths below.

Aha, just realized that fd_install() was called in qbuf() :) Other comments 
probably still hold though.

>
> ... same thing for sync_file too. Maybe this patch can just be merged into
> the next one? The current patch just creates an incomplete 
> version of vb2_setup_out_fence() for which no user exist yet.
>
>> +
>> +	vb->out_fence = vb2_fence_alloc(q->out_fence_context);
>> +	if (!vb->out_fence) {
>> +		put_unused_fd(vb->out_fence_fd);
>> +		return -ENOMEM; ...
>
>
