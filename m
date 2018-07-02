Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:34351 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754304AbeGBIqB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2018 04:46:01 -0400
Received: by mail-it0-f66.google.com with SMTP id d191-v6so1471172ite.1
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2018 01:46:00 -0700 (PDT)
Received: from mail-io0-f180.google.com (mail-io0-f180.google.com. [209.85.223.180])
        by smtp.gmail.com with ESMTPSA id e18-v6sm772646iof.23.2018.07.02.01.46.00
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Jul 2018 01:46:00 -0700 (PDT)
Received: by mail-io0-f180.google.com with SMTP id e13-v6so14037618iof.6
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2018 01:46:00 -0700 (PDT)
MIME-Version: 1.0
References: <20180627152725.9783-1-stanimir.varbanov@linaro.org> <20180627152725.9783-13-stanimir.varbanov@linaro.org>
In-Reply-To: <20180627152725.9783-13-stanimir.varbanov@linaro.org>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Mon, 2 Jul 2018 17:45:48 +0900
Message-ID: <CAPBb6MW8FW4u+8oi8=qyngEzrS6C1nnU6RCySzngcpi81-X6JQ@mail.gmail.com>
Subject: Re: [PATCH v4 12/27] venus: hfi_parser: add common capability parser
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, vgarodia@codeaurora.org,
        Tomasz Figa <tfiga@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 28, 2018 at 12:33 AM Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
>
> This adds common capability parser for all supported Venus
> versions. Having it will help to enumerate better the supported
> raw formars and codecs and also the capabilities for every

s/formars/formats
