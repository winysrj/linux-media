Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:49153 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751715AbdJNNVj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 14 Oct 2017 09:21:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAOMZO5CtP=A0jF1FimScjSUvv-t6a2ua=ungr0LUHmQvUTKr3Q@mail.gmail.com>
References: <20171013225337.5196-1-phh@phh.me> <20171013225337.5196-2-phh@phh.me>
 <CAOMZO5CtP=A0jF1FimScjSUvv-t6a2ua=ungr0LUHmQvUTKr3Q@mail.gmail.com>
From: Pierre-Hugues Husson <phh@phh.me>
Date: Sat, 14 Oct 2017 15:21:17 +0200
Message-ID: <CAJ-oXjQG9pbrXpTWyPWnJZ30DBkcQ1vjMG26rQunZq4V_-k8-w@mail.gmail.com>
Subject: Re: [PATCH 1/3] drm: bridge: synopsys/dw-hdmi: Enable cec clock
To: Fabio Estevam <festevam@gmail.com>
Cc: linux-rockchip@lists.infradead.org,
        linux-media <linux-media@vger.kernel.org>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabio,

2017-10-14 2:18 GMT+02:00 Fabio Estevam <festevam@gmail.com>:
> Hi Pierre-Hugues,
>
> On Fri, Oct 13, 2017 at 7:53 PM, Pierre-Hugues Husson <phh@phh.me> wrote:
>> The documentation already mentions "cec" optional clock, but
>> currently the driver doesn't enable it.
>
> The cec clock is enabled at dw_hdmi_cec_enable().
As far as I understand, dw_hdmi_cec_enable only gates
the CEC clock inside the Synopsis IP,
but the SOC still has to provide a specific CEC clock to it.
To enable such an external CEC clock, the binding documentation [1]
mentions a "cec" optional clock, and I'm not seeing any code in dw-hdmi
to enable it.

Regards,

[1] On next-20170929
Documentation/devicetree/bindings/display/bridge/dw_hdmi.txt line 28
