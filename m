Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:48662 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932847AbeE2Kuk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 May 2018 06:50:40 -0400
Date: Tue, 29 May 2018 12:50:37 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
To: Oleksandr Andrushchenko <andr2000@gmail.com>
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
Subject: Re: [PATCH v3] Add udmabuf misc device
Message-ID: <20180529105037.uog4tvcckqp5q6fe@sirius.home.kraxel.org>
References: <20180525140808.12714-1-kraxel@redhat.com>
 <0ad0606e-3201-e203-ec93-8718d7938751@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ad0606e-3201-e203-ec93-8718d7938751@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  Hi,

> > +config UDMABUF
> > +	bool "userspace dmabuf misc driver"
> > +	default n
> > +	depends on DMA_SHARED_BUFFER
> Don't you want "select DMA_SHARED_BUFFER" here instead?

Why do you think so?

cheers,
  Gerd
