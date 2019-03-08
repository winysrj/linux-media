Return-Path: <SRS0=k2dg=RL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59862C43381
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 13:59:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30F9120851
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 13:59:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbfCHN7b (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:59:31 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:35698 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726601AbfCHN7b (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Mar 2019 08:59:31 -0500
Received: from [IPv6:2001:420:44c1:2579:1aa:f05e:8209:429d] ([IPv6:2001:420:44c1:2579:1aa:f05e:8209:429d])
        by smtp-cloud8.xs4all.net with ESMTPA
        id 2G22h2Ekc4HFn2G25h21g7; Fri, 08 Mar 2019 14:59:29 +0100
Subject: Re: [PATCHv2 4/9] media-entity: set ent_enum->bmap to NULL after
 freeing it
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     linux-media@vger.kernel.org,
        Helen Koike <helen.koike@collabora.com>
References: <20190305095847.21428-1-hverkuil-cisco@xs4all.nl>
 <20190305095847.21428-5-hverkuil-cisco@xs4all.nl>
 <20190305193913.GF14928@pendragon.ideasonboard.com>
 <8ea050d7-8827-9432-9737-3a704ea8cfe4@xs4all.nl>
 <20190308112648.GD4802@pendragon.ideasonboard.com>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <a2e534c4-33a4-2ef2-1ab1-a49805772c37@xs4all.nl>
Date:   Fri, 8 Mar 2019 14:59:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190308112648.GD4802@pendragon.ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfK8nnPgJWtyx1izSe20IZUW5IVVrQH2Zy/zdJZYZNPLmIvT90Q4KU/WsPAHxYcgV9yhyhyuF88Z1kmE2kEigLOmdVHe4625nCM0HaP/3DMxIIORnWjx9
 P0yFUJAXrwgvTZNBB/q/B6L/304Yv7c1rj4xpq8/5MVQYiuiOxRiElBjeYITrWQ5lbhr3bJU4ypRXO/ilDZ8VZm7qYqTd+OgxO7/X6cJVLmiwQj08a/Z8CGL
 vCg121xMC0V2V1jlNj/E0qhO/E6xdogof7FPoPn6QkZdV0IsjHvImnWafAr0qGetkrV3B2JJ0g6hm3QapV82NzjFGWLGkuyGRwnUw2cYQhGNJpbLv1vjMYAv
 WNaXiWVPn0TVfHKX5X8agjiNHl4Hbg==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 3/8/19 12:26 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Thu, Mar 07, 2019 at 10:23:03AM +0100, Hans Verkuil wrote:
>> On 3/5/19 8:39 PM, Laurent Pinchart wrote:
>>> On Tue, Mar 05, 2019 at 10:58:42AM +0100, hverkuil-cisco@xs4all.nl wrote:
>>>> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>>>>
>>>> Ensure that this pointer is set to NULL after it is freed.
>>>> The vimc driver has a static media_entity and after
>>>> unbinding and rebinding the vimc device the media code will
>>>> try to free this pointer again since it wasn't set to NULL.
>>>
>>> I still think the problem lies in the vimc driver. Reusing static
>>> structures is really asking for trouble. I'm however not opposed to
>>> merging this patch, as you mentioned the problem will be fixed in vimc
>>> too. I still wonder, though, if merging this couldn't make it easier for
>>> drivers to do the wrong thing.
>>
>> I'm keeping this patch :-)
>>
>> I don't think that what vimc is doing is wrong in principle, just very unusual.
> 
> I disagree here. We've developed the media controller (and V4L2) core
> code with many assumptions that structures are zeroed on allocation. For
> the structures that are meant to be registered once only, the code
> assumes, explicitly and implicitly, that some of the fields are zeroed.
> Removing that assumption for the odd case of vimc will require you to
> chase bugs for a long time. You've caught a few of the easier ones here,
> I'm sure other will linger for a much longer time before they get fixed.
> In the vimc case, the best option is to zero the structure manually if
> you don't want to allocate it dynamically (and I think it should be
> allocated dynamically).
> 
> For the record, I ran into a similar problem before when trying to
> unregister and re-register a struct device. I reported what I considered
> to be a bug, and Greg very clearly told me it was plain wrong. You will
> run into similar issues due to the platform_device embedded in struct
> vimc_device. Let's just allocate it dynamically.
> 
>> Also I think it makes the mc framework more robust by properly zeroing this
>> pointer.
> 
> This patch is not wrong per-se, and I'm not opposed to it, but we should
> fix issues in drivers, which would render this patch unneeded.
> 

I posted a v4 where I drop this patch and instead zero the global
media_device struct in the vimc probe() function.

Regards,

	Hans
