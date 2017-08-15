Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.161.174]:34649 "EHLO
        mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751147AbdHOLco (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Aug 2017 07:32:44 -0400
Received: by mail-yw0-f174.google.com with SMTP id s143so3186806ywg.1
        for <linux-media@vger.kernel.org>; Tue, 15 Aug 2017 04:32:44 -0700 (PDT)
Received: from mail-yw0-f170.google.com (mail-yw0-f170.google.com. [209.85.161.170])
        by smtp.gmail.com with ESMTPSA id 64sm3510928ywz.58.2017.08.15.04.32.42
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Aug 2017 04:32:43 -0700 (PDT)
Received: by mail-yw0-f170.google.com with SMTP id p68so3227929ywg.0
        for <linux-media@vger.kernel.org>; Tue, 15 Aug 2017 04:32:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6F87890CF0F5204F892DEA1EF0D77A59725E1A1D@FMSMSX114.amr.corp.intel.com>
References: <6F87890CF0F5204F892DEA1EF0D77A59725E1A1D@FMSMSX114.amr.corp.intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 15 Aug 2017 20:32:21 +0900
Message-ID: <CAAFQd5B0w-xQ-T56NHNOxLCRE-ow0C3PCXk_bfn_Rn4zHifQvQ@mail.gmail.com>
Subject: Re: [GIT PULL] linux-firmware: intel: Add Kabylake IPU3 firmware
To: "Mani, Rajmohan" <rajmohan.mani@intel.com>
Cc: "linux-firmware@kernel.org" <linux-firmware@kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Zhi, Yong" <yong.zhi@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,

On Sat, Aug 5, 2017 at 9:04 AM, Mani, Rajmohan <rajmohan.mani@intel.com> wrote:
> Hi,
>
> Please review this PULL request to add Kabylake IPU3 firmware to the linux-firmware repository.
>
>
> The following changes since commit 7d2c913dcd1be083350d97a8cb1eba24cfacbc8a:
>
>   ath10k: update year in license (2017-06-22 12:06:02 -0700)
>
> are available in the git repository at:
>
>   https://github.com/RajmohanMani/linux-firmware.git tags/v1
>
> for you to fetch changes up to 2c27b0cb02f18c022d8378e0e1abaf8b7ae8188f:
>
>   linux-firmware: intel: Add Kabylake IPU3 firmware (2017-08-04 15:53:13 -0700)
>
> ----------------------------------------------------------------
> IPU3 firmware version irci_irci_ecr-master_20161208_0213_20170112_1500
>
> ----------------------------------------------------------------
> Rajmohan Mani (1):
>       linux-firmware: intel: Add Kabylake IPU3 firmware
>
>  LICENSE.ipu3_firmware                                      |  36 ++++++++++++++++++++++++++++++++++++
>  WHENCE                                                     |  11 +++++++++++
>  intel/ipu3-fw.bin                                          |   1 +
>  intel/irci_irci_ecr-master_20161208_0213_20170112_1500.bin | Bin 0 -> 1212984 bytes
>  4 files changed, 48 insertions(+)
>  create mode 100644 LICENSE.ipu3_firmware
>  create mode 120000 intel/ipu3-fw.bin
>  create mode 100644 intel/irci_irci_ecr-master_20161208_0213_20170112_1500.bin

A gentle ping. Perhaps any issue with this pull request?

Best regards,
Tomasz
