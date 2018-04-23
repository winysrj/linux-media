Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:39422 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932235AbeDWTMy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 15:12:54 -0400
Subject: Re: [PATCH v2] [media] uvcvideo: Refactor teardown of uvc on USB
 disconnect
To: Li Li <aawlbt@gmail.com>, linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
References: <CAJXMgdov1mLojsRTU5ea4Whf9i-g8fwCX97fueH6dHt8qmC_1Q@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c9813acf-ee0e-4dc8-6902-965504ac0707@xs4all.nl>
Date: Mon, 23 Apr 2018 21:12:46 +0200
MIME-Version: 1.0
In-Reply-To: <CAJXMgdov1mLojsRTU5ea4Whf9i-g8fwCX97fueH6dHt8qmC_1Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent, Kieran,

Can one of you look at this?

https://patchwork.linuxtv.org/patch/40941/

BTW, there are a *lot* of old patches delegated to you, Laurent. If neither
you or Kieran have time to look at them, then please undelegate them and I
can take a bunch of them. I see quite a few simple bug fixes (e.g.
https://patchwork.linuxtv.org/patch/42935/) that really should be merged.

Regards,

	Hans

On 04/23/2018 07:59 PM, Li Li wrote:
> https://www.spinics.net/lists/linux-media/msg115062.html
> 
> Thanks for Daniel to fix this old issue. I might overlooked it but I
> didn't find it in the latest upstream kernel.
> 
> Are we going to merge this missing patch? Thanks!
> 
> Best,
> Li
> 
