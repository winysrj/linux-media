Return-Path: <SRS0=AYlV=OX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06538C67839
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 12:30:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE11721104
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 12:30:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE11721104
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=mess.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731178AbeLNMak (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 14 Dec 2018 07:30:40 -0500
Received: from gofer.mess.org ([88.97.38.141]:41709 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731187AbeLNMaj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Dec 2018 07:30:39 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 4172860157; Fri, 14 Dec 2018 12:30:37 +0000 (GMT)
Date:   Fri, 14 Dec 2018 12:30:37 +0000
From:   Sean Young <sean@mess.org>
To:     Patrick Lerda <patrick9876@free.fr>
Cc:     linux-media@vger.kernel.org
Subject: Re: [PATCH v5 1/1] media: rc: rcmm decoder
Message-ID: <20181214123036.qycl3wrzyigqiott@gofer.mess.org>
References: <c44581638d2525bc383a75413259f708@free.fr>
 <cover.1544231670.git.patrick9876@free.fr>
 <20181205002933.20870-1-patrick9876@free.fr>
 <20181205002933.20870-2-patrick9876@free.fr>
 <3a057647b40d9246aca4f64ee771594c32922974.1544175403.git.patrick9876@free.fr>
 <20181207101231.of7c3j67pcz7cetp@gofer.mess.org>
 <28f4bc366ebdb585a5b74a25dd1ee8a525e99884.1544231670.git.patrick9876@free.fr>
 <2e368afe-da25-0ab9-c076-6f8831bd26ec@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2e368afe-da25-0ab9-c076-6f8831bd26ec@free.fr>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Patrick,

On Thu, Dec 13, 2018 at 11:41:01PM +0100, Patrick Lerda wrote:
> Hi Sean,
> 
>    Is the v5 OK?

Sorry I'm currently at the Linux Foundation Hyperledger event in Basel, I'll
be back next week and then I'll do a proper review. Looks good at first
glance.

Thanks

Sean
