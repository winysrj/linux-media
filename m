Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f68.google.com ([209.85.213.68]:45635 "EHLO
        mail-vk0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751261AbeEADkp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Apr 2018 23:40:45 -0400
Received: by mail-vk0-f68.google.com with SMTP id 203-v6so6386644vka.12
        for <linux-media@vger.kernel.org>; Mon, 30 Apr 2018 20:40:44 -0700 (PDT)
Received: from mail-vk0-f53.google.com (mail-vk0-f53.google.com. [209.85.213.53])
        by smtp.gmail.com with ESMTPSA id 23sm2637495uau.40.2018.04.30.20.40.43
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Apr 2018 20:40:43 -0700 (PDT)
Received: by mail-vk0-f53.google.com with SMTP id i185-v6so1232386vkg.3
        for <linux-media@vger.kernel.org>; Mon, 30 Apr 2018 20:40:43 -0700 (PDT)
MIME-Version: 1.0
References: <1524622328-30493-1-git-send-email-andy.yeh@intel.com> <1524622328-30493-3-git-send-email-andy.yeh@intel.com>
In-Reply-To: <1524622328-30493-3-git-send-email-andy.yeh@intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 01 May 2018 03:40:32 +0000
Message-ID: <CAAFQd5CbJQm4-DyR4fieBAAa9JDrDtmvc9gtwOXU3rXzbZ3njQ@mail.gmail.com>
Subject: Re: [RESEND PATCH v8 2/2] media: dw9807: Add dw9807 vcm driver
To: "Yeh, Andy" <andy.yeh@intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        devicetree@vger.kernel.org, jacopo@jmondi.org,
        Alan Chiang <alanx.chiang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

On Wed, Apr 25, 2018 at 11:04 AM Andy Yeh <andy.yeh@intel.com> wrote:

> From: Alan Chiang <alanx.chiang@intel.com>

> DW9807 is a 10 bit DAC from Dongwoon, designed for linear
> control of voice coil motor.

> This driver creates a V4L2 subdevice and
> provides control to set the desired focus.

> Signed-off-by: Andy Yeh <andy.yeh@intel.com>
> ---
> since v1:
> - changed author.
> since v2:
> - addressed outstanding comments.
> - enabled sequential write to update 2 registers in a single transaction.
> since v3:
> - addressed comments for v3.
> - Remove redundant codes and declare some variables as constant variable.
> - separate DT binding to another patch
> since v4:
> - sent patchset included DT binding with cover page
> since v6:
> - change the return code of i2c_check
> - fix long cols exceed 80 chars
> - remove #define DW9807_NAME since only used once
> since v7:
> - Remove some redundant type cast
> - Modify to meet the coding style
> - Replace a while loop by readx_poll_timeout function
> - Return the i2c error directly

Reviewed-by: Tomasz Figa <tfiga@chromium.org>

Thanks for addressing the comments.

Best regards,
Tomasz
