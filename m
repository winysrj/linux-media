Return-Path: <SRS0=FbF1=QN=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A11A7C169C4
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 12:56:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 680D520B1F
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 12:56:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730282AbfBFM4o (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Feb 2019 07:56:44 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54764 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727585AbfBFM4o (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 6 Feb 2019 07:56:44 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 6D040634C7E;
        Wed,  6 Feb 2019 14:56:38 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1grMko-0000QQ-Ac; Wed, 06 Feb 2019 14:56:38 +0200
Date:   Wed, 6 Feb 2019 14:56:38 +0200
From:   "sakari.ailus@iki.fi" <sakari.ailus@iki.fi>
To:     Ken Sloat <KSloat@aampglobal.com>
Cc:     "eugen.hristev@microchip.com" <eugen.hristev@microchip.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "ludovic.desroches@microchip.com" <ludovic.desroches@microchip.com>,
        "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] media: atmel-isc: Update device tree binding
 documentation
Message-ID: <20190206125638.ynjpyqwctlmws5n3@valkosipuli.retiisi.org.uk>
References: <20190204141756.234563-1-ksloat@aampglobal.com>
 <20190204141756.234563-2-ksloat@aampglobal.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190204141756.234563-2-ksloat@aampglobal.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Feb 04, 2019 at 02:18:14PM +0000, Ken Sloat wrote:
> From: Ken Sloat <ksloat@aampglobal.com>
> 
> Update device tree binding documentation specifying how to
> enable BT656 with CRC decoding and specify properties for
> default parallel bus type.
> 
> Signed-off-by: Ken Sloat <ksloat@aampglobal.com>

The patch looks nice; I'll just wait for Rob's ack.

-- 
Sakari Ailus
