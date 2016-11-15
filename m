Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:34979 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752875AbcKOXYM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Nov 2016 18:24:12 -0500
MIME-Version: 1.0
In-Reply-To: <1479136968-24477-3-git-send-email-hverkuil@xs4all.nl>
References: <1479136968-24477-1-git-send-email-hverkuil@xs4all.nl> <1479136968-24477-3-git-send-email-hverkuil@xs4all.nl>
From: Pierre-Hugues Husson <phh@phh.me>
Date: Wed, 16 Nov 2016 00:23:50 +0100
Message-ID: <CAJ-oXjS-VVkBuYh0inTGAvJbsKzvEqKYrgoSeG6UBQtW_1BEyQ@mail.gmail.com>
Subject: Re: [RFCv2 PATCH 2/5] drm/bridge: dw_hdmi: remove CEC engine register definitions
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-fbdev@vger.kernel.org,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,


2016-11-14 16:22 GMT+01:00 Hans Verkuil <hverkuil@xs4all.nl>:
> From: Russell King <rmk+kernel@arm.linux.org.uk>
>
> We don't need the CEC engine register definitions, so let's remove them.
>
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> ---
>  drivers/gpu/drm/bridge/dw-hdmi.h | 45 ----------------------------------------
>  1 file changed, 45 deletions(-)
>
> diff --git a/drivers/gpu/drm/bridge/dw-hdmi.h b/drivers/gpu/drm/bridge/dw-hdmi.h
> index fc9a560..26d6845 100644
> --- a/drivers/gpu/drm/bridge/dw-hdmi.h
> +++ b/drivers/gpu/drm/bridge/dw-hdmi.h
> @@ -478,51 +478,6 @@
>  #define HDMI_A_PRESETUP                         0x501A
>  #define HDMI_A_SRM_BASE                         0x5020
>
> -/* CEC Engine Registers */
> -#define HDMI_CEC_CTRL                           0x7D00
> -#define HDMI_CEC_STAT                           0x7D01
> -#define HDMI_CEC_MASK                           0x7D02
I don't know if this is relevant for a submission, but the build stops
working here because of a missing definition HDMI_CEC_MASK
Perhaps this should be inverted with 3/5 to make bissecting easier?
I was trying to bissect a kernel panic, and I had to fix this by hand
> -#define HDMI_CEC_POLARITY                       0x7D03
> -#define HDMI_CEC_INT                            0x7D04
> -#define HDMI_CEC_ADDR_L                         0x7D05
> -#define HDMI_CEC_ADDR_H                         0x7D06
> -#define HDMI_CEC_TX_CNT                         0x7D07
> -#define HDMI_CEC_RX_CNT                         0x7D08
> -#define HDMI_CEC_TX_DATA0                       0x7D10
> -#define HDMI_CEC_TX_DATA1                       0x7D11
> -#define HDMI_CEC_TX_DATA2                       0x7D12
> -#define HDMI_CEC_TX_DATA3                       0x7D13
> -#define HDMI_CEC_TX_DATA4                       0x7D14
> -#define HDMI_CEC_TX_DATA5                       0x7D15
> -#define HDMI_CEC_TX_DATA6                       0x7D16
> -#define HDMI_CEC_TX_DATA7                       0x7D17
> -#define HDMI_CEC_TX_DATA8                       0x7D18
> -#define HDMI_CEC_TX_DATA9                       0x7D19
> -#define HDMI_CEC_TX_DATA10                      0x7D1a
> -#define HDMI_CEC_TX_DATA11                      0x7D1b
> -#define HDMI_CEC_TX_DATA12                      0x7D1c
> -#define HDMI_CEC_TX_DATA13                      0x7D1d
> -#define HDMI_CEC_TX_DATA14                      0x7D1e
> -#define HDMI_CEC_TX_DATA15                      0x7D1f
> -#define HDMI_CEC_RX_DATA0                       0x7D20
> -#define HDMI_CEC_RX_DATA1                       0x7D21
> -#define HDMI_CEC_RX_DATA2                       0x7D22
> -#define HDMI_CEC_RX_DATA3                       0x7D23
> -#define HDMI_CEC_RX_DATA4                       0x7D24
> -#define HDMI_CEC_RX_DATA5                       0x7D25
> -#define HDMI_CEC_RX_DATA6                       0x7D26
> -#define HDMI_CEC_RX_DATA7                       0x7D27
> -#define HDMI_CEC_RX_DATA8                       0x7D28
> -#define HDMI_CEC_RX_DATA9                       0x7D29
> -#define HDMI_CEC_RX_DATA10                      0x7D2a
> -#define HDMI_CEC_RX_DATA11                      0x7D2b
> -#define HDMI_CEC_RX_DATA12                      0x7D2c
> -#define HDMI_CEC_RX_DATA13                      0x7D2d
> -#define HDMI_CEC_RX_DATA14                      0x7D2e
> -#define HDMI_CEC_RX_DATA15                      0x7D2f
> -#define HDMI_CEC_LOCK                           0x7D30
> -#define HDMI_CEC_WKUPCTRL                       0x7D31
> -
>  /* I2C Master Registers (E-DDC) */
>  #define HDMI_I2CM_SLAVE                         0x7E00
>  #define HDMI_I2CM_ADDRESS                       0x7E01
> --
> 2.8.1
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
