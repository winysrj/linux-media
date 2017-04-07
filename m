Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2nam01on0104.outbound.protection.outlook.com ([104.47.34.104]:19808
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752954AbdDGIUF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Apr 2017 04:20:05 -0400
From: "Takiguchi, Yasunari" <Yasunari.Takiguchi@sony.com>
To: kbuild test robot <lkp@intel.com>,
        "kbuild-all@01.org" <kbuild-all@01.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
CC: "tbird20d@gmail.com" <tbird20d@gmail.com>,
        "frowand.list@gmail.com" <frowand.list@gmail.com>,
        "Yamamoto, Masayuki" <Masayuki.Yamamoto@sony.com>,
        "Nozawa, Hideki (STWN)" <Hideki.Nozawa@sony.com>,
        "Yonezawa, Kota" <Kota.Yonezawa@sony.com>,
        "Matsumoto, Toshihiko" <Toshihiko.Matsumoto@sony.com>,
        "Watanabe, Satoshi (SSS)" <Satoshi.C.Watanabe@sony.com>,
        "Takiguchi, Yasunari" <Yasunari.Takiguchi@sony.com>
Subject: RE: [PATCH 2/5] media: Add support for CXD2880 SPI I/F
Date: Fri, 7 Apr 2017 08:19:58 +0000
Message-ID: <02699364973B424C83A42A84B04FDA8533BC79@JPYOKXMS113.jp.sony.com>
References: <1491465339-9483-1-git-send-email-Yasunari.Takiguchi@sony.com>
 <201704071447.DmxQl53a%fengguang.wu@intel.com>
In-Reply-To: <201704071447.DmxQl53a%fengguang.wu@intel.com>
Content-Language: ja-JP
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear All

Our patches consists of the following items.
  [PATCH 1/5] dt-bindings: media: Add document file for CXD2880 SPI I/F
  [PATCH 2/5] media: Add support for CXD2880 SPI I/F
  [PATCH 3/5] media: Add suppurt for CXD2880
  [PATCH 4/5] media: Add suppurt for CXD2880 DVB-T2/T functions
  [PATCH 5/5] media: Update MAINTAINERS file for CXD2880

It is necessary to apply all patches before compiling kernel with our code.

Could you re-compile after applying above the patches.

Best Regards,
Takiguchci
