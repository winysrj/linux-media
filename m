Return-Path: <SRS0=l98e=O4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C609C43387
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 12:20:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A873217D6
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 12:20:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbeLSMUN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 19 Dec 2018 07:20:13 -0500
Received: from quechua.inka.de ([193.197.184.2]:51176 "EHLO mail.inka.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727993AbeLSMUN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Dec 2018 07:20:13 -0500
Received: from localhost
        by mail.inka.de with local-rmail 
        id 1gZapg-0003tF-4I; Wed, 19 Dec 2018 13:20:12 +0100
Received: by raven.inka.de (Postfix, from userid 1000)
        id CCD1A120201; Wed, 19 Dec 2018 13:16:49 +0100 (CET)
Date:   Wed, 19 Dec 2018 13:16:49 +0100
From:   Josef Wolf <jw@raven.inka.de>
To:     linux-media@vger.kernel.org
Subject: Re: SYS_DVBS vs. SYS_DVBS2
Message-ID: <20181219121649.GK11337@raven.inka.de>
Mail-Followup-To: Josef Wolf <jw@raven.inka.de>,
        linux-media@vger.kernel.org
References: <20181219102846.GJ11337@raven.inka.de>
 <20181219092211.16d67c61@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181219092211.16d67c61@coco.lan>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Thanks for your response, Mauro!

On Wed, Dec 19, 2018 at 09:22:11AM -0200, Mauro Carvalho Chehab wrote:
> Em Wed, 19 Dec 2018 11:28:46 +0100
> Josef Wolf <jw@raven.inka.de> escreveu:

> > I would like to know how to know whether for a specific program SYS_DVBS or
> > SYS_DVBS2 should be specified to the FE_SET_PROPERTY ioctl() call.
> 
> This is not specific to a program. It affects the hole transponder. Either
> the transponder is DVB-S or DVB-S2.

Yes, I'm aware of it. In my question I meant: when I want to tune to some
program, I need to set the SYS_DVBx property in addition to the other tuning
parameters (like frequency, polarization, FEC etc/pp)

> > Is this somehow broadcasted in some PAT/PMT tables?
> 
> It is at the NAT tables. They contain all needed information to properly
> tune into the transponders. There are different tables, depending if the
> transponder is -S or -S2.

OK.

> > Or is it possible to simple always specify SYS_DVBS2 and the kernel will
> > manage the backwards compatibilities when a DVB-S transponder is specified in
> > the tuning parameters?
> 
> The Kernel can't and shouldn't guess the tuning parameters. It depends
> on userspace to parse the NAT tables and get it right.

It is pretty much obvois to me that the kernel can't guess tuning parameters
like diseqc-sequence, polarity, frequency and symrate. This is because the
kernel needs those parameters to get a signal at all.

But, on the other side, there are lots of parameters that the kernel (or
hardware?) _can_ guess: INVERSION_AUTO, FEC_AUTO, QAM_AUTO just to name some.

So what' so special about SYS_DVBS/SYS_DVBS2 that it has to be handled
differently from those other parameters?

-- 
Josef Wolf
jw@raven.inka.de
