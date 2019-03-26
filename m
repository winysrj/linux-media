Return-Path: <SRS0=7BPv=R5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87665C43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 13:26:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EA5720856
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 13:26:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731485AbfCZN0p (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Mar 2019 09:26:45 -0400
Received: from gofer.mess.org ([88.97.38.141]:39609 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726177AbfCZN0p (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Mar 2019 09:26:45 -0400
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 8E4D0603E8; Tue, 26 Mar 2019 13:26:43 +0000 (GMT)
Date:   Tue, 26 Mar 2019 13:26:43 +0000
From:   Sean Young <sean@mess.org>
To:     Samuel CHEMLA <chemla.samuel@gmail.com>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Gregor Jasny <gjasny@googlemail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [Bug report] dvbv5-zap crash dvb-tool ARMHF builds
Message-ID: <20190326132643.r3svehoa764xagje@gofer.mess.org>
References: <20190315223425.hiq3qcjhjnirsizh@gofer.mess.org>
 <20190317065242.137cb095@coco.lan>
 <20190319164507.7f95af89@coco.lan>
 <a1f296ba-3c27-ed2c-3912-4edbeeb21eba@googlemail.com>
 <20190321094127.ysurm4u26zugmnmv@gofer.mess.org>
 <20190321083044.621f1922@coco.lan>
 <35ba4e81-fc2a-87ed-8da7-43cc4543de51@googlemail.com>
 <CANJnhGfRtEwAony5Z4rFMPcu58aF2k0G+9NSkMKsq_PhfmSNqw@mail.gmail.com>
 <20190325140838.71f88eac@coco.lan>
 <CANJnhGc_qx32nm7yZheC2ioHOij8QELbnwyJkZ83G9uYTxqwtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANJnhGc_qx32nm7yZheC2ioHOij8QELbnwyJkZ83G9uYTxqwtA@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sam,

On Tue, Mar 26, 2019 at 08:35:44AM +0100, Samuel CHEMLA wrote:
> Hi,
> 
> 
> I am struggling with valgrind because it always complain with either :
>     ASan runtime does not come first in initial library list; you
> should either link runtime to your application or manually preload it
> with LD_PRELOAD
>     -> When I LD_PRELOAD, I'm getting a segfault, but I couldn't find
> any core dump
> 
> or, if I link statically libasan with -static-libasan:
>     Shadow memory range interleaves with an existing memory mapping.
> ASan cannot proceed correctly. ABORTING.
>     ASan shadow was supposed to be located in the
> [0x00007fff7000-0x10007fff7fff] range.
> 
> 
> I retested again on my raspberry zero W, and I confirm i cannot
> reproduce the hang.
> Your fix did work on that device.
> I am testing with same OS (raspbian with latest updates, same kernel),
> same configure options, same USB dongle... :-(
> The only differences are CPU architecture (armv6 vs armv7), memory
> constraints, and I was not using the same channels.conf, I'll fix that
> today and re-check

Earlier you said "random hangs are back". When this happens, does the whole
device become unresponsive or just dvbv5-zap? Since this issue is "back",
I wouldn't be surprised this is unrelated to the fixes in 1.12.7 and 1.16.4.

It would be useful to see the output from dmesg (best thing would be after
the issue occurs).

Also what dvb hardware are you using?

Thanks,

san

> 
> 
> Sam
> 
> On 25/03/2019 18:08, Mauro Carvalho Chehab wrote:
> 
> Em Mon, 25 Mar 2019 17:33:30 +0100
> Samuel CHEMLA <chemla.samuel@gmail.com> escreveu:
> 
> Hi guys,
> 
> I'm afraid I'm coming with sad news.
> I just tried both stable-1.12 and stable-1.16 on a raspberry pi 2, and
> random hangs are back (see https://bugs.launchpad.net/raspbian/+bug/1819650
> ).
> I previously test both branches on a raspberry zero and issues were gone
> (same raspbian version).
> There may be more memory issues somewhere...
> 
> Could you test it with valgrind?
> 
> Sam
> 
> Le jeu. 21 mars 2019 à 20:59, Gregor Jasny <gjasny@googlemail.com> a écrit :
> 
> Hello,
> 
> On 21.03.19 12:30, Mauro Carvalho Chehab wrote:
> 
> I went ahead and cherry-picked the relevant patches to -1.12, -1.14 and
> -1.16, and tested both dvbv5-zap and dvbv5-scan with all versions. So,
> 
> we can
> 
> release a new minor version for all those stable branches.
> 
> After the patches, on my tests, I didn't get any memory leaks or
> double-free issues.
> 
> I issues a new 1.12, 1.14, and 1.16 release.
> 
> Thanks,
> Gregor
> 
> 
> 
> Thanks,
> Mauro
