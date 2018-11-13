Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.60.111]:52060 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbeKMSza (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 13:55:30 -0500
Subject: Re: [V3, 1/4] Documentation: dt-bindings: phy: Document the Synopsys
 MIPI DPHY Rx bindings
To: Rob Herring <robh@kernel.org>,
        Luis Oliveira <luis.oliveira@synopsys.com>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <joao.pinto@synopsys.com>, <festevam@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Hans Verkuil" <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Keiichi Watanabe" <keiichiw@chromium.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Todor Tomov <todor.tomov@linaro.org>,
        <devicetree@vger.kernel.org>
References: <1539953556-35762-1-git-send-email-lolivei@synopsys.com>
 <1539953556-35762-2-git-send-email-lolivei@synopsys.com>
 <20181024173611.GA30655@bogus>
From: Luis Oliveira <luis.oliveira@synopsys.com>
Message-ID: <0cfb65eb-42c5-c548-12e9-c495d5e5156a@synopsys.com>
Date: Tue, 13 Nov 2018 08:58:16 +0000
MIME-Version: 1.0
In-Reply-To: <20181024173611.GA30655@bogus>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob, my responses inline.

On 24-Oct-18 18:36, Rob Herring wrote:
> On Fri, Oct 19, 2018 at 02:52:23PM +0200, Luis Oliveira wrote:
>> Add device-tree bindings documentation for SNPS DesignWare MIPI D-PHY in
>> RX mode.
>>
>> Signed-off-by: Luis Oliveira <lolivei@synopsys.com>
>> ---
>> Changelog
>> v2-V3
>> - removed gpios reference - it was for a separated driver
>> - changed address to show complete address
>>
>>  .../devicetree/bindings/phy/snps,dphy-rx.txt       | 28 ++++++++++++++++++++++
>>  1 file changed, 28 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/phy/snps,dphy-rx.txt
>>
>> diff --git a/Documentation/devicetree/bindings/phy/snps,dphy-rx.txt b/Documentation/devicetree/bindings/phy/snps,dphy-rx.txt
>> new file mode 100644
>> index 0000000..03d17ab
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/phy/snps,dphy-rx.txt
>> @@ -0,0 +1,28 @@
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
> 
> Needs a unit suffix (-hz).
> 

Yes,

>> +- snps,dphy-te-len	: Size of the communication interface (8 bits->8 or 12bits->12).
>> +- reg			: Physical base address and size of the device memory mapped
>> +		 	  registers;
> 
> How many, what are they, and what order? Looks like 3 below.
> 
> Also, a tab after spaces error.
> 

Yep, I will fix it. Thanks

>> +
>> +Example:
>> +
>> +	mipi_dphy_rx1: dphy@d00003040 {
>> +		compatible = "snps,dphy-rx";
>> +		#phy-cells = <1>;
>> +		snps,dphy-frequency = <300000>;
>> +		snps,dphy-te-len = <12>;
>> +		reg = < 0xd0003040 0x20
>> +			0xd0008000 0x100
>> +			0xd0009000 0x100>;
>> +	};
>> +
>> --
>> 2.7.4
>>
