Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42964 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbeHXKS3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Aug 2018 06:18:29 -0400
Received: by mail-pf1-f194.google.com with SMTP id l9-v6so4068079pff.9
        for <linux-media@vger.kernel.org>; Thu, 23 Aug 2018 23:45:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
To: Vikash Garodia <vgarodia@codeaurora.org>, andy.gross@linaro.org,
        arnd@arndb.de, bjorn.andersson@linaro.org, hverkuil@xs4all.nl,
        mark.rutland@arm.com, mchehab@kernel.org, robh@kernel.org,
        stanimir.varbanov@linaro.org
From: Stephen Boyd <swboyd@chromium.org>
In-Reply-To: <1535034528-11590-5-git-send-email-vgarodia@codeaurora.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org, acourbot@chromium.org,
        vgarodia@codeaurora.org
References: <1535034528-11590-1-git-send-email-vgarodia@codeaurora.org>
 <1535034528-11590-5-git-send-email-vgarodia@codeaurora.org>
Message-ID: <153509311396.28926.9155836717358532427@swboyd.mtv.corp.google.com>
Subject: Re: [PATCH v6 4/4] venus: firmware: register separate platform_device for
 firmware loader
Date: Thu, 23 Aug 2018 23:45:13 -0700
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Quoting Vikash Garodia (2018-08-23 07:28:48)
> From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> =

> This registers a firmware platform_device and associate it with
> video-firmware DT subnode. Then calls dma configure to initialize
> dma and iommu.

Yes, but why? Commit text isn't supposed to say what is obvious from the
code.
