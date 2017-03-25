Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:38419 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751591AbdCYSOa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Mar 2017 14:14:30 -0400
Received: by mail-wm0-f46.google.com with SMTP id t189so13420624wmt.1
        for <linux-media@vger.kernel.org>; Sat, 25 Mar 2017 11:13:59 -0700 (PDT)
Date: Sat, 25 Mar 2017 19:13:52 +0100
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 12/12] [media] ddbridge: support STV0367-based cards
 and modules
Message-ID: <20170325191352.02f778fd@macbox>
In-Reply-To: <20170324182408.25996-13-d.scheller.oss@gmail.com>
References: <20170324182408.25996-1-d.scheller.oss@gmail.com>
        <20170324182408.25996-13-d.scheller.oss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Fri, 24 Mar 2017 19:24:08 +0100
schrieb Daniel Scheller <d.scheller.oss@gmail.com>:

> When boards with STV0367 are cold-started, there might be issues with
> the I2C gate, causing the TDA18212 detection/probe to fail. For these
> demods, a workaround is implemented to do the tuner probe again which
> will result in success if no other issue arises. Other demod/port
> types won't be retried.

That problem just hit me after cold-starting my server with such a card
installed,  and it turned out the way it's done in this patch doesn't
fully do it - scheduling a V3 series which does this properly
(unfortunately, this requires putting the I2C ping into ddbridge which
I'd rather have avoided). Sorry for the noise.

Daniel
