Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f173.google.com ([209.85.161.173]:36526 "EHLO
        mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754156AbdHWOuY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 10:50:24 -0400
Received: by mail-yw0-f173.google.com with SMTP id y64so2090006ywf.3
        for <linux-media@vger.kernel.org>; Wed, 23 Aug 2017 07:50:24 -0700 (PDT)
Received: from mail-yw0-f176.google.com (mail-yw0-f176.google.com. [209.85.161.176])
        by smtp.gmail.com with ESMTPSA id c16sm630334ywa.67.2017.08.23.07.50.22
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Aug 2017 07:50:22 -0700 (PDT)
Received: by mail-yw0-f176.google.com with SMTP id s143so2192739ywg.1
        for <linux-media@vger.kernel.org>; Wed, 23 Aug 2017 07:50:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAFQd5B0w-xQ-T56NHNOxLCRE-ow0C3PCXk_bfn_Rn4zHifQvQ@mail.gmail.com>
References: <6F87890CF0F5204F892DEA1EF0D77A59725E1A1D@FMSMSX114.amr.corp.intel.com>
 <CAAFQd5B0w-xQ-T56NHNOxLCRE-ow0C3PCXk_bfn_Rn4zHifQvQ@mail.gmail.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 23 Aug 2017 23:50:01 +0900
Message-ID: <CAAFQd5DFpk7LyfLCJASZUZfvGGxk+4Qi-MYS6iCEn0HZ0ptnsA@mail.gmail.com>
Subject: Re: [GIT PULL] linux-firmware: intel: Add Kabylake IPU3 firmware
To: Kyle McMartin <kyle@kernel.org>
Cc: "linux-firmware@kernel.org" <linux-firmware@kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Zhi, Yong" <yong.zhi@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kyle,

Are you perhaps the right person to take a look at this? Thanks in
advance. (Judging by git log. Sorry if that's not the case.)

Best regards,
Tomasz


On Tue, Aug 15, 2017 at 8:32 PM, Tomasz Figa <tfiga@chromium.org> wrote:
> Hi everyone,
>
> On Sat, Aug 5, 2017 at 9:04 AM, Mani, Rajmohan <rajmohan.mani@intel.com> wrote:
>> Hi,
>>
>> Please review this PULL request to add Kabylake IPU3 firmware to the linux-firmware repository.
>>
>>
>> The following changes since commit 7d2c913dcd1be083350d97a8cb1eba24cfacbc8a:
>>
>>   ath10k: update year in license (2017-06-22 12:06:02 -0700)
>>
>> are available in the git repository at:
>>
>>   https://github.com/RajmohanMani/linux-firmware.git tags/v1
>>
>> for you to fetch changes up to 2c27b0cb02f18c022d8378e0e1abaf8b7ae8188f:
>>
>>   linux-firmware: intel: Add Kabylake IPU3 firmware (2017-08-04 15:53:13 -0700)
>>
>> ----------------------------------------------------------------
>> IPU3 firmware version irci_irci_ecr-master_20161208_0213_20170112_1500
>>
>> ----------------------------------------------------------------
>> Rajmohan Mani (1):
>>       linux-firmware: intel: Add Kabylake IPU3 firmware
>>
>>  LICENSE.ipu3_firmware                                      |  36 ++++++++++++++++++++++++++++++++++++
>>  WHENCE                                                     |  11 +++++++++++
>>  intel/ipu3-fw.bin                                          |   1 +
>>  intel/irci_irci_ecr-master_20161208_0213_20170112_1500.bin | Bin 0 -> 1212984 bytes
>>  4 files changed, 48 insertions(+)
>>  create mode 100644 LICENSE.ipu3_firmware
>>  create mode 120000 intel/ipu3-fw.bin
>>  create mode 100644 intel/irci_irci_ecr-master_20161208_0213_20170112_1500.bin
>
> A gentle ping. Perhaps any issue with this pull request?
>
> Best regards,
> Tomasz
