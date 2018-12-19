Return-Path: <SRS0=l98e=O4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC6FAC43387
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 10:48:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8E5120866
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 10:48:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728879AbeLSKsb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 19 Dec 2018 05:48:31 -0500
Received: from quechua.inka.de ([193.197.184.2]:50321 "EHLO mail.inka.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727586AbeLSKsb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Dec 2018 05:48:31 -0500
X-Greylist: delayed 1101 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Dec 2018 05:48:31 EST
Received: from localhost
        by mail.inka.de with local-rmail 
        id 1gZZ7B-0001Kk-9z; Wed, 19 Dec 2018 11:30:09 +0100
Received: by raven.inka.de (Postfix, from userid 1000)
        id 3A4F0120201; Wed, 19 Dec 2018 11:28:46 +0100 (CET)
Date:   Wed, 19 Dec 2018 11:28:46 +0100
From:   Josef Wolf <jw@raven.inka.de>
To:     linux-media@vger.kernel.org
Subject: SYS_DVBS vs. SYS_DVBS2
Message-ID: <20181219102846.GJ11337@raven.inka.de>
Mail-Followup-To: Josef Wolf <jw@raven.inka.de>,
        linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello experts,

hope I'm on the correct list for my question. Plese give me a pointer to the
correct list if I'm off-topic here.

I would like to know how to know whether for a specific program SYS_DVBS or
SYS_DVBS2 should be specified to the FE_SET_PROPERTY ioctl() call.

Is this somehow broadcasted in some PAT/PMT tables?

Or is it possible to simple always specify SYS_DVBS2 and the kernel will
manage the backwards compatibilities when a DVB-S transponder is specified in
the tuning parameters?

Thanks for the help,

-- 
Josef Wolf
jw@raven.inka.de
