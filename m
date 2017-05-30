Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:38457 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751024AbdE3HWK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 May 2017 03:22:10 -0400
Received: by mail-wm0-f51.google.com with SMTP id e127so86500435wmg.1
        for <linux-media@vger.kernel.org>; Tue, 30 May 2017 00:22:04 -0700 (PDT)
Subject: Re: [ANN] HDMI CEC Status Update
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Maling list - DRI developers
        <dri-devel@lists.freedesktop.org>,
        Archit Taneja <architt@codeaurora.org>
References: <8e277103-8bc5-34b2-411d-e396665df249@xs4all.nl>
From: Neil Armstrong <narmstrong@baylibre.com>
Message-ID: <cddc746c-16a2-21b8-f76d-82773cd1941b@baylibre.com>
Date: Tue, 30 May 2017 09:21:57 +0200
MIME-Version: 1.0
In-Reply-To: <8e277103-8bc5-34b2-411d-e396665df249@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 05/30/2017 08:53 AM, Hans Verkuil wrote:
> For those who are interested in HDMI CEC support I made a little status
> document that I intend to keep up to date:
> 
> https://hverkuil.home.xs4all.nl/cec-status.txt
> 
> My goal is to get CEC supported for any mainlined HDMI driver where the hardware
> supports CEC.
> 
> If anyone is working on a CEC driver that I don't know already about, just drop
> me an email so I can update the status.
> 
> I also started maintaining a list of DisplayPort to HDMI adapters that support
> CEC. If you have one that works and is not on the list, then please let me know.
> Seeing /dev/cecX is not enough, some adapters do not connect the CEC pin, so they
> won't be able to detect any other CEC devices. See the test instructions in the
> cec-status.txt file on how to make sure the adapter has a working CEC pin. I
> plan to do some more testing this week, so hopefully the list will expand.
> 
> Thanks!
> 
>     Hans

Following our discussion on IRC,
I'm working on a CEC driver for the standalone Amlogic CEC Controller that is able
to wake up the device from Suspend or Power Off mode by passing infos to the FW.

I initially planned to use the DW-HDMI CEC controller but I recently found out that
on the Amlogic Meson GX SoCs, the CEC line can be pinmuxed to either an Amlogic custom
controller or either to a Synopsys IP.

But it's connected to the Synopsys HDMI-RX controller... so my plan to use Russell's code
is now dead.

Anyway, I'll still need to have the CEC notifier suport for DW-HDMI, so I made a rebase/cleanup
of Russell's driver on 4.12-rc3 :
https://github.com/superna9999/linux/commits/amlogic/v4.12/rmk-dw-hdmi-cec
The rebase is aligned on dw-hdmi-i2s to use the bridge read/write ops.

Neil
