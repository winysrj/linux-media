Return-Path: <SRS0=Y87V=OU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B699C5CFFE
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 08:22:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEF492082F
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 08:22:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EEF492082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbeLKIWs (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 11 Dec 2018 03:22:48 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:43735 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726069AbeLKIWs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Dec 2018 03:22:48 -0500
Received: from [IPv6:2001:983:e9a7:1:5434:d88b:a352:4c5a] ([IPv6:2001:983:e9a7:1:5434:d88b:a352:4c5a])
        by smtp-cloud7.xs4all.net with ESMTPA
        id WdJOgEh3PQMWUWdJQg6CWX; Tue, 11 Dec 2018 09:22:41 +0100
Subject: Re: [v4l-utils PATCH 0/2] META_OUTPUT buffer type support for
 v4l2-compliance
To:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc:     yong.zhi@intel.com
References: <20181210212036.16643-1-sakari.ailus@linux.intel.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f5c40bc3-39fb-dfb4-5ab8-99385a2c96ba@xs4all.nl>
Date:   Tue, 11 Dec 2018 09:22:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181210212036.16643-1-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfGEQMQHfjfHqESRq8VkstelVASnAZbiCl8qPYpUGVHRuG5OQVKIKaYuWhgPi/CzkMH8vl+f+9ppb6ADg4Y0G3IWZyJAvkpKxF3oXt5/ctqEzgiUZ3sdS
 JaXzLGdvlsnkrzI2eJFNxtp3fAAh0egu9tjDPtqkwUl9aobq/ekg8C5/owLreuILi8Jzx58DufY16Dn6+o8D9LVjo8dDsRdyxC1l6h2M+WFchbonLKuFSPSS
 3JBC8BncuEZouAAA7fFkWN8wf/QSvUYnh6rgZp84DXYpNeeiWe7AzcRhjmPEJcHcqWaXafPl6T2IIrRqjsseIDzQfraa3H1KQzO0NTQbRSSnnUE9aOMQCCqe
 4f/sZgGx
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/10/18 10:20 PM, Sakari Ailus wrote:
> Hi all,
> 
> Here are the patches needed to support the META_OUTPUT queue type for
> v4l2-compliance. The patch that adds the support is preceded by the kernel
> header update --- the headers have been recently updated and there were
> no other changes.

Looks good for v4l2-compliance, but v4l2-ctl should also be updated.

I have alreaedy prepared v4l2-ctl-meta.cpp (should work automatically with
this patch series applied), but there are two other places where you need
to add META_OUTPUT support. Just add a third patch for v4l2-ctl.

Regards,

	Hans

> 
> Sakari Ailus (1):
>   Update uAPI headers from the kernel
> 
> Yong Zhi (1):
>   v4l2-compliance: Add support for metadata output
> 
>  include/linux/videodev2.h                   |  2 ++
>  utils/common/v4l-helpers.h                  | 14 +++++++++++++-
>  utils/common/v4l2-info.cpp                  |  4 ++++
>  utils/v4l2-compliance/v4l2-compliance.cpp   |  7 ++++---
>  utils/v4l2-compliance/v4l2-compliance.h     |  2 +-
>  utils/v4l2-compliance/v4l2-test-formats.cpp |  7 +++++++
>  6 files changed, 31 insertions(+), 5 deletions(-)
> 

