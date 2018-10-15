Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:48236 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbeJPAHI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Oct 2018 20:07:08 -0400
Subject: Re: [V2, 2/5] Documentation: dt-bindings: Document the Synopsys MIPI
 DPHY Rx bindings
To: Rob Herring <robh@kernel.org>,
        Luis Oliveira <Luis.Oliveira@synopsys.com>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <Joao.Pinto@synopsys.com>, <festevam@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Hans Verkuil" <hans.verkuil@cisco.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Todor Tomov <todor.tomov@linaro.org>,
        <devicetree@vger.kernel.org>
References: <20180920111648.27000-1-lolivei@synopsys.com>
 <20180920111648.27000-3-lolivei@synopsys.com> <20181012164548.GA11873@bogus>
From: Luis Oliveira <luis.oliveira@synopsys.com>
Message-ID: <5f3b530b-1869-2749-ef05-60fb272d56f8@synopsys.com>
Date: Mon, 15 Oct 2018 17:21:03 +0100
MIME-Version: 1.0
In-Reply-To: <20181012164548.GA11873@bogus>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

On 12-Oct-18 17:45, Rob Herring wrote:
> On Thu, Sep 20, 2018 at 01:16:40PM +0200, Luis Oliveira wrote:
>> Add device-tree bindings documentation for SNPS DesignWare MIPI D-PHY in
>> RX mode.
> 
> "dt-bindings: phy: ..." for the subject.
> 
Yes, you are right.

>>
>> Signed-off-by: Luis Oliveira <lolivei@synopsys.com>
>> ---
>> Changelog
>> v2:
>> - no changes
>>
>>  .../devicetree/bindings/phy/snps,dphy-rx.txt       | 36 ++++++++++++++++++++++
>>  1 file changed, 36 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/phy/snps,dphy-rx.txt
>>
>> diff --git a/Documentation/devicetree/bindings/phy/snps,dphy-rx.txt b/Documentation/devicetree/bindings/phy/snps,dphy-rx.txt
>> new file mode 100644
>> index 0000000..9079f4a
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/phy/snps,dphy-rx.txt
>> @@ -0,0 +1,36 @@
>> +Synopsys DesignWare MIPI Rx D-PHY block details
>> +
>> +Description
>> +-----------
>> +
>> +The Synopsys MIPI D-PHY controller supports MIPI-DPHY in receiver mode.
>> +Please refer to phy-bindings.txt for more information.
>> +
>> +Required properties:
>> +- compatible		: Shall be "snps,dphy-rx".
>> +- #phy-cells		: Must be 1.
>> +- snps,dphy-frequency	: Output frequency of the D-PHY.
>> +- snps,dphy-te-len	: Size of the communication interface (8 bits->8 or 12bits->12).
>> +- reg			: Physical base address and size of the device memory mapped
>> +		 	  registers;
>> +
>> +Optional properties:
>> +- snps,compat-mode	: Compatibility mode control
> 
> type? values?
> 

I will remove this in V3.

>> +
>> +The per-board settings:
>> +- gpios 		: Synopsys testchip used as reference uses this to change setup
>> +		  	  configurations.
> 
> Preferred to be named (e.g. foo-gpios). How many? What are their 
> functions?
> 

Ok, thanks for reviewing this.

>> +
>> +Example:
>> +
>> +	mipi_dphy_rx1: dphy@3040 {
>> +		compatible = "snps,dphy-rx";
>> +		#phy-cells = <1>;
>> +		snps,dphy-frequency = <300000>;
>> +		snps,dphy-te-len = <12>;
>> +		snps,compat-mode = <1>;
>> +		reg = < 0x03040 0x20
>> +			0x08000 0x100
>> +			0x09000 0x100>;
>> +	};
>> +
>> -- 
>> 2.9.3
>>
