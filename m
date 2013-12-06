Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55142 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757212Ab3LFKNv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Dec 2013 05:13:51 -0500
Received: by mail-ob0-f174.google.com with SMTP id wn1so513606obc.19
        for <linux-media@vger.kernel.org>; Fri, 06 Dec 2013 02:13:50 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 6 Dec 2013 11:13:50 +0100
Message-ID: <CA+2YH7ueF46YA2ZpOT80w3jTzmw0aFWhfshry2k_mrXAmW=MXA@mail.gmail.com>
Subject: omap3isp device tree support
From: Enrico <ebutera@users.berlios.de>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

i know there is some work going on for omap3isp device tree support,
but right now is it possible to enable it in some other way in a DT
kernel?

I've tried enabling it in board-generic.c (omap3_init_camera(...) with
proper platform data) but it hangs early at boot, do someone know if
it's possible and how to do it?

Thanks,

Enrico
