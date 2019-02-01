Return-Path: <SRS0=EV+/=QI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97202C282D8
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 10:55:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F96C21916
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 10:55:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729766AbfBAKzp (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Feb 2019 05:55:45 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40918 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727308AbfBAKzo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Feb 2019 05:55:44 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 28445634C7E;
        Fri,  1 Feb 2019 12:54:41 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1gpWT4-0002UA-52; Fri, 01 Feb 2019 12:54:42 +0200
Date:   Fri, 1 Feb 2019 12:54:42 +0200
From:   Sakari Ailus <sakari.ailus@iki.fi>
To:     hverkuil-cisco@xs4all.nl
Cc:     linux-media@vger.kernel.org
Subject: Re: [PATCH 0/8] Preparing for Y2038 support
Message-ID: <20190201105442.drbasavdw6eisq6i@valkosipuli.retiisi.org.uk>
References: <20190121133229.33893-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190121133229.33893-1-hverkuil-cisco@xs4all.nl>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

On Mon, Jan 21, 2019 at 02:32:21PM +0100, hverkuil-cisco@xs4all.nl wrote:
> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> 
> This patch series modifies v4l2-event, videobuf and various
> drivers that do not use vb2 or videobuf at all to store the
> event and buffer timestamps internally as a u64 (ktime_get_ns()).
> 
> Only when interfacing with the userspace API are these timestamps
> converted to a timespec or timeval.
> 
> The final patch drops the now unused v4l2_get_timestamp().
> 
> This simplifies the work needed to support Y2038-compatible
> timeval/timespec structures. It also ensures consistent
> behavior for all media drivers.

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
