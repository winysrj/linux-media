Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:26889 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750898AbdCQMGj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Mar 2017 08:06:39 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OMY00M1NKB0T7A0@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 17 Mar 2017 12:06:36 +0000 (GMT)
Subject: Re: [PATCH v2 00/15] Exynos MFC v6+ - remove the need for the reserved
 memory
To: Marian Mihailescu <mihailescu2m@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org
From: Andrzej Hajda <a.hajda@samsung.com>
Message-id: <04742b05-76bc-a0ec-f5e8-fe3a50115c44@samsung.com>
Date: Fri, 17 Mar 2017 13:06:33 +0100
MIME-version: 1.0
In-reply-to: <CAM3PiRyZ6y5=D-O2z39qoqNAXkkEROwZ3_g9gctrVqF-Gd+Ysg@mail.gmail.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
References: <CAM3PiRyZ6y5=D-O2z39qoqNAXkkEROwZ3_g9gctrVqF-Gd+Ysg@mail.gmail.com>
 <CGME20170317120635eucas1p1d13c446f1418de46a49516e95bf9075d@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marian,

On 15.03.2017 12:36, Marian Mihailescu wrote:
> Hi,
> 
> After testing these patches, encoding using MFC fails when requesting
> buffers for capture (it works for output) with ENOMEM (it complains it
> cannot allocate memory on bank1).
> Did anyone else test encoding?

I have tested encoding and it works on my test target. Could you provide
more details of your setup:
- which kernel and patches,
- which hw,
- which test app.

Regards
Andrzej


> 
> Thanks,
> Marian
> 
> Either I've been missing something or nothing has been going on. (K. E. Gordon)
> 
