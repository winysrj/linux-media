Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:43253 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427AbcDKWd4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2016 18:33:56 -0400
Message-ID: <570C264F.2010204@osg.samsung.com>
Date: Mon, 11 Apr 2016 23:33:51 +0100
From: Luis de Bethencourt <luisbg@osg.samsung.com>
MIME-Version: 1.0
To: Gustavo Padovan <gustavo@padovan.org>,
	linux-kernel@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [RESEND] fence: add missing descriptions for fence
References: <1460375335-20188-1-git-send-email-luisbg@osg.samsung.com> <20160411200911.GA11780@joana>
In-Reply-To: <20160411200911.GA11780@joana>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/04/16 21:09, Gustavo Padovan wrote:
> Hi Luis,
> 
> 2016-04-11 Luis de Bethencourt <luisbg@osg.samsung.com>:
> 
>> The members child_list and active_list were added to the fence struct
>> without descriptions for the Documentation. Adding these.
>>
>> Fixes: b55b54b5db33 ("staging/android: remove struct sync_pt")
>> Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
>> Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
>> ---
>> Hi,
>>
>> Just resending this patch since it hasn't had any reviews in since
>> March 21st.
>>
>> Thanks,
>> Luis
>>
>>  include/linux/fence.h | 2 ++
>>  1 file changed, 2 insertions(+)
> 
> Reviewed-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
> 
> 	Gustavo
> 

Thank you Gustavo.

Nice seeing you around here :)

Luis
