Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 246DBC43387
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 08:58:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E28CE2086D
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 08:58:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbfARI6q (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 03:58:46 -0500
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:50989 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726031AbfARI6q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 03:58:46 -0500
Received: from [IPv6:2001:983:e9a7:1:3849:86c5:b8c2:266c] ([IPv6:2001:983:e9a7:1:3849:86c5:b8c2:266c])
        by smtp-cloud9.xs4all.net with ESMTPA
        id kPz9gbxhZaxzfkPzAgodUf; Fri, 18 Jan 2019 09:58:45 +0100
Subject: Re: [PATCH 0/8] Remove obsolete soc_camera drivers
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     linux-media@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
References: <20190117161802.5740-1-hverkuil-cisco@xs4all.nl>
 <20190118085624.z64orgt62ekyyni6@kekkonen.localdomain>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <738da2a6-e8a3-c09b-d9b8-4489eeb4f46a@xs4all.nl>
Date:   Fri, 18 Jan 2019 09:58:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190118085624.z64orgt62ekyyni6@kekkonen.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfK25MNlN+lO0vpr2IZZc4nUGv0UKoQZIDSvmQNAJcFIVOCq1n7dqMp6YaL7QcWD6oFHbVbmk1uxcwS+ZcGnLMNT67/BNhswchUgukuumhKKnQFgT0PNw
 CUPE3bzFqkPNrY3e/PXJ4G5cqNSmqlx9q1BnMcfBA6SQYw13zco3TtWj3mK1jjj9YyRcV2guZgjCUKWg45slDESjfDr2IawFZHPXhOvDHQjN9opMJtCZLgk2
 1QX1ODooKs5kb+vh6EoUQj3OIbqQ13YePZ0nH6JfasWd/K002Vczuzl3xXsQzF5J/XQ7SCYbCj8SCtWsnyg2Q9y/kcpspk4a9ev99db9IbHAZFX1+fwlCgUw
 jYuj2mDZobhYaEGjKtdSNCpWTpqMxA==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 1/18/19 9:56 AM, Sakari Ailus wrote:
> On Thu, Jan 17, 2019 at 05:17:54PM +0100, hverkuil-cisco@xs4all.nl wrote:
>> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>>
>> The soc_mt9t112, soc_ov772x and soc_tw9910 drivers now have
>> non-soc-camera replacements, so those three drivers can be
>> removed.
>>
>> The soc_camera sh_mobile_ceu_camera platform driver also has
>> a non-soc-camera replacement, so remove this driver as well.
>>
>> This driver was also the last driver that used soc_scale_crop,
>> so remove that too. Finally remove the test soc_camera_platform
>> driver. There will be no more soc_camera platform drivers, so this
>> platform template driver serves no purpose anymore.
> 
> For the set:
> 
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> Are you planning to move the rest of the drivers to staging and depend on
> BROKEN, or should I do that?
> 

Can you do that?

Thanks,

	Hans
