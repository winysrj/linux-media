Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f65.google.com ([209.85.208.65]:40717 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732685AbeKOBbt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 20:31:49 -0500
Received: by mail-ed1-f65.google.com with SMTP id d3so13425148edx.7
        for <linux-media@vger.kernel.org>; Wed, 14 Nov 2018 07:28:07 -0800 (PST)
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com. [209.85.128.53])
        by smtp.gmail.com with ESMTPSA id y53sm1161542edd.84.2018.11.14.07.28.05
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Nov 2018 07:28:05 -0800 (PST)
Received: by mail-wm1-f53.google.com with SMTP id r11-v6so15819242wmb.2
        for <linux-media@vger.kernel.org>; Wed, 14 Nov 2018 07:28:05 -0800 (PST)
MIME-Version: 1.0
References: <20181114145934.26855-1-maxime.ripard@bootlin.com> <20181114145934.26855-2-maxime.ripard@bootlin.com>
In-Reply-To: <20181114145934.26855-2-maxime.ripard@bootlin.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Wed, 14 Nov 2018 23:27:56 +0800
Message-ID: <CAGb2v64yR+XOk9upmQCOcEpZptMiFepVQsiggoW2B_n8z6s5vg@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] dt-bindings: media: sun6i: Add A31 and H3 compatibles
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        =?UTF-8?Q?Myl=C3=A8ne_Josserand?= <mylene.josserand@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 14, 2018 at 10:59 PM Maxime Ripard
<maxime.ripard@bootlin.com> wrote:
>
> The H3 has a slightly different CSI controller (no BT656, no CCI) which
> looks a lot like the original A31 controller. Add a compatible for the A31,
> and more specific compatible the for the H3 to be used in combination for
> the A31.
>
> Reviewed-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>

Reviewed-by: Chen-Yu Tsai <wens@csie.org>
