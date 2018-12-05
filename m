Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1717C04EBF
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 18:50:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84A3B208E7
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 18:50:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 84A3B208E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727712AbeLESu6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 13:50:58 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:60101 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727679AbeLESu6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Dec 2018 13:50:58 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id UcG5gSAKnO44XUcG8gRDYj; Wed, 05 Dec 2018 19:50:56 +0100
Subject: Re: [PATCH v5] media: imx: add mem2mem device
To:     Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
References: <20181203114804.17078-1-p.zabel@pengutronix.de>
 <a8d3a554-aef8-b8e0-b8ad-f9116bcc3f39@xs4all.nl>
 <73ba2b0c-2776-5aec-193d-408dfcae6ebf@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1e246083-7e97-646c-8602-c36507879b2d@xs4all.nl>
Date:   Wed, 5 Dec 2018 19:50:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <73ba2b0c-2776-5aec-193d-408dfcae6ebf@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfAVx6MaqBOyfIj+mmBWEP6ltbvkpFAU1tnYAdFWWIOpb6f9YIdZfQ6DSLavGARFiX+bFqRuF3N4tvZQPsU0jKRlaskB/C3DJfAtTGBBr+D3yDva/oTUE
 VfW/9QRZnsR+M8dCofM69PTPR0Z7ea6U+55oRrvF9ar5St5f6gYOIAbwKF3QN6T+B0rTN5tgq3aRfWn2rrt1NngC4fbTloR/NdIIwT96YSwcThEkh6PKmTOU
 5/AUbXy+tLd3+AnrPL21+lFi3YIrzyeSCvA05UsIfoz1OPLr9m60+YJsL8z/EokxkS4bPP/91OSU+9gyKIE7gw==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/05/2018 02:20 AM, Steve Longerbeam wrote:
> Hi Hans, Philipp,
> 
> One comment on my side...
> 
> On 12/3/18 7:21 AM, Hans Verkuil wrote:
>> <snip>
>>> +void imx_media_mem2mem_device_unregister(struct imx_media_video_dev *vdev)
>>> +{
>>> +	struct mem2mem_priv *priv = to_mem2mem_priv(vdev);
>>> +	struct video_device *vfd = priv->vdev.vfd;
>>> +
>>> +	mutex_lock(&priv->mutex);
>>> +
>>> +	if (video_is_registered(vfd)) {
>>> +		video_unregister_device(vfd);
>>> +		media_entity_cleanup(&vfd->entity);
>> Is this needed?
>>
>> If this is to be part of the media controller, then I expect to see a call
>> to v4l2_m2m_register_media_controller() somewhere.
>>
> 
> Yes, I agree there should be a call to 
> v4l2_m2m_register_media_controller(). This driver does not connect with 
> any of the imx-media entities, but calling it will at least make the 
> mem2mem output/capture device entities (and processing entity) visible 
> in the media graph.
> 
> Philipp, can you pick/squash the following from my media-tree github fork?
> 
> 6fa05f5170 ("media: imx: mem2mem: Add missing media-device header")
> d355bf8b15 ("media: imx: Add missing unregister and remove of mem2mem 
> device")
> 6787a50cdc ("media: imx: mem2mem: Register with media control")
> 
> Steve
> 

Why is this driver part of the imx driver? Since it doesn't connect with
any of the imx-media entities, doesn't that mean that this is really a
stand-alone driver?

Regards,

	Hans
