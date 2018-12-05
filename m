Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 522E4C04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 15:09:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2122F208E7
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 15:09:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2122F208E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=collabora.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbeLEPJW (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 10:09:22 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:49934 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbeLEPJV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2018 10:09:21 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id AF2BD26CDD9
Message-ID: <967929d49095bf376119ec6ad2f9aae494daeaec.camel@collabora.com>
Subject: Re: [PATCH v11 4/4] media: add Rockchip VPU JPEG encoder driver
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-rockchip@lists.infradead.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Miouyouyou <myy@miouyouyou.fr>
Date:   Wed, 05 Dec 2018 12:09:09 -0300
In-Reply-To: <07aed803-0e2f-c7c1-7f1c-752b82ffad7c@xs4all.nl>
References: <20181130173433.24185-1-ezequiel@collabora.com>
         <20181130173433.24185-5-ezequiel@collabora.com>
         <07aed803-0e2f-c7c1-7f1c-752b82ffad7c@xs4all.nl>
Organization: Collabora
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, 2018-12-05 at 16:01 +0100, Hans Verkuil wrote:
> Unless something unexpected happens, then v12 should be the final
> version and I'll make a pull request for it. Note that it will
> probably won't make 4.20, unless you manage to do it within the next
> hour :-)

Challenge accepted!

