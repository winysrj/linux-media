Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DC8CC169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 08:44:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E63982147C
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 08:44:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbfBHIoE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 03:44:04 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43946 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727238AbfBHIoE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Feb 2019 03:44:04 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 06D71634C7B;
        Fri,  8 Feb 2019 10:43:51 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1gs1lG-0000mp-Rf; Fri, 08 Feb 2019 10:43:50 +0200
Date:   Fri, 8 Feb 2019 10:43:50 +0200
From:   Sakari Ailus <sakari.ailus@iki.fi>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [PATCH 0/4] Move SoC camera to staging, depend on BROKEN
Message-ID: <20190208084350.g57evf5afipjztq3@valkosipuli.retiisi.org.uk>
References: <20190208084147.9973-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190208084147.9973-1-sakari.ailus@linux.intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Feb 08, 2019 at 10:41:43AM +0200, Sakari Ailus wrote:
> Hi all,
> 
> This series moves the SoC camera framework and the remaining drivers under
> the staging tree and makes them depend on BROKEN.
> 
> The files could be later removed.
> 
> Sakari Ailus (4):
>   soc_camera: Move to the staging tree
>   soc_camera: Move the imx074 under soc_camera directory
>   soc_camera: Move the mt9t031 under soc_camera directory
>   soc_camera: Depend on BROKEN

Btw. the series depends on two previous patches I've posted under subject
"[PATCH 0/2] Remove more SoC camera sensor drivers".

-- 
Sakari Ailus
