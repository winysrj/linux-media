Return-Path: <SRS0=7C2H=RS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11CCCC43381
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 22:34:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC71321019
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 22:34:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbfCOWe2 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Mar 2019 18:34:28 -0400
Received: from gofer.mess.org ([88.97.38.141]:34219 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726766AbfCOWe1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Mar 2019 18:34:27 -0400
Received: by gofer.mess.org (Postfix, from userid 1000)
        id DA6ED601BD; Fri, 15 Mar 2019 22:34:25 +0000 (GMT)
Date:   Fri, 15 Mar 2019 22:34:25 +0000
From:   Sean Young <sean@mess.org>
To:     Gregor Jasny <gjasny@googlemail.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        CHEMLA Samuel <chemla.samuel@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [Bug report] dvbv5-zap crash dvb-tool ARMHF builds
Message-ID: <20190315223425.hiq3qcjhjnirsizh@gofer.mess.org>
References: <f4b69417-06c3-f9ab-2973-ae23d76088b8@gmail.com>
 <29bad771-843c-1dee-906c-6e9475aed7d8@gmail.com>
 <d291e164-993f-232a-f01b-0f8c17087004@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d291e164-993f-232a-f01b-0f8c17087004@googlemail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

On Tue, Mar 12, 2019 at 04:07:23PM +0100, Gregor Jasny wrote:
> Hello Mauro,
> 
> below you find a bug report about an use-after-free in dvbv5-zap.
> 
> On 12.03.19 13:37, CHEMLA Samuel wrote:
> > please find a bug report that seems to concern ARMHF builds of dvbv5-zap
> > (dvb-tool package) : https://bugs.launchpad.net/raspbian/+bug/1819650
> > I filed it against raspbian because I thought it was a raspbian problem,
> > but don't think they re-build their own package, but use debian ones
> > instead...
> 

So I can reproduce the issue with v4l-utils 1.12.3 but not with current
v4l-utils (or dvbv5-zap). It looks exactly like the issue fixed in
commit 6e21f6f34c1d7c3a7a059062e1ddd9705c984e2c (but I did not cherry-pick
and test that on top of 1.12.3 to test that theory).


Sean
