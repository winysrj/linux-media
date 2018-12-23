Return-Path: <SRS0=d3EJ=PA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E3C9C43387
	for <linux-media@archiver.kernel.org>; Sun, 23 Dec 2018 16:22:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06F542075B
	for <linux-media@archiver.kernel.org>; Sun, 23 Dec 2018 16:22:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729679AbeLWQWc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 23 Dec 2018 11:22:32 -0500
Received: from muru.com ([72.249.23.125]:59170 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729470AbeLWQWc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Dec 2018 11:22:32 -0500
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id D55FE8119;
        Sun, 23 Dec 2018 16:22:35 +0000 (UTC)
Date:   Sun, 23 Dec 2018 08:22:28 -0800
From:   Tony Lindgren <tony@atomide.com>
To:     Adam Ford <aford173@gmail.com>
Cc:     Sebastian Reichel <sre@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@ucw.cz>,
        "open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
        linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/14] Add support for FM radio in hcill and kill TI_ST
Message-ID: <20181223162228.GN6707@atomide.com>
References: <20181221011752.25627-1-sre@kernel.org>
 <20181221180205.GH6707@atomide.com>
 <CAHCN7xK-qnRp_s9MQ2-doGqPrfC_OOgciOKHYTC9L5eiTwzT9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHCN7xK-qnRp_s9MQ2-doGqPrfC_OOgciOKHYTC9L5eiTwzT9A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

* Adam Ford <aford173@gmail.com> [181222 20:36]:
> As much as I'd like to see the ti-st kim stuff go, I am not able to
> load the Bluetooth on the Torpedo board (wl1283).  The hooks on a
> different, wl18xx and 127x board work fine.  I am not sure if there is
> anything different about the wl1283, but I don't have any other boards
> other than the Logic PD Torpedo kit.  Do you have any wl1283 boards to
> test?  I'd like to see this BT timeout stuff resolved before we dump
> the ti-st kim stuff, otherwise, I'll forever be porting drivers.  :-(

Sebastian and I both tested this with droid 4, which has wl1283. So
it's probably some missing GPIO/regulator/pinconf stuff that the
pdata-quirks.c does for you.

Maybe try adding back also the pdata-quirks.c code and see if that
helps?

Regards,

Tony
