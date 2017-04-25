Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:35614 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S980537AbdDYGOm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Apr 2017 02:14:42 -0400
Subject: Re: [PATCH 1/2] [media] vb2: Fix an off by one error in
 'vb2_plane_vaddr'
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <20170423213257.14773-1-christophe.jaillet@wanadoo.fr>
 <20170424141655.GQ7456@valkosipuli.retiisi.org.uk>
 <9aab41eb-5543-58d2-211f-95fb00f5176c@wanadoo.fr>
 <20170424202906.GW7456@valkosipuli.retiisi.org.uk>
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <09a88460-39fc-7d80-e213-15e47499319d@wanadoo.fr>
Date: Tue, 25 Apr 2017 08:14:35 +0200
MIME-Version: 1.0
In-Reply-To: <20170424202906.GW7456@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le 24/04/2017 à 22:29, Sakari Ailus a écrit :
> Hi Christophe,
>
> On Mon, Apr 24, 2017 at 10:00:24PM +0200, Christophe JAILLET wrote:
>> Le 24/04/2017 à 16:16, Sakari Ailus a écrit :
>>> On Sun, Apr 23, 2017 at 11:32:57PM +0200, Christophe JAILLET wrote:
>>>> We should ensure that 'plane_no' is '< vb->num_planes' as done in
>>>> 'vb2_plane_cookie' just a few lines below.
>>>>
>>>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>>>> ---
>>>>   drivers/media/v4l2-core/videobuf2-core.c | 2 +-
>>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
>>>> index 94afbbf92807..c0175ea7e7ad 100644
>>>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>>>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>>>> @@ -868,7 +868,7 @@ EXPORT_SYMBOL_GPL(vb2_core_create_bufs);
>>>>   void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no)
>>>>   {
>>>> -	if (plane_no > vb->num_planes || !vb->planes[plane_no].mem_priv)
>>>> +	if (plane_no >= vb->num_planes || !vb->planes[plane_no].mem_priv)
>>>>   		return NULL;
>>>>   	return call_ptr_memop(vb, vaddr, vb->planes[plane_no].mem_priv);
>>> Oh my. How could this happen?
>>>
>>> This should go to stable as well.
>> Should I resubmit with "Cc: stable@vger.kernel.org" or will you add it
>> yourself?
> Please resend. And preferrably figure out which version is the first one
> requiring the fix.
>
> Mauro can then pick it up, and it ends up to stable through his tree. I.e.
> Cc: stable ... tag is enough, no need to send an actual  e-mail there.
>
> Thanks!
>
Hmm, funny to see:
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/drivers/media/v4l2-core/videobuf2-core.c?id=a9ae4692eda4b99f85757b15d60971ff78a0a0e2


Anyway,

3.2.88:
    still have the issue for both 'vb2_plane_vaddr' and 
'vb2_plane_cookie', but the file is in a slightly different 
directory*and the code is also slightly different*

3.4.113:
    still have the issue for both 'vb2_plane_vaddr' and 
'vb2_plane_cookie', but the file is in a slightly different directory

3.10.105, *3.12.73*:
    still have the issue for both 'vb2_plane_vaddr' and 'vb2_plane_cookie'

3.16.43 and up:
    'vb2_plane_cookie' is fixed there.

So, I guess, that the same +3.16 should be proposed here, to be 
consistent. Ok for you?


Should a:
    Fixes: e23ccc0ad9258 ("[media] v4l: add videobuf2 Video for Linux 2 
driver framework")
be also added? I've read somewhere that Fixes tags were needed for 
backport to stable.

CJ
