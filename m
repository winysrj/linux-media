Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35353 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750917AbdGNURL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 16:17:11 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFw076kkn_NS1K+nSHDLoajhviHUsnCOmJOpz5YajpEtFw@mail.gmail.com>
References: <20170714092540.1217397-1-arnd@arndb.de> <20170714092540.1217397-9-arnd@arndb.de>
 <CA+55aFw076kkn_NS1K+nSHDLoajhviHUsnCOmJOpz5YajpEtFw@mail.gmail.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 14 Jul 2017 22:17:10 +0200
Message-ID: <CAK8P3a0nZsqWtFX84FTHmm=aVFevrU5ZATnaLVSA39PZeG=6UQ@mail.gmail.com>
Subject: Re: [PATCH 08/14] Input: adxl34x - fix gcc-7 -Wint-in-bool-context warning
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tejun Heo <tj@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        IDE-ML <linux-ide@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 14, 2017 at 9:24 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Jul 14, 2017 at 2:25 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> FIFO_MODE is an macro expression with a '<<' operator, which
>> gcc points out could be misread as a '<':
>
> Yeah, no, NAK again.
>
> We don't make the code look worse just because gcc is being a f*cking
> moron about things.
>
> This warning is clearly pure garbage.
>

I looked at this one again and found a better approach, matching the
check that is done a few lines later. Unless you find something wrong
with that one, I'd resubmit it with the fixup below.

      Arnd

--- a/drivers/input/misc/adxl34x.c
+++ b/drivers/input/misc/adxl34x.c
@@ -789,21 +789,21 @@ struct adxl34x *adxl34x_probe(struct device *dev, int irq,
                __set_bit(pdata->ev_code_ff, input_dev->keybit);
        }

        if (pdata->ev_code_act_inactivity)
                __set_bit(pdata->ev_code_act_inactivity, input_dev->keybit);

        ac->int_mask |= ACTIVITY | INACTIVITY;

        if (pdata->watermark) {
                ac->int_mask |= WATERMARK;
-               if (FIFO_MODE(pdata->fifo_mode) == 0)
+               if (FIFO_MODE(pdata->fifo_mode) == FIFO_BYPASS)
                        ac->pdata.fifo_mode |= FIFO_STREAM;
        } else {
                ac->int_mask |= DATA_READY;
        }

        if (pdata->tap_axis_control & (TAP_X_EN | TAP_Y_EN | TAP_Z_EN))
                ac->int_mask |= SINGLE_TAP | DOUBLE_TAP;

        if (FIFO_MODE(pdata->fifo_mode) == FIFO_BYPASS)
                ac->fifo_delay = false;
