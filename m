Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:47854 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753831AbdJSOXB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Oct 2017 10:23:01 -0400
MIME-Version: 1.0
In-Reply-To: <1546677.fKvj0pB9W9@avalon>
References: <1507824214-17744-1-git-send-email-akinobu.mita@gmail.com> <1546677.fKvj0pB9W9@avalon>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Thu, 19 Oct 2017 23:22:39 +0900
Message-ID: <CAC5umyhkqORobZ779eWTA4ynZ3fdchTLO8zg5Q92Bfi5ppJ+aA@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: media: xilinx: fix typo in example
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Rob Herring <robh+dt@kernel.org>,
        Hyun Kwon <hyun.kwon@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-10-19 1:08 GMT+09:00 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Akinobu,
>
> Thank you for the patch.
>
> On Thursday, 12 October 2017 19:03:34 EEST Akinobu Mita wrote:
>> Fix typo s/:/;/
>>
>> Cc: Rob Herring <robh+dt@kernel.org>
>> Cc: Hyun Kwon <hyun.kwon@xilinx.com>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>
> Good catch.
>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>
> Should I take this patch in my tree ?

Yes, please do.
Could you also take a look at another patch that I sent at the same time
"media: xilinx-video: fix bad of_node_put() on endpoint error" ?
