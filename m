Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62FD6C282C3
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 16:47:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B1D521726
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 16:47:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729410AbfAVQrK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 11:47:10 -0500
Received: from gofer.mess.org ([88.97.38.141]:56767 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729396AbfAVQrK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 11:47:10 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id DE8CF60352; Tue, 22 Jan 2019 16:47:08 +0000 (GMT)
Date:   Tue, 22 Jan 2019 16:47:08 +0000
From:   Sean Young <sean@mess.org>
To:     shuah <shuah@kernel.org>
Cc:     Patrick Lerda <patrick9876@free.fr>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] selftests: Use lirc.h from kernel tree, not from
 system
Message-ID: <20190122164708.5wdot3heue5x7vyj@gofer.mess.org>
References: <cover.1547738495.git.sean@mess.org>
 <dad2fab452d98aaadea210807f9e0545a7814b32.1547738495.git.sean@mess.org>
 <46b12148-23d5-94a6-3c63-606636300bf4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46b12148-23d5-94a6-3c63-606636300bf4@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Jan 22, 2019 at 08:51:01AM -0700, shuah wrote:
> On 1/17/19 8:29 AM, Sean Young wrote:
> > When the system lirc.h is older than v4.16, you will get errors like:
> > 
> > ir_loopback.c:32:16: error: field ‘proto’ has incomplete type
> >    enum rc_proto proto;
> > 
> > Cc: Shuah Khan <shuah@kernel.org>
> > Signed-off-by: Sean Young <sean@mess.org>
> > ---
> >   tools/testing/selftests/ir/Makefile | 2 ++
> >   1 file changed, 2 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/ir/Makefile b/tools/testing/selftests/ir/Makefile
> > index f4ba8eb84b95..ad06489c22a5 100644
> > --- a/tools/testing/selftests/ir/Makefile
> > +++ b/tools/testing/selftests/ir/Makefile
> > @@ -1,5 +1,7 @@
> >   # SPDX-License-Identifier: GPL-2.0
> >   TEST_PROGS := ir_loopback.sh
> >   TEST_GEN_PROGS_EXTENDED := ir_loopback
> > +APIDIR := ../../../include/uapi
> > +CFLAGS += -Wall -O2 -I$(APIDIR)
> >   include ../lib.mk
> > 
> 
> Thanks for the fix. I can take this through kselftest tree if
> there are no dependencies on any media patches. It looks that
> way, just confirming. It will be very likely for rc5.

There are no dependencies on media patches. Thank you very much!


Sean
