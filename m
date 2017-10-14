Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34172 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753291AbdJNNlW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 14 Oct 2017 09:41:22 -0400
MIME-Version: 1.0
In-Reply-To: <CAJ-oXjQG9pbrXpTWyPWnJZ30DBkcQ1vjMG26rQunZq4V_-k8-w@mail.gmail.com>
References: <20171013225337.5196-1-phh@phh.me> <20171013225337.5196-2-phh@phh.me>
 <CAOMZO5CtP=A0jF1FimScjSUvv-t6a2ua=ungr0LUHmQvUTKr3Q@mail.gmail.com> <CAJ-oXjQG9pbrXpTWyPWnJZ30DBkcQ1vjMG26rQunZq4V_-k8-w@mail.gmail.com>
From: Fabio Estevam <festevam@gmail.com>
Date: Sat, 14 Oct 2017 10:41:20 -0300
Message-ID: <CAOMZO5AxNRj5o0cw1-bjtZbHeQZwZJ0dYV+zPBd8TKxpSZxizQ@mail.gmail.com>
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

Hi Pierre,

On Sat, Oct 14, 2017 at 10:21 AM, Pierre-Hugues Husson <phh@phh.me> wrote:

> As far as I understand, dw_hdmi_cec_enable only gates
> the CEC clock inside the Synopsis IP,
> but the SOC still has to provide a specific CEC clock to it.
> To enable such an external CEC clock, the binding documentation [1]
> mentions a "cec" optional clock, and I'm not seeing any code in dw-hdmi
> to enable it.

Ok, understood.

In the case of i.MX6 we control the CEC clock via
HDMI_MC_CLKDIS_CECCLK_DISABLE bit inside the Synopsis IP.

Looks like Rockchip needs the external CEC clock then.

Regards,

Fabio Estevam
