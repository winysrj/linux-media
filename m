Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8C1CC43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 11:13:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF17D20657
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 11:13:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729119AbfAOLNE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 06:13:04 -0500
Received: from shell.v3.sk ([90.176.6.54]:51821 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727883AbfAOLNE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 06:13:04 -0500
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 7E6C94DC77;
        Tue, 15 Jan 2019 12:13:00 +0100 (CET)
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id WMX-Y7O4RDT7; Tue, 15 Jan 2019 12:12:58 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id EC4214DC8E;
        Tue, 15 Jan 2019 12:12:57 +0100 (CET)
X-Virus-Scanned: amavisd-new at zimbra.v3.sk
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id JtMhgYmHvkWu; Tue, 15 Jan 2019 12:12:57 +0100 (CET)
Received: from belphegor (nat-pool-brq-t.redhat.com [213.175.37.10])
        by zimbra.v3.sk (Postfix) with ESMTPSA id 4C17B4DC77;
        Tue, 15 Jan 2019 12:12:57 +0100 (CET)
Message-ID: <23ea680af226991402a30dd02bacb1dce0c998f8.camel@v3.sk>
Subject: Re: [PATCH v4 0/5] ov7670 fixes
From:   Lubomir Rintel <lkundrak@v3.sk>
To:     Sakari Ailus <sakari.ailus@iki.fi>
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 15 Jan 2019 12:12:56 +0100
In-Reply-To: <20190115104011.irtgbp6iaw6cocgq@valkosipuli.retiisi.org.uk>
References: <20190115085448.1400135-1-lkundrak@v3.sk>
         <20190115104011.irtgbp6iaw6cocgq@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.3 (3.30.3-1.fc29) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, 2019-01-15 at 12:40 +0200, Sakari Ailus wrote:
> On Tue, Jan 15, 2019 at 09:54:43AM +0100, Lubomir Rintel wrote:
> > Hi,
> > 
> > here are the ov7670 patches originally from the "media: make Marvell camera
> > work on DT-based OLPC XO-1.75" updated to apply cleanly on top of
> > <git://linuxtv.org/sailus/media_tree.git> master as requested.
> > 
> > I've also added "ov7670: Remove useless use of a ret variable" with my Ack
> > slapped on it.
> 
> Hi Lubomir,
> 
> It seems the end result compiles but the intermedia patches do not. Could
> you resend, please? I'll replace the patches in my tree with a new version
> then...

Seems like the order got messed up. It should be sufficient to reorder
the patches like this:

pick f42ae764598a ov7670: Remove useless use of a ret variable
pick 5be2efe0e5bb media: ov7670: split register setting from set_fmt() logic
pick 38eed963866e media: ov7670: split register setting from set_framerate() logic
pick 97be3c31de46 media: ov7670: hook s_power onto v4l2 core
pick 56c292d92642 media: ov7670: control clock along with power

(With "git rebase -i 87680151c22eee5b3bb6361fb8d18d765a9d8aff")


> 
> Thanks.

Cheers,
Lubo

