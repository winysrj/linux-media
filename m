Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EEE1C65BAE
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 12:51:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25B2020879
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 12:51:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 25B2020879
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729232AbeLMMvb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 07:51:31 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:54155 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729092AbeLMMvb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 07:51:31 -0500
Received: from [IPv6:2001:983:e9a7:1:8c39:f7d7:e233:2ba6] ([IPv6:2001:983:e9a7:1:8c39:f7d7:e233:2ba6])
        by smtp-cloud8.xs4all.net with ESMTPA
        id XQSegsk5wuDWoXQSfgNnqG; Thu, 13 Dec 2018 13:51:29 +0100
Subject: Re: [RFCv4 PATCH 1/3] uapi/linux/media.h: add property support
From:   Hans Verkuil <hverkuil@xs4all.nl>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <20181121154024.13906-1-hverkuil@xs4all.nl>
 <20181121154024.13906-2-hverkuil@xs4all.nl>
 <20181212061819.111a9631@coco.lan>
 <e26a07ef-836e-5943-508a-dd5f8c73f0cd@xs4all.nl>
Message-ID: <e16eb408-92a9-84f1-a6ab-2dbc4e761c98@xs4all.nl>
Date:   Thu, 13 Dec 2018 13:51:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <e26a07ef-836e-5943-508a-dd5f8c73f0cd@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfGK1gxaoNveTFdHzcaQXyzNSeEfcXIVhRAcSZOmpsZzv9Gqp5Ge/Gv61xVFXFJjHZZbnBrGT8NO2lJQt2YG8DPyQJF7yUxSCfnkVXDnUdSoH+CWLIqiT
 2wf3nNNOfVTQQF3CUWwksSBxbIWsxS9wIaJ8mGsAg9q1bc3ewizFe5G2lYiRmn60TGHPX52IUZh2bLs2TA+m4bifAl2UhLvnnprBTeHYvQACGfgBspX2SUcn
 v/bvnB1gZ2fDxYNfRfEjmERG8+gwGR0nABvcLorp7eL/THeEFe5cCCsZEXx3JkPmiQeM46jHVp19l39GlJjDafSx1UqyQ1x7h6W2Y2ADaZKKiayKgtHHucUO
 t+pLza2E
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/12/18 9:43 AM, Hans Verkuil wrote:
> On 12/12/18 9:18 AM, Mauro Carvalho Chehab wrote:
>>>  /* ioctls */
>>> @@ -368,6 +446,8 @@ struct media_v2_topology {
>>>  #define MEDIA_IOC_ENUM_ENTITIES	_IOWR('|', 0x01, struct media_entity_desc)
>>>  #define MEDIA_IOC_ENUM_LINKS	_IOWR('|', 0x02, struct media_links_enum)
>>>  #define MEDIA_IOC_SETUP_LINK	_IOWR('|', 0x03, struct media_link_desc)
>>> +/* Old MEDIA_IOC_G_TOPOLOGY ioctl without props support */
>>> +#define MEDIA_IOC_G_TOPOLOGY_OLD 0xc0487c04
>>
>> I would avoid calling it "_OLD". we may have a V3, V4, V5, ... of this
>> ioctl.
>>
>> I would, instead, define an _IOWR_COMPAT macro that would take an extra
>> parameter, in order to get the size of part of the struct, e. g. something
>> like:
>>
>> #define MEDIA_IOC_G_TOPOLOGY_V1		_IOWR_COMPAT('|', 0x04, struct media_v2_topology, num_props)
> 
> That's not a bad idea, actually.
> 
>>
>> Also, I don't see any good reason why to keep this at uAPI (except for a
>> mc-compliance tool that would test both versions - but this could be
>> defined directly there).
> 
> Makes sense.

Ah, this means that applications like gstreamer cannot fall back to the older
G_TOPOLOGY ioctl. They don't know which kernel they are running against, so
they will probably want to try the new one first before falling back to the
old version.

I wonder how drm does this. Does anyone know?

Regards,

	Hans

> 
>>
>>>  #define MEDIA_IOC_G_TOPOLOGY	_IOWR('|', 0x04, struct media_v2_topology)
>>>  #define MEDIA_IOC_REQUEST_ALLOC	_IOR ('|', 0x05, int)
>>>  
>>
>> Thanks,
>> Mauro
>>
> 
> Regards,
> 
> 	Hans
> 

