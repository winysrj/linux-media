Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:41367 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752431AbeGBMh3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Jul 2018 08:37:29 -0400
Subject: Re: [PATCHv15 05/35] media-request: add media_request_object_find
To: Tomasz Figa <tfiga@google.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20180604114648.26159-1-hverkuil@xs4all.nl>
 <20180604114648.26159-6-hverkuil@xs4all.nl>
 <CAAFQd5AANgMh8LKT37oNpajyV=LrEkjGsao0Tm9MSe9WXYRabQ@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <89a6949f-5c7d-2db7-3d1f-c9425bfb9e9f@xs4all.nl>
Date: Mon, 2 Jul 2018 14:37:27 +0200
MIME-Version: 1.0
In-Reply-To: <CAAFQd5AANgMh8LKT37oNpajyV=LrEkjGsao0Tm9MSe9WXYRabQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/07/18 14:33, Tomasz Figa wrote:
> Hi Hans,
> On Mon, Jun 4, 2018 at 8:48 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Add media_request_object_find to find a request object inside a
>> request based on ops and/or priv values.
> 
> Current code seems to always find based on both ops and priv values.

Outdated commit log. I'll change it.

Regards,

	Hans
