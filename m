Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:58706 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756492AbeASWQr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Jan 2018 17:16:47 -0500
Subject: Re: [PATCH v5 1/2] dt-bindings: media: Add Allwinner V3s Camera
 Sensor Interface (CSI)
To: Icenowy Zheng <icenowy@aosc.io>,
        linux-arm-kernel@lists.infradead.org
Cc: Rob Herring <robh@kernel.org>, Yong Deng <yong.deng@magewell.com>,
        Mark Rutland <mark.rutland@arm.com>, megous@megous.com,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        linux-sunxi@googlegroups.com,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Rick Chang <rick.chang@mediatek.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Yannick Fertre <yannick.fertre@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>
References: <1515639823-35782-1-git-send-email-yong.deng@magewell.com>
 <20180119211409.ubysuyvhkmfotbdg@rob-hp-laptop>
 <2315959.AJds7mCBWN@ice-x220i>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <2134527e-cb44-1c4d-0ac9-8bbfc71b8ce8@infradead.org>
Date: Fri, 19 Jan 2018 14:16:09 -0800
MIME-Version: 1.0
In-Reply-To: <2315959.AJds7mCBWN@ice-x220i>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/19/2018 01:17 PM, Icenowy Zheng wrote:
> 在 2018年1月20日星期六 CST 上午5:14:09，Rob Herring 写道：
>> On Thu, Jan 11, 2018 at 11:03:43AM +0800, Yong Deng wrote:
>>> Add binding documentation for Allwinner V3s CSI.
>>>
>>> Signed-off-by: Yong Deng <yong.deng@magewell.com>
>>> ---
>>>
>>>  .../devicetree/bindings/media/sun6i-csi.txt        | 59
>>>  ++++++++++++++++++++++ 1 file changed, 59 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/media/sun6i-csi.txt
>>
>> Reviewed-by: Rob Herring <robh@kernel.org>
> 
> I think other subsystem's maintainer may expect a Acked-by from you here.
> 
> Why do you use Reviewed-by here instead?

The Reviewed-by: tag is a stronger ACK than the Acked-by: tag, so this
should be sufficient for other subsystem maintainers.

Please see Documentation/process/submitting-patches.rst, section 13.


-- 
~Randy
