Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:40666 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932912AbeE2LHe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 May 2018 07:07:34 -0400
Subject: Re: [PATCH v3] Add udmabuf misc device
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: dri-devel@lists.freedesktop.org,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        David Airlie <airlied@linux.ie>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        "open list:KERNEL SELFTEST FRAMEWORK"
        <linux-kselftest@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
References: <20180525140808.12714-1-kraxel@redhat.com>
 <0ad0606e-3201-e203-ec93-8718d7938751@gmail.com>
 <20180529105037.uog4tvcckqp5q6fe@sirius.home.kraxel.org>
From: Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <64c362be-449c-15cb-2673-a5c20b7509eb@gmail.com>
Date: Tue, 29 May 2018 14:07:31 +0300
MIME-Version: 1.0
In-Reply-To: <20180529105037.uog4tvcckqp5q6fe@sirius.home.kraxel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/29/2018 01:50 PM, Gerd Hoffmann wrote:
>    Hi,
>
>>> +config UDMABUF
>>> +	bool "userspace dmabuf misc driver"
>>> +	default n
>>> +	depends on DMA_SHARED_BUFFER
>> Don't you want "select DMA_SHARED_BUFFER" here instead?
> Why do you think so?
After thinking a bit more your code looks ok,
sorry for the noise
> cheers,
>    Gerd
>
