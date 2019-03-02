Return-Path: <SRS0=8CHB=RF=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8878FC43381
	for <linux-media@archiver.kernel.org>; Sat,  2 Mar 2019 21:43:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23D7820836
	for <linux-media@archiver.kernel.org>; Sat,  2 Mar 2019 21:43:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="MSOH1AYa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbfCBVnR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 2 Mar 2019 16:43:17 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:33978 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726529AbfCBVnR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Mar 2019 16:43:17 -0500
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id CAE5F54E;
        Sat,  2 Mar 2019 22:43:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1551562995;
        bh=1k55v4xuO5w3mqyAUbEEj/9On7TPFCInY9CTq+Lw8yk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MSOH1AYaJovJdaMTBUhbJ4MsxVy3Lmm9aGegNzWe5DTe5fN7CVtVQeopvbgyysYcC
         stHYhRkhmrMAuFbtiNI4OYzp/H7nYd30XUfE7bzzc3a1fZ2N2pjl8FbGBfla4ijrkk
         MyXCSGC+GFPdlxVUgozUkDheNmS86fl+67CjOfFs=
Date:   Sat, 2 Mar 2019 23:43:08 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Shaobo He <shaobo@cs.utah.edu>
Cc:     linux-media@vger.kernel.org
Subject: Re: Question about drivers/media/usb/uvc/uvc_v4l2.c
Message-ID: <20190302214308.GI4682@pendragon.ideasonboard.com>
References: <8479deae-dedb-b7d2-58b7-8ff91f265eab@cs.utah.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8479deae-dedb-b7d2-58b7-8ff91f265eab@cs.utah.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Shaobo,

On Sat, Mar 02, 2019 at 01:22:49PM -0700, Shaobo He wrote:
> Hello everyone,
> 
> This is Shaobo from Utah again. I've been bugging the mailing list with my 
> patches. I have a quick question about a function in 
> `drivers/media/usb/uvc/uvc_v4l2.c`. In `uvc_v4l2_try_format`, can 
> `stream->nformats` be 0? I saw that in other files, this field could be zero 
> which is considered as error cases. I was wondering if it's true for this 
> function, too.

The uvc_parse_streaming() function should answer this question :-)

-- 
Regards,

Laurent Pinchart
