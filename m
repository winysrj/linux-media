Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38504 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387840AbeKVURh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Nov 2018 15:17:37 -0500
Received: by mail-wm1-f68.google.com with SMTP id k198so8434187wmd.3
        for <linux-media@vger.kernel.org>; Thu, 22 Nov 2018 01:38:54 -0800 (PST)
References: <20181121111558.10838-1-rui.silva@linaro.org> <18c5ad5c-e800-c317-4246-a8a207f3dff4@xs4all.nl>
From: Rui Miguel Silva <rui.silva@linaro.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: sakari.ailus@linux.intel.com,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v8 00/12] media: staging/imx7: add i.MX7 media driver
In-reply-to: <18c5ad5c-e800-c317-4246-a8a207f3dff4@xs4all.nl>
Date: Thu, 22 Nov 2018 09:38:51 +0000
Message-ID: <m34lc9moyc.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,
On Wed 21 Nov 2018 at 11:53, Hans Verkuil wrote:
> On 11/21/2018 12:15 PM, Rui Miguel Silva wrote:
>> Hi,
>> This series introduces the Media driver to work with the i.MX7 
>> SoC. it uses the
>> already existing imx media core drivers but since the i.MX7, 
>> contrary to
>> i.MX5/6, do not have an IPU and because of that some changes in 
>> the imx media
>> core are made along this series to make it support that case.
>
> Can you run scripts/checkpatch.pl --strict over these patches? I 
> get too
> many messages from it. Most should be easy to fix.

Yeah, I will fix as much as I think is sane, some I will leave it 
to
make code more readable.

---
Cheers,
	Rui
