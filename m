Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:44974 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752814AbeDXJB7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 05:01:59 -0400
Received: by mail-oi0-f43.google.com with SMTP id e80-v6so9516077oig.11
        for <linux-media@vger.kernel.org>; Tue, 24 Apr 2018 02:01:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1522335300-13467-2-git-send-email-manivannan.sadhasivam@linaro.org>
References: <1522335300-13467-1-git-send-email-manivannan.sadhasivam@linaro.org>
 <1522335300-13467-2-git-send-email-manivannan.sadhasivam@linaro.org>
From: Loic Poulain <loic.poulain@linaro.org>
Date: Tue, 24 Apr 2018 11:01:18 +0200
Message-ID: <CAMZdPi-VCsct6S4cYCvN_XniFB9=pJqC8hnTdQnvL5H_CU2a8Q@mail.gmail.com>
Subject: Re: [RESEND PATCH] media: i2c: ov5640: Add pixel clock support
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        slongerbeam@gmail.com, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Todor Tomov <todor.tomov@linaro.org>,
        Nicolas Dechesne <nicolas.dechesne@linaro.org>,
        dragonboard@lists.96boards.org,
        Daniel Thompson <daniel.thompson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 29 March 2018 at 16:55, Manivannan Sadhasivam
<manivannan.sadhasivam@linaro.org> wrote:
> Some of the camera subsystems like camss in Qualcommm MSM chipsets
> require pixel clock support in camera sensor drivers. So, this commit
> adds a default pixel clock rate of 96MHz to OV5640 camera sensor driver.
>
> According to the datasheet, 96MHz can be used as a pixel clock rate for
> most of the modes.
>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Tested-by: Loic Poulain <loic.poulain@linaro.org>

It works for me on Dragonboard 410c + D3 camera mezzanine (ov5640) .

Any comments on this change?

Regards,
Loic
