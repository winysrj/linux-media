Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732546AbeHNRUg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 13:20:36 -0400
MIME-Version: 1.0
References: <1533894263-10692-1-git-send-email-vgarodia@codeaurora.org>
In-Reply-To: <1533894263-10692-1-git-send-email-vgarodia@codeaurora.org>
From: Josh Boyer <jwboyer@kernel.org>
Date: Tue, 14 Aug 2018 10:32:58 -0400
Message-ID: <CA+5PVA6Q_Z2d1te6gMDfeJXWAjV7YFp_coxCxQQE5O7aoYn5yA@mail.gmail.com>
Subject: Re: qcom: update firmware file for Venus on SDM845
To: vgarodia@codeaurora.org
Cc: Linux Firmware <linux-firmware@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Alexandre Courbot <acourbot@google.com>,
        linux-media-owner@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 10, 2018 at 5:44 AM Vikash Garodia <vgarodia@codeaurora.org> wrote:
>
> hi,
>
> This pull request updates firmware files for Venus h/w codec found on the Qualcomm SDM845 chipset.
>
> The following changes since commit 7b5835fd37630d18ac0c755329172f6a17c1af29:
>
>   linux-firmware: add firmware for mt76x2u (2018-07-30 07:20:31 -0400)
>
> are available in the git repository at:
>
>   https://github.com/vgarodia/venus_firmware_23 master
>
> for you to fetch changes up to 6ae7a5bf57f035aecc7613943528e52ada7e1e03:
>
>   qcom: update venus firmware files for v5.2 (2018-08-10 12:57:47 +0530)
>
> ----------------------------------------------------------------
> Vikash Garodia (1):
>       qcom: update venus firmware files for v5.2
>
>  WHENCE                   |   2 +-
>  qcom/venus-5.2/venus.b00 | Bin 212 -> 212 bytes
>  qcom/venus-5.2/venus.b01 | Bin 6600 -> 6600 bytes
>  qcom/venus-5.2/venus.b02 | Bin 819552 -> 837304 bytes
>  qcom/venus-5.2/venus.b03 | Bin 33536 -> 33640 bytes
>  qcom/venus-5.2/venus.mbn | Bin 865408 -> 883264 bytes
>  qcom/venus-5.2/venus.mdt | Bin 6812 -> 6812 bytes
>  7 files changed, 1 insertion(+), 1 deletion(-)

Pulled and pushed out.  Thanks.

josh
