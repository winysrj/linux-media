Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:35626 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751843AbeCXLAs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Mar 2018 07:00:48 -0400
MIME-Version: 1.0
In-Reply-To: <20180323125915.13986-1-hverkuil@xs4all.nl>
References: <20180323125915.13986-1-hverkuil@xs4all.nl>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Sat, 24 Mar 2018 12:00:26 +0100
Message-ID: <CAFBinCA-x=4J_a_+oJX7fxhXO0qP=apEPFesATP=UNsH91qiCw@mail.gmail.com>
Subject: Re: [PATCHv2 0/3] dw-hdmi: add property to disable CEC
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Neil Armstrong <narmstrong@baylibre.com>
Cc: linux-media <linux-media@vger.kernel.org>,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans, Hi Neil,

(apologies in advance if any of this is wrong, I don't have any CEC
capable TV so I can't test it)

On Fri, Mar 23, 2018 at 1:59 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Some boards (amlogic) have two CEC controllers: the DesignWare controller
> and their own CEC controller (meson ao-cec).
as far as I understand the Amlogic Meson SoCs have two domains:
- AO (always-on, powered even in suspend mode) where meson-ao-cec can
wake up the system from suspend
- EE (everything else, not powered during suspend) where dw-hdmi-cec lives

this far everything is OK

> Since the CEC line is not hooked up to the DW controller we need a way
> to disable that controller. This patch series adds the cec-disable
> property for that purpose.
drivers/pinctrl/meson/pinctrl-meson-gxbb.c has ao_cec_pins and
ee_cec_pins, both use GPIOAO_12
drivers/pinctrl/meson/pinctrl-meson-gxl.c has ao_cec_pins and
ee_cec_pins, both use GPIOAO_8

@Neil: do you know if the CEC signal routing is:
ao_cec_pins -> meson-ao-cec
ee_cec_pins -> dw-hdmi-cec

I'm curious because if both CEC controllers can be used then it might
be worth mentioning this in the cover-letter and patch description


Regards
Martin
