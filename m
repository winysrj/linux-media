Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:51824 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbaDEEeu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Apr 2014 00:34:50 -0400
Received: by mail-pd0-f177.google.com with SMTP id y10so4161523pdj.22
        for <linux-media@vger.kernel.org>; Fri, 04 Apr 2014 21:34:49 -0700 (PDT)
Message-ID: <533F87E5.2070403@gmail.com>
Date: Sat, 05 Apr 2014 13:34:45 +0900
From: Akihiro TSUKADA <tskd08@gmail.com>
MIME-Version: 1.0
To: Guest <info@are.ma>
CC: knightrider@are.ma, mchehab@redhat.com, linux-media@vger.kernel.org
Subject: Re: [PATCH] Full DVB driver package for Earthsoft PT3 (ISDB-S/T)
 cards
References: <1396424697-18206-1-git-send-email-guest@puma.are.ma>
In-Reply-To: <1396424697-18206-1-git-send-email-guest@puma.are.ma>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bud,

It seems that the tuner modules use fe->ops.write()
for i2c communications, which is set by parent module.
but I'm afraid fe->ops.write() is not for the purpose.
Shouldn't they use i2c_adapters passed from _attach() etc. instead?

regards,
akihiro

