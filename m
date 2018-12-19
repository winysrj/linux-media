Return-Path: <SRS0=l98e=O4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AE9CC43387
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 11:22:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E851F2184A
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 11:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545218540;
	bh=Icpe60lvax+VRWhP+vqLFIqT6PRH+2iSgeVIoJGmT50=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=Fpk43jfy9K8DJu7BbHiRR4dQqwYSVoAwOBZ9DpE1kC9twOgAO+ix8IlmQ7/yBBmKV
	 +VUZUjn34kN9TDzvkRqhIv6n/ABfr865op1ZGq5OvPCFcklCYkqn/wRj462cgeZYvZ
	 7AWU143QMboFrpudg+lO2Kx3x1B5I5Ewm0rQSG0o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729220AbeLSLWT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 19 Dec 2018 06:22:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:39704 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbeLSLWT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Dec 2018 06:22:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=jRE60BwQ4PuS9OOhMvhvKIMMERksZcCKmLln2QlcJuE=; b=ZtqxlKpV9UFOVVcAc1hnimgU/m
        ImUERq5wVjWWjmEWCKehXZMM98XwCI74uFUohypUJNMBqTlz3iuLJ6pZ6hg0arV1lKRqs//mHYJjV
        Xz+T8WXmI3nPiHp9CoK7Cm+1/UtmBvDoTNC9Icb0TBw9odxy23unUcwvPiiQggElAOVsHRboTCFIq
        73Pm0i0bSoCIwQ7Qx0AdepabjUYf2T7A9Mrhu7pvoH7iSYOcI9D2Ur+MOQA0R1K8fPL5/AcV29mI7
        lYyZkAK7e4CWlmSOQSZeWT3ZHXy8hFxDSm96szs9OausU3ZZb/JaOxcuSGDqhWejYo2M7gvr1j4+v
        OlPIrJ4A==;
Received: from 177.205.112.95.dynamic.adsl.gvt.net.br ([177.205.112.95] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gZZvc-0001DK-KA; Wed, 19 Dec 2018 11:22:17 +0000
Date:   Wed, 19 Dec 2018 09:22:11 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Josef Wolf <jw@raven.inka.de>
Cc:     linux-media@vger.kernel.org
Subject: Re: SYS_DVBS vs. SYS_DVBS2
Message-ID: <20181219092211.16d67c61@coco.lan>
In-Reply-To: <20181219102846.GJ11337@raven.inka.de>
References: <20181219102846.GJ11337@raven.inka.de>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Wed, 19 Dec 2018 11:28:46 +0100
Josef Wolf <jw@raven.inka.de> escreveu:

> Hello experts,
> 
> hope I'm on the correct list for my question. Plese give me a pointer to the
> correct list if I'm off-topic here.
> 
> I would like to know how to know whether for a specific program SYS_DVBS or
> SYS_DVBS2 should be specified to the FE_SET_PROPERTY ioctl() call.

This is not specific to a program. It affects the hole transponder. Either
the transponder is DVB-S or DVB-S2.

> Is this somehow broadcasted in some PAT/PMT tables?

It is at the NAT tables. They contain all needed information to properly
tune into the transponders. There are different tables, depending if the
transponder is -S or -S2.

> Or is it possible to simple always specify SYS_DVBS2 and the kernel will
> manage the backwards compatibilities when a DVB-S transponder is specified in
> the tuning parameters?

The Kernel can't and shouldn't guess the tuning parameters. It depends
on userspace to parse the NAT tables and get it right.

If you use dvbv5-scan, for example, the logic at libdvbv5 will parse the
NAT tables for you and write the tuning parameters right for each
transponder, ensuring that every program inside that transponder will
receive the same tuning parameters.

Thanks,
Mauro
