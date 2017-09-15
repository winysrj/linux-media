Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:60588 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751458AbdIOS4D (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 14:56:03 -0400
Subject: Re: [media] stm32-dcmi: Improve four size determinations
To: Joe Perches <joe@perches.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Cc: Alexandre Torgue <alexandre.torgue@st.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <730b535e-39a5-2c2b-f463-e76da967a723@users.sourceforge.net>
 <f4e400ea-9660-05cd-3194-cdf2495a2376@users.sourceforge.net>
 <1505499388.27581.13.camel@perches.com>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <fdcd16a7-0345-9a6c-1ef8-85ac32eb9448@users.sourceforge.net>
Date: Fri, 15 Sep 2017 20:54:44 +0200
MIME-Version: 1.0
In-Reply-To: <1505499388.27581.13.camel@perches.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> +	memcpy(dcmi->sd_formats, sd_fmts, num_fmts * sizeof(*dcmi->sd_formats));
> 
> devm_kmemdup

Are function variants provided which handle memory duplications
for arrays explicitly?

Regards,
Markus
