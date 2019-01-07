Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 276CBC43444
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 11:59:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBC49205C9
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 11:59:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726745AbfAGL7k (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 06:59:40 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52400 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726535AbfAGL7k (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Jan 2019 06:59:40 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id D488C634C7F;
        Mon,  7 Jan 2019 13:58:28 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1ggTY4-0002GO-8q; Mon, 07 Jan 2019 13:58:28 +0200
Date:   Mon, 7 Jan 2019 13:58:28 +0200
From:   Sakari Ailus <sakari.ailus@iki.fi>
To:     Luis Oliveira <luis.oliveira@synopsys.com>
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        joao.pinto@synopsys.com, festevam@gmail.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Todor Tomov <todor.tomov@linaro.org>
Subject: Re: [V3, 2/4] media: platform: dwc: Add DW MIPI DPHY Rx platform
Message-ID: <20190107115828.4tegmsbkoiqh7y5g@valkosipuli.retiisi.org.uk>
References: <1539953556-35762-1-git-send-email-lolivei@synopsys.com>
 <1539953556-35762-3-git-send-email-lolivei@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1539953556-35762-3-git-send-email-lolivei@synopsys.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Luis,

On Fri, Oct 19, 2018 at 02:52:24PM +0200, Luis Oliveira wrote:
> Add of Synopsys MIPI D-PHY in RX mode support.
> Separated in the implementation are platform dependent probing functions.
> 
> Signed-off-by: Luis Oliveira <lolivei@synopsys.com>

Maxime has a patchset adding D-PHY parameters to the PHY API. I think they
could be relevant for this one as well:

<URL:https://www.spinics.net/lists/linux-media/msg144214.html>

-- 
Kind regards,

Sakari Ailus
