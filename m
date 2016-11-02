Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33818 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756776AbcKBVAS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2016 17:00:18 -0400
Received: by mail-oi0-f67.google.com with SMTP id 62so2987029oif.1
        for <linux-media@vger.kernel.org>; Wed, 02 Nov 2016 14:00:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1478108285-12046-2-git-send-email-sean@mess.org>
References: <1478108285-12046-1-git-send-email-sean@mess.org> <1478108285-12046-2-git-send-email-sean@mess.org>
From: VDR User <user.vdr@gmail.com>
Date: Wed, 2 Nov 2016 14:00:16 -0700
Message-ID: <CAA7C2qiQyn8eAnoJ6Caq2EwO0+4oqga2FoPmFdBrYxgooQz6=g@mail.gmail.com>
Subject: Re: [PATCH 2/2] [media] lirc: remove lirc_serial driver
To: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        "mailing list: linux-media" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> serial_ir driver in rc-core

Which kernel did this happen in? I don't see a sign of it in 4.8.5 and
I want to make sure that homebrew serial devices still work with lirc
after this. Are you sure the serial_ir driver you refer to isn't about
a usb-based serial ir?

Thanks for clarity.
