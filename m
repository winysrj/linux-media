Return-Path: <SRS0=hjs2=Q5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3982AC43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 11:42:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3942206BB
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 11:42:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="HVXNuSvu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbfBVLm3 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Feb 2019 06:42:29 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:33988 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfBVLm3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Feb 2019 06:42:29 -0500
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id D92562D2;
        Fri, 22 Feb 2019 12:42:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550835747;
        bh=TAIdM3TRYAvQkPVljea4X6c4W7ZE1Ddh07mdrme8fQU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HVXNuSvuEAM5GbsTdjI1i3xtVwihGVXhRVW9l0wLL998SiuFAMP/bbGGk91EECrFh
         rJURTWEkQY8oE7IHjPtFx1H6LQIN9y/ES5OuBYuxcQs+u83i3Of0y2kXuFLbzbo2UB
         9qVAvhDcr1Too2eTuEkhGjXtHvUlqv4UaQ9L9ORQ=
Date:   Fri, 22 Feb 2019 13:42:22 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Shaobo He <shaobo@cs.utah.edu>
Cc:     linux-media@vger.kernel.org, mchehab@kernel.org,
        hverkuil-cisco@xs4all.nl, sakari.ailus@linux.intel.com
Subject: Re: Never checked NULL pointer in
 drivers/media/v4l2-core/videobuf-core.c
Message-ID: <20190222114222.GQ3522@pendragon.ideasonboard.com>
References: <4cf23e03-bcb5-8d29-afc9-4ab532dfa477@cs.utah.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4cf23e03-bcb5-8d29-afc9-4ab532dfa477@cs.utah.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Shaodo,

On Thu, Feb 21, 2019 at 05:47:52PM -0700, Shaobo He wrote:
> Hello everyone,
> 
> I found that macro `CALLPTR` in drivers/media/v4l2-core/videobuf-core.c can 
> evaluate to NULL yet all its usages (__videobuf_copy_to_user, 
> __videobuf_copy_stream) are never NULL checked. I doubt but am not completely 
> sure that use cases of the CALLPTR macro can accept NULL pointers. Please let me 
> know if it makes sense or not.

videobuf (not to be confused with videobuf2) is old deprecated code, and
full of known issues that we will not attempt to solve. It should be
dropped, but we still have 8 drivers relying on it. Hans, do you think
we will ever move forward with this ? Could some of the drivers be
dropped ?

-- 
Regards,

Laurent Pinchart
