Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:46744 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752486AbdHJQ4K (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Aug 2017 12:56:10 -0400
Subject: Re: [PATCH 5/6] [media] rc: rename RC_TYPE_* to RC_PROTO_* and
 RC_BIT_* to RC_PROTO_BIT_*
To: Sean Young <sean@mess.org>, linux-media@vger.kernel.org
References: <cover.1502137028.git.sean@mess.org>
 <98d93968b26e9fcdbc3afba4e8354f44f9188c9f.1502137028.git.sean@mess.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <40d8e7fc-b690-8162-53bc-2d5d123b5fe4@xs4all.nl>
Date: Thu, 10 Aug 2017 18:56:08 +0200
MIME-Version: 1.0
In-Reply-To: <98d93968b26e9fcdbc3afba4e8354f44f9188c9f.1502137028.git.sean@mess.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/08/17 22:20, Sean Young wrote:
> RC_TYPE is confusing and it's just the protocol. So rename it.
> 
> Suggested-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Much better! It's a bit of a painful patch, but so be it. The old names
were really confusing.

> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  drivers/hid/hid-picolcd_cir.c                      |   2 +-

Is a separate Ack needed for this change?

Regards,

	Hans
