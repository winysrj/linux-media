Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f177.google.com ([209.85.161.177]:35138 "EHLO
        mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752854AbdFNC7W (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 22:59:22 -0400
Received: by mail-yw0-f177.google.com with SMTP id v7so42932275ywc.2
        for <linux-media@vger.kernel.org>; Tue, 13 Jun 2017 19:59:22 -0700 (PDT)
Received: from mail-yw0-f180.google.com (mail-yw0-f180.google.com. [209.85.161.180])
        by smtp.gmail.com with ESMTPSA id k28sm5861716ywh.57.2017.06.13.19.59.20
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Jun 2017 19:59:20 -0700 (PDT)
Received: by mail-yw0-f180.google.com with SMTP id 63so59769549ywr.0
        for <linux-media@vger.kernel.org>; Tue, 13 Jun 2017 19:59:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <C193D76D23A22742993887E6D207B54D0799EC0C@ORSMSX106.amr.corp.intel.com>
References: <1497385036-1002-1-git-send-email-yong.zhi@intel.com>
 <1497385036-1002-4-git-send-email-yong.zhi@intel.com> <CAAFQd5BQsha1K3pCGpfJiuuA5Uy_ZAVhDbbUJqAumXSGpV=sWQ@mail.gmail.com>
 <C193D76D23A22742993887E6D207B54D0799EC0C@ORSMSX106.amr.corp.intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 14 Jun 2017 11:58:59 +0900
Message-ID: <CAAFQd5Aoz+mT6d9iFTLe4fLiJgVetn9gDJmZS0CwuoPuYF+q5A@mail.gmail.com>
Subject: Re: [PATCH 3/3] intel-ipu3: cio2: Add new MIPI-CSI2 driver
To: "Zhi, Yong" <yong.zhi@intel.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Yang, Hyungwoo" <hyungwoo.yang@intel.com>,
        "Mohandass, Divagar" <divagar.mohandass@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 14, 2017 at 11:32 AM, Zhi, Yong <yong.zhi@intel.com> wrote:
> Hi, Tomasz,
>
> Thanks for your code review, still need more time to study and test the solution for the rest of comments, going forward, I will respond to your review first before submitting new version.

Just to clarify, my note was not about addressing all the comments
instantly, but rather about not leaving any unaddressed comments in
newer patch sets (unless agreed with the reviewers to do that). The
default assumption is that next patch set has all comments from
previous one addressed. If that's not true, it's going to confuse the
reviewers and make them put additional effort into comparing the code
manually.

I'd say it's just better to reply on the list that you need a bit more
time to address the comments, rather than sending a half-done next
patch set. That's just my opinion, though.

Best regards,
Tomasz

>
> Thanks,
>
> Yong
>
>> -----Original Message-----
>> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>> owner@vger.kernel.org] On Behalf Of Tomasz Figa
>> Sent: Tuesday, June 13, 2017 5:01 PM
>> To: Zhi, Yong <yong.zhi@intel.com>
>> Cc: linux-media@vger.kernel.org; Sakari Ailus <sakari.ailus@linux.intel.com>;
>> Zheng, Jian Xu <jian.xu.zheng@intel.com>; Mani, Rajmohan
>> <rajmohan.mani@intel.com>; Toivonen, Tuukka
>> <tuukka.toivonen@intel.com>; Yang, Hyungwoo
>> <hyungwoo.yang@intel.com>; Mohandass, Divagar
>> <divagar.mohandass@intel.com>
>> Subject: Re: [PATCH 3/3] intel-ipu3: cio2: Add new MIPI-CSI2 driver
>>
>> Hi Yong,
>>
>> On Wed, Jun 14, 2017 at 5:17 AM, Yong Zhi <yong.zhi@intel.com> wrote:
>> > This patch adds CIO2 CSI-2 device driver for Intel's IPU3 camera
>> > sub-system support.
>> >
>> > Signed-off-by: Yong Zhi <yong.zhi@intel.com>
>> > ---
>> >  drivers/media/pci/Kconfig                |    2 +
>> >  drivers/media/pci/Makefile               |    3 +-
>> >  drivers/media/pci/intel/Makefile         |    5 +
>> >  drivers/media/pci/intel/ipu3/Kconfig     |   17 +
>> >  drivers/media/pci/intel/ipu3/Makefile    |    1 +
>> >  drivers/media/pci/intel/ipu3/ipu3-cio2.c | 1779
>> > ++++++++++++++++++++++++++++++
>> > drivers/media/pci/intel/ipu3/ipu3-cio2.h |  434 ++++++++
>> >  7 files changed, 2240 insertions(+), 1 deletion(-)  create mode
>> > 100644 drivers/media/pci/intel/Makefile  create mode 100644
>> > drivers/media/pci/intel/ipu3/Kconfig
>> >  create mode 100644 drivers/media/pci/intel/ipu3/Makefile
>> >  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-cio2.c
>> >  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-cio2.h
>> >
>>
>> I quickly checked the code and it doesn't seem to have most of my comments
>> from v2 addressed. It's not a very good practice to send new version without
>> addressing or at least replying to all the comments - it's the best way to lose
>> track of necessary changes. Please make sure that all the comments are
>> taken care of.
>>
>> Best regards,
>> Tomasz
