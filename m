Return-Path: <SRS0=jH9h=P3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D991CC61CE4
	for <linux-media@archiver.kernel.org>; Sat, 19 Jan 2019 09:29:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3C0A2084C
	for <linux-media@archiver.kernel.org>; Sat, 19 Jan 2019 09:29:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbfASJ3D (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 19 Jan 2019 04:29:03 -0500
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:39002 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727646AbfASJ3C (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Jan 2019 04:29:02 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud9.xs4all.net with ESMTPA
        id kmvxgo6mCRO5Zkmw1grf5w; Sat, 19 Jan 2019 10:29:01 +0100
Subject: Re: [PATCH v7] media: imx: add mem2mem device
To:     Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
References: <20190117155032.3317-1-p.zabel@pengutronix.de>
 <e68a4de5-a499-ea02-20e7-79e4d175708c@xs4all.nl>
 <1547810284.3375.6.camel@pengutronix.de>
 <1547830276.3375.20.camel@pengutronix.de>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1d1217c0-5203-1161-8fe8-b1d1eae5cb66@xs4all.nl>
Date:   Sat, 19 Jan 2019 10:28:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <1547830276.3375.20.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfFmeJ44vcIeOuvgO5loxGgOslAaVq51Xjwpea4WZ2UAB68/l5kP1aKcXHoIGKKC+juXj03VK5Ibnsmwz0lkwJ9g8XlxpUkyRa56+UB+FfAgd3HGcN5CN
 pwQiABKp+5eFxKPUCjxfc0uXTHFPdstcGfWyracNMwn5bwi5vW4eDTz+Wm/wzELu1Gy15M+g6zSTWy9eu2MFEAhlODaWmUyTIu+e/0Equ4S5/WWYhLEdjG9i
 +UVY3YdItZmqmQ/lNFYP5zMy1wNPl3BGNUueFvhNalMEq51mrl6IZqeAi/W9vkp38+OoDqnXI7ZTr6AKt/lQ+A==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 01/18/2019 05:51 PM, Philipp Zabel wrote:
> On Fri, 2019-01-18 at 12:18 +0100, Philipp Zabel wrote:
>> Hi Hans,
>>
>> On Fri, 2019-01-18 at 10:30 +0100, Hans Verkuil wrote:
>>> On 1/17/19 4:50 PM, Philipp Zabel wrote:
>>
>> [...]
>>>> +
>>>> +static const struct video_device ipu_csc_scaler_videodev_template = {
>>>> +	.name		= "ipu0_ic_pp mem2mem",
>>>
>>> I would expect to see something like 'imx-media-csc-scaler' as the name.
>>> Wouldn't that be more descriptive?
>>
>> Yes, thank you. I'll change this as well.
> 
> Actually, this is overwritten a few lines later anyway:
> 
>        snprintf(vfd->name, sizeof(vfd->name), "ipu_ic_pp mem2mem");
> 
> Not that it makes a difference. But I noticed that I chose this name for
> something close to consistency with the other IPU devices:
> 
> $ cat /sys/class/video4linux/video*/name
> ipu_ic_pp mem2mem
> coda-encoder
> coda-decoder
> ipu1_ic_prpenc capture
> ipu1_ic_prpvf capture
> ipu2_ic_prpenc capture
> ipu2_ic_prpvf capture
> ipu1_csi0 capture
> ipu1_csi1 capture
> ipu2_csi0 capture
> ipu2_csi1 capture
> 
> They all start with the IPU / subdevice (/ IC task) prefix.
> Maybe "ipu_ic_pp csc/scaler" would be more appropriate?

That will work for me.

Regards,

	Hans

> 
> regards
> Philipp
> 

