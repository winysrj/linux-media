Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:35326 "EHLO
	mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbcDLFQC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Apr 2016 01:16:02 -0400
Received: by mail-lf0-f43.google.com with SMTP id c126so9233421lfb.2
        for <linux-media@vger.kernel.org>; Mon, 11 Apr 2016 22:16:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <570C264F.2010204@osg.samsung.com>
References: <1460375335-20188-1-git-send-email-luisbg@osg.samsung.com>
 <20160411200911.GA11780@joana> <570C264F.2010204@osg.samsung.com>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Tue, 12 Apr 2016 10:45:40 +0530
Message-ID: <CAO_48GG5W8MwfCMe=_JpYLMTWpP+yUnNpoQLuj6TV=XbrLvxrg@mail.gmail.com>
Subject: Re: [RESEND] fence: add missing descriptions for fence
To: Luis de Bethencourt <luisbg@osg.samsung.com>
Cc: Gustavo Padovan <gustavo@padovan.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Linaro MM SIG Mailman List <linaro-mm-sig@lists.linaro.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Luis,


On 12 April 2016 at 04:03, Luis de Bethencourt <luisbg@osg.samsung.com> wrote:
> On 11/04/16 21:09, Gustavo Padovan wrote:
>> Hi Luis,
>>
>> 2016-04-11 Luis de Bethencourt <luisbg@osg.samsung.com>:
>>
>>> The members child_list and active_list were added to the fence struct
>>> without descriptions for the Documentation. Adding these.
>>>
Thanks for the patch; will get it queued for for-next.

>>> Fixes: b55b54b5db33 ("staging/android: remove struct sync_pt")
>>> Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
>>> Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
>>> ---
>>> Hi,
>>>
>>> Just resending this patch since it hasn't had any reviews in since
>>> March 21st.
>>>
>>> Thanks,
>>> Luis
>>>
>>>  include/linux/fence.h | 2 ++
>>>  1 file changed, 2 insertions(+)
>>
>> Reviewed-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
>>
>>       Gustavo
>>
>
> Thank you Gustavo.
>
> Nice seeing you around here :)
>
> Luis

BR,
Sumit.
