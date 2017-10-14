Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35033 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752769AbdJNATA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 20:19:00 -0400
MIME-Version: 1.0
In-Reply-To: <20171013225337.5196-2-phh@phh.me>
References: <20171013225337.5196-1-phh@phh.me> <20171013225337.5196-2-phh@phh.me>
From: Fabio Estevam <festevam@gmail.com>
Date: Fri, 13 Oct 2017 21:18:59 -0300
Message-ID: <CAOMZO5CtP=A0jF1FimScjSUvv-t6a2ua=ungr0LUHmQvUTKr3Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] drm: bridge: synopsys/dw-hdmi: Enable cec clock
To: Pierre-Hugues Husson <phh@phh.me>
Cc: linux-rockchip@lists.infradead.org,
        linux-media <linux-media@vger.kernel.org>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pierre-Hugues,

On Fri, Oct 13, 2017 at 7:53 PM, Pierre-Hugues Husson <phh@phh.me> wrote:
> The documentation already mentions "cec" optional clock, but
> currently the driver doesn't enable it.

The cec clock is enabled at dw_hdmi_cec_enable().
