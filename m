Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:51017 "EHLO
        mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727650AbeHXLND (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Aug 2018 07:13:03 -0400
Received: by mail-it0-f46.google.com with SMTP id j81-v6so984737ite.0
        for <linux-media@vger.kernel.org>; Fri, 24 Aug 2018 00:39:39 -0700 (PDT)
Received: from mail-it0-f43.google.com (mail-it0-f43.google.com. [209.85.214.43])
        by smtp.gmail.com with ESMTPSA id 14-v6sm350741ity.8.2018.08.24.00.39.37
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Aug 2018 00:39:38 -0700 (PDT)
Received: by mail-it0-f43.google.com with SMTP id p16-v6so952303itp.1
        for <linux-media@vger.kernel.org>; Fri, 24 Aug 2018 00:39:37 -0700 (PDT)
MIME-Version: 1.0
References: <1535034528-11590-1-git-send-email-vgarodia@codeaurora.org>
In-Reply-To: <1535034528-11590-1-git-send-email-vgarodia@codeaurora.org>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Fri, 24 Aug 2018 16:39:25 +0900
Message-ID: <CAPBb6MW8rxj7SQLqKV07CQjjJth7b6iBT9bH8XYd3chtiXcKnw@mail.gmail.com>
Subject: Re: [PATCH v6 0/4] Venus updates - PIL
To: vgarodia@codeaurora.org
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>, robh@kernel.org,
        mark.rutland@arm.com, Andy Gross <andy.gross@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, bjorn.andersson@linaro.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vikash,

On Thu, Aug 23, 2018 at 11:29 PM Vikash Garodia <vgarodia@codeaurora.org> wrote:
>
> Hello,
>
> Here is v6 with following comments addressed:
>
> * 4/4 from earlier series was dropped as .probe was not needed.
> * indentation as per checkpatch --strict option.
> * tested on Venus v4 hardware.

I have tested this series and it seems to be working fine! Thanks for
pushing it forward!

I have made a few comments inline, but some may be difficult to apply
without reorganizing the series a bit. If my explanations are not
clear, I can take care of submitting the next spin of this series if
you wish.
