Return-Path: <SRS0=d3EJ=PA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FCFAC43387
	for <linux-media@archiver.kernel.org>; Sun, 23 Dec 2018 21:40:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 175622176F
	for <linux-media@archiver.kernel.org>; Sun, 23 Dec 2018 21:40:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725856AbeLWVkL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 23 Dec 2018 16:40:11 -0500
Received: from quechua.inka.de ([193.197.184.2]:44621 "EHLO mail.inka.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbeLWVkL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Dec 2018 16:40:11 -0500
Received: from localhost
        by mail.inka.de with local-rmail 
        id 1gbBTl-0006oC-QP; Sun, 23 Dec 2018 22:40:09 +0100
Received: by raven.inka.de (Postfix, from userid 1000)
        id 5E69C12020F; Sun, 23 Dec 2018 22:32:02 +0100 (CET)
Date:   Sun, 23 Dec 2018 22:32:02 +0100
From:   Josef Wolf <jw@raven.inka.de>
To:     linux-media@vger.kernel.org
Subject: diseqc slave reply?
Message-ID: <20181223213202.GL11337@raven.inka.de>
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

Hello all,

When I try bidirectional diseqc communicastion, when calling
FE_DISEQC_RECV_SLAVE_REPLY like this:

    struct dvb_diseqc_slave_reply reply;

    ioctl(fefd,FE_DISEQC_RECV_SLAVE_REPLY,&reply)

I get the error:

    failed: Operation not supported

This is with an Max-S8 made by Digital Devices.

Is this limitation by hardware, by driver or by dvb subsystem?

Or am I missing something substantial?

Thanks!

-- 
Josef Wolf
jw@raven.inka.de
