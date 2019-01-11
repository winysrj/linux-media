Return-Path: <SRS0=SCQz=PT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E078C43387
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 20:16:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BDF22084C
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 20:16:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388442AbfAKUQi (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 15:16:38 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:58311 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387847AbfAKUQi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 15:16:38 -0500
Received: from [IPv6:2001:983:e9a7:1:b51b:802b:6c83:309a] ([IPv6:2001:983:e9a7:1:b51b:802b:6c83:309a])
        by smtp-cloud8.xs4all.net with ESMTPA
        id i3EJgvX47NR5yi3EKgBfIE; Fri, 11 Jan 2019 21:16:36 +0100
Subject: Re: [PATCH] vivid: do not implement VIDIOC_S_PARM for output streams
To:     Nicolas Dufresne <nicolas@ndufresne.ca>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <fc0e18f4-b499-60b4-d750-12beb06f98ce@xs4all.nl>
 <e51b9648691804cc97868a79d56e713df8e938c5.camel@ndufresne.ca>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <3cd058af-6463-a723-8e7f-cb58ad803f89@xs4all.nl>
Date:   Fri, 11 Jan 2019 21:16:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <e51b9648691804cc97868a79d56e713df8e938c5.camel@ndufresne.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfIz3jpiFbsDdkHnyiXrTLuVNKET7RZQmkL5FD8Smi6ZntTCHduJkZKyP6CTKUL2P/4POsYazBiEhSk4h72fs/glhVBghFxhc6+uP7e/c2XWYEJZwcrKv
 9gUloObZ4Ti3YNETUcct3FyPZHg5KzJDPfD2PCqRMifVOlJOWfDXO6jASvsfWr6qpsPCPZZwkBs3lOEHBgIsoIg2OPIUfM7SuGsg4KOygt2z0GAvbawYBn4z
 +uiOls6DwVn2dsF7hxZ/kLAoi/iujMBYK3XLz978owbk8CJ4WWDlcW2ccHc/dZRwHO6fKl39HzCkZcq4LIalqg==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 1/11/19 9:13 PM, Nicolas Dufresne wrote:
> Le vendredi 11 janvier 2019 à 12:37 +0100, Hans Verkuil a écrit :
>> v4l2_compliance gave a warning for the S_PARM test for output streams:
>>
>> warn: v4l2-test-formats.cpp(1235): S_PARM is supported for buftype 2, but not for ENUM_FRAMEINTERVALS
>>
>> The reason is that vivid mapped s_parm for output streams to g_parm. But if
>> S_PARM doesn't actually change anything, then it shouldn't be enabled at all.
> 
> Though now, a vivid output reflect even less an output HW, for which I
> would expect S_PARM to be used to configure the HW transmission clock.

That's done via VIDIOC_S_STD or VIDIOC_S_DV_TIMINGS, not via VIDIOC_S_PARM.

S_PARM for an output really makes no sense. At least, I can't think of any.

Regards,

	Hans

> 
>>
>> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>> ---
>> diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
>> index c931f007e5b0..7da5720b47a2 100644
>> --- a/drivers/media/platform/vivid/vivid-core.c
>> +++ b/drivers/media/platform/vivid/vivid-core.c
>> @@ -371,7 +371,7 @@ static int vidioc_s_parm(struct file *file, void *fh,
>>
>>  	if (vdev->vfl_dir == VFL_DIR_RX)
>>  		return vivid_vid_cap_s_parm(file, fh, parm);
>> -	return vivid_vid_out_g_parm(file, fh, parm);
>> +	return -ENOTTY;
>>  }
>>
>>  static int vidioc_log_status(struct file *file, void *fh)
> 

