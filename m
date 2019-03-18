Return-Path: <SRS0=vX6K=RV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59812C43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 08:28:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2953C2082F
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 08:28:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfCRI2s convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Mar 2019 04:28:48 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:37330 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726719AbfCRI2s (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Mar 2019 04:28:48 -0400
Received: from pps.filterd (m0046668.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x2I8LllU028941;
        Mon, 18 Mar 2019 09:28:38 +0100
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2r8qg4ansc-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Mon, 18 Mar 2019 09:28:38 +0100
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 724D03A;
        Mon, 18 Mar 2019 08:28:37 +0000 (GMT)
Received: from Webmail-eu.st.com (sfhdag5node2.st.com [10.75.127.14])
        by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 4E56726E3;
        Mon, 18 Mar 2019 08:28:37 +0000 (GMT)
Received: from SFHDAG5NODE3.st.com (10.75.127.15) by SFHDAG5NODE2.st.com
 (10.75.127.14) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Mon, 18 Mar
 2019 09:28:36 +0100
Received: from SFHDAG5NODE3.st.com ([fe80::7c09:5d6b:d2c7:5f47]) by
 SFHDAG5NODE3.st.com ([fe80::7c09:5d6b:d2c7:5f47%20]) with mapi id
 15.00.1347.000; Mon, 18 Mar 2019 09:28:37 +0100
From:   Mickael GUENE <mickael.guene@st.com>
To:     Sakari Ailus <sakari.ailus@iki.fi>
CC:     "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Mark Rutland" <mark.rutland@arm.com>
Subject: Re: [PATCH v1 1/3] dt-bindings: Document MIPID02 bindings
Thread-Topic: [PATCH v1 1/3] dt-bindings: Document MIPID02 bindings
Thread-Index: AQHU2J8pWVpVm9MlqUmPoDIPHA9N66YOwYKAgAJFpQA=
Date:   Mon, 18 Mar 2019 08:28:36 +0000
Message-ID: <b238948a-4b08-4fb8-c955-d071bbcd3d2d@st.com>
References: <1552373045-134493-1-git-send-email-mickael.guene@st.com>
 <1552373045-134493-2-git-send-email-mickael.guene@st.com>
 <20190316214649.co63p5arhiwbuv3g@valkosipuli.retiisi.org.uk>
In-Reply-To: <20190316214649.co63p5arhiwbuv3g@valkosipuli.retiisi.org.uk>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.75.127.46]
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <31217DE2CC8BF743A87F799B2144CEB6@st.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-03-18_06:,,
 signatures=0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sakari,

Thanks for your review. Find my comments below.

On 3/16/19 22:46, Sakari Ailus wrote:
> Hi Mickael,
> 
> Thanks for the patchset.
> 
> On Tue, Mar 12, 2019 at 07:44:03AM +0100, Mickael Guene wrote:
>> This adds documentation of device tree for MIPID02 CSI-2 to PARALLEL
>> bridge.
>>
>> Signed-off-by: Mickael Guene <mickael.guene@st.com>
>> ---
>>
>>  .../bindings/media/i2c/st,st-mipid02.txt           | 69 ++++++++++++++++++++++
>>  1 file changed, 69 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/i2c/st,st-mipid02.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/st,st-mipid02.txt b/Documentation/devicetree/bindings/media/i2c/st,st-mipid02.txt
>> new file mode 100644
>> index 0000000..a1855da
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/i2c/st,st-mipid02.txt
>> @@ -0,0 +1,69 @@
>> +STMicroelectronics MIPID02 CSI-2 to PARALLEL bridge
>> +
>> +MIPID02 has two CSI-2 input ports, only one of those ports can be active at a
>> +time. Active port input stream will be de-serialized and its content outputted
>> +through PARALLEL output port.
>> +CSI-2 first input port is a dual lane 800Mbps whereas CSI-2 second input port is
> 
> 800 Mbps per lane (or total)?
> 
800 Mbps per lane. I will document it.
>> +a single lane 800Mbps. Both ports support clock and data lane polarity swap.
>> +First port also supports data lane swap.
>> +PARALLEL output port has a maximum width of 12 bits.
>> +Supported formats are RAW6, RAW7, RAW8, RAW10, RAW12, RGB565, RGB888, RGB444,
>> +YUV420 8-bit, YUV422 8-bit and YUV420 10-bit.
>> +
>> +Required Properties:
>> +- compatible: should be "st,st-mipid02"
>> +- clocks: reference to the xclk input clock.
>> +- clock-names: should be "xclk".
>> +- VDDE-supply: sensor digital IO supply. Must be 1.8 volts.
>> +- VDDIN-supply: sensor internal regulator supply. Must be 1.8 volts.
> 
> Perhaps Rob can confirm, but AFAIR the custom is to use lower case letters.
> 
 It seems there is a 50-50 ratio between upper and lower case usage in
Documentation/devicetree/bindings/media/i2. I will wait Rob's answer to change
it or not.
>> +
>> +Optional Properties:
>> +- reset-gpios: reference to the GPIO connected to the xsdn pin, if any.
>> +	       This is an active low signal to the mipid02.
>> +
>> +Required subnodes:
>> +  - ports: A ports node with one port child node per device input and output
>> +	   port, in accordance with the video interface bindings defined in
>> +	   Documentation/devicetree/bindings/media/video-interfaces.txt. The
>> +	   port nodes are numbered as follows:
>> +
>> +	   Port Description
>> +	   -----------------------------
>> +	   0    CSI-2 first input port
>> +	   1    CSI-2 second input port
>> +	   2    PARALLEL output
> 
> Please document which endpoint properties are relevant. From the above
> description I'd presume this to be at least clock-lanes (1st input),
> data-lanes, lane-polarities (for CSI-2) as well as bus-width for the
> parallel bus.
> 
ok. I will add documentation.
>> +
>> +Example:
>> +
>> +mipid02: mipid02@14 {
> 
> The node should be a generic name. "csi2rx" is used by a few devices now.
>
 If I understand you well, you would prefer:
csi2rx: mipid02@14 {
 I show no usage of csi2rx node naming except for MIPI-CSI2 RX controller.
>> +	compatible = "st,st-mipid02";
>> +	reg = <0x14>;
>> +	status = "okay";
>> +	clocks = <&clk_ext_camera_12>;
>> +	clock-names = "xclk";
>> +	VDDE-supply = <&vdd>;
>> +	VDDIN-supply = <&vdd>;
>> +	ports {
>> +		#address-cells = <1>;
>> +		#size-cells = <0>;
>> +		port@0 {
>> +			reg = <0>;
>> +
>> +			ep0: endpoint {
>> +				clock-lanes = <0>;
>> +				data-lanes = <1 2>;
>> +				remote-endpoint = <&mipi_csi2_in>;
>> +			};
>> +		};
>> +		port@2 {
>> +			reg = <2>;
>> +
>> +			ep2: endpoint {
>> +				bus-width = <8>;
>> +				hsync-active = <0>;
>> +				vsync-active = <0>;
>> +				remote-endpoint = <&parallel_out>;
>> +			};
>> +		};
>> +	};
>> +};
> 
