Return-Path: <SRS0=SnUM=RC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB9AFC43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 15:13:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF329213A2
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 15:13:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729202AbfB0PNe convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Feb 2019 10:13:34 -0500
Received: from kozue.soulik.info ([108.61.200.231]:55196 "EHLO
        kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727636AbfB0PNe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Feb 2019 10:13:34 -0500
Received: from [192.168.0.49] (unknown [192.168.0.49])
        by kozue.soulik.info (Postfix) with ESMTPSA id 9E78C100D3B;
        Thu, 28 Feb 2019 00:13:46 +0900 (JST)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
        charset=utf-8
From:   Ayaka <ayaka@soulik.info>
Mime-Version: 1.0 (1.0)
Subject: media: rockchip: the memory layout of multiplanes buffer for DMA address
Message-Id: <C5689C9D-5F00-41E2-B24F-5BC8D9BA88AF@soulik.info>
Date:   Wed, 27 Feb 2019 23:13:26 +0800
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, nicolas@ndufresne.ca, myy@miouyouyou.fr,
        ezequiel@collabora.com, tfiga@chromium.org
X-Mailer: iPad Mail (16A404)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello all

I am writing the v4l2 decoder driver for rockchip. Although I hear the suggest from the Hans before, it is ok for decoder to use single plane buffer format, but I still decide to the multi planes format.

There is not a register for vdpau1 and vdpau2 setting the chroma starting address in both pixel image output(it has one only applied for jpeg) and reference. And the second plane should follow the first plane. It sounds pretty fix for the single plane, but the single plane can’t describe offset of the second plane, which is not the result of bytes per line multiples the height.

There are two different memory access steps in those rockchip device, 16bytes for vdpau1 and vdpau2, 64bytes for rkvdec and 128bytes for rkvdec with a high resolution. Although those access steps can be adjusted by the memory cache registers. So it is hard to describe the pixel format with the single plane formats or userspace would need to do more work.

Currently, I use the dma-contig allocator in my driver, it would allocate the second plane first, which results that the second plane has a lower address than first plane, which device would request the second plane follows the first plane. I increase the sizeimage of the first plane to solve this problem now and let device can continue to run, but I need a way to solve this problem.

Is there a way to control how does dma-contig allocate a buffer? I have not figured out the internal flow of the videobuf2. I know how to allocate two planes in different memory region which the s5p-mfc does with two alloc_devs, but that is not what I want.

Last time in FOSDEM, kwiboo and I talk some problems of the request API and stateless decoder, I say the a method to describe a buffer with many offsets as the buffer meta data would solve the most of  problems we talked, but I have no idea on how to implement it. And I think a buffer meta describing a buffer with many offsets would solve this problem as well.

Sent from my iPad
