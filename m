Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105Ab2HLQsg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Aug 2012 12:48:36 -0400
Message-ID: <5027DE5F.9030004@redhat.com>
Date: Sun, 12 Aug 2012 13:48:31 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sean Young <sean@mess.org>
CC: Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/6] [media] iguanair: Fix return value on transmit
References: <1344626888-10536-1-git-send-email-sean@mess.org> <20120811205232.GA5116@pequod.mess.org>
In-Reply-To: <20120811205232.GA5116@pequod.mess.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 11-08-2012 17:52, Sean Young escreveu:
> On Fri, Aug 10, 2012 at 08:28:03PM +0100, Sean Young wrote:
>> Transmit returned 0 after sending and failed to send anything if the amount
>> exceeded its buffer size. Also fix some minor errors.
>>
>> Signed-off-by: Sean Young <sean@mess.org>
> 
> I'm sorry, this patch series wasn't diffed against the right tree, so it
> won't apply. I'll need to rediff and retest. In the mean time any review
> comments would be appreciated.

Ok, I'll mark them as "rejected" at patchwork per your request.

Regards,
Mauro
> 
> 
> Sean
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

