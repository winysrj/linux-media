Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:54925 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932541AbcCTAHT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Mar 2016 20:07:19 -0400
Message-ID: <56EDE9B2.1080406@osg.samsung.com>
Date: Sun, 20 Mar 2016 00:07:14 +0000
From: Luis de Bethencourt <luisbg@osg.samsung.com>
MIME-Version: 1.0
To: Javier Martinez Canillas <javier@dowhile0.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
	sumit.semwal@linaro.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	linaro-mm-sig@lists.linaro.org
Subject: Re: [PATCH] fence: add missing descriptions for fence
References: <1458417037-26691-1-git-send-email-luisbg@osg.samsung.com> <CABxcv==y2D=B7Rf-8PsMzHfeqaoetV5xJXNQt0ZSn7-WK0ZuLw@mail.gmail.com>
In-Reply-To: <CABxcv==y2D=B7Rf-8PsMzHfeqaoetV5xJXNQt0ZSn7-WK0ZuLw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19/03/16 23:55, Javier Martinez Canillas wrote:
> Hello Luis,
> 
> On Sat, Mar 19, 2016 at 4:50 PM, Luis de Bethencourt
> <luisbg@osg.samsung.com> wrote:
>> Commit b55b54b5db33 ("staging/android: remove struct sync_pt")
>> added the members child_list and active_list to the fence struct, but
>> didn't add descriptions for these. Adding the descriptions.
>>
> 
> Patches whose commit message mentions a specific commit that
> introduced and issue, usually also have a "Fixes:" tag before the
> S-o-B. For example this patch should have:
> 
> Fixes: b55b54b5db33 ("staging/android: remove struct sync_pt")
>> Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
>> ---
>> Hi,
>>
>> Noticed this missing descriptions when running make htmldocs.
>>
>> Got the following warnings:
>> .//include/linux/fence.h:84: warning: No description found for parameter 'child_list'
>> .//include/linux/fence.h:84: warning: No description found for parameter 'active_list'
>>
>> Thanks :)
>> Luis
>>
> 
> Patch looks good to me.
> 
> Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
> 
> Best regards,
> Javier
> 

Hi Javier,

I didn't knew that, but thanks for saying so I can learn and use it in the
future.

I used the 'Commit b55b54b5db33 ("staging/android: remove struct sync_pt")'
format because that is what checkpatch recommended. But after re-reading
Documentation/SubmittingPatches it all makes sense and the process is clear
in my head.

Thanks!
Luis
