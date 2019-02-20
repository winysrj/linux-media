Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83F5AC43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 09:54:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CF5F2089F
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 09:54:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfBTJyE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 04:54:04 -0500
Received: from smtp2.macqel.be ([109.135.2.61]:57366 "EHLO smtp2.macqel.be"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbfBTJyE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 04:54:04 -0500
X-Greylist: delayed 373 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Feb 2019 04:54:03 EST
Received: from localhost (localhost [127.0.0.1])
        by smtp2.macqel.be (Postfix) with ESMTP id 36B74130D5C
        for <linux-media@vger.kernel.org>; Wed, 20 Feb 2019 10:47:49 +0100 (CET)
X-Virus-Scanned: amavisd-new at macqel.be
Received: from smtp2.macqel.be ([127.0.0.1])
        by localhost (mail.macqel.be [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id t+OhS8JzCb35 for <linux-media@vger.kernel.org>;
        Wed, 20 Feb 2019 10:47:46 +0100 (CET)
Received: from frolo.macqel.be (frolo.macqel [10.1.40.73])
        by smtp2.macqel.be (Postfix) with ESMTP id 9C7D8130D13
        for <linux-media@vger.kernel.org>; Wed, 20 Feb 2019 10:47:45 +0100 (CET)
Received: by frolo.macqel.be (Postfix, from userid 1000)
        id 35A28DF009F; Wed, 20 Feb 2019 10:47:44 +0100 (CET)
Date:   Wed, 20 Feb 2019 10:47:45 +0100
From:   Philippe De Muyter <phdm@macq.eu>
To:     linux-media@vger.kernel.org
Subject: hint needed : how to integrate sublvds to mipi csi-2 converter
Message-ID: <20190220094744.GA8793@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello,

I am working on a driver for sony sensors that output sublvds, but that
must be connected to a processor expecting mipi csi-2.

We use a Lattice lif-md6000 fpga for that purpose, but unfortunately
the conversion is not transparent.  The fpga must be instructed to
know the bpp and line-length that were configured in the sensor.

I woul like to avoid the burden for the user to configure the fpga properly
when changing bpp or line-length in the sensor.  How should I implement
that.  Is there an example somewhere ?

TIA

Philippe

-- 
Philippe De Muyter +32 2 6101532 Macq SA rue de l'Aeronef 2 B-1140 Bruxelles

