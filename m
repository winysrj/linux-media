Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 499ADC43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 19:07:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21F39217F5
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 19:07:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbfBRTHq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 14:07:46 -0500
Received: from gofer.mess.org ([88.97.38.141]:47543 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726380AbfBRTHq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 14:07:46 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id ECCBA60340; Mon, 18 Feb 2019 19:07:43 +0000 (GMT)
Date:   Mon, 18 Feb 2019 19:07:43 +0000
From:   Sean Young <sean@mess.org>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR v5.1] RC fixes
Message-ID: <20190218190743.bw5xyfjgg6vcnq5i@gofer.mess.org>
References: <20190208221521.77vwne4szl4f4qp3@gofer.mess.org>
 <20190218142244.0021a263@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190218142244.0021a263@coco.lan>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Feb 18, 2019 at 02:22:52PM -0300, Mauro Carvalho Chehab wrote:
> Em Fri, 8 Feb 2019 22:15:22 +0000
> Sean Young <sean@mess.org> escreveu:
> 
> > Hi Mauro,
> > 
> > Here are the last RC fixes for 5.1.
> > 
> > Thanks,
> > 
> > Sean
> > 
> > The following changes since commit 6fd369dd1cb65a032f1ab9227033ecb7b759656d:
> > 
> >   media: vimc: fill in bus_info in media_device_info (2019-02-07 12:38:59 -0500)
> > 
> > are available in the Git repository at:
> > 
> >   git://linuxtv.org/syoung/media_tree.git for-v5.1b
> > 
> > for you to fetch changes up to a82c3d00eaee0b18d3fe8e62bdde7e349d72ec97:
> > 
> >   media: smipcie: add universal ir capability (2019-02-08 21:56:54 +0000)
> > 
> > ----------------------------------------------------------------
> > Matthias Reichl (1):
> >       media: rc: ir-rc6-decoder: enable toggle bit for Zotac remotes
> > 
> > Patrick Lerda (2):
> >       media: rc: rcmm decoder and encoder
> 
> It is now producing a lot documentation warnings:
> 
> $ make SPHINXOPTS="-j5" DOCBOOKS="" SPHINXDIRS=media SPHINX_CONF="conf.py" htmldocs
> Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-proto-rcmm12 (if the link has no caption the label must precede a section header)      
> Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-proto-rcmm24 (if the link has no caption the label must precede a section header)
> Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-proto-rcmm32 (if the link has no caption the label must precede a section header)
> Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-proto-rcmm12 (if the link has no caption the label must precede a section header)
> Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-proto-rcmm24 (if the link has no caption the label must precede a section header)
> Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-proto-rcmm32 (if the link has no caption the label must precede a section header)
> 
> Please fix.

Sorry for missing that. I'll post a v2 of the pull request shortly.

Thanks,
Sean
