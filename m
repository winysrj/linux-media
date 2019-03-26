Return-Path: <SRS0=7BPv=R5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2582C43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 13:40:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BBE12075C
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 13:40:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731654AbfCZNkd convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Mar 2019 09:40:33 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:17862 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726175AbfCZNkc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Mar 2019 09:40:32 -0400
Received: from pps.filterd (m0046668.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x2QDaXTO002402;
        Tue, 26 Mar 2019 14:40:20 +0100
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2rddhbhss4-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 26 Mar 2019 14:40:20 +0100
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 1B53138;
        Tue, 26 Mar 2019 13:40:19 +0000 (GMT)
Received: from Webmail-eu.st.com (sfhdag5node3.st.com [10.75.127.15])
        by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id D4DCB554A;
        Tue, 26 Mar 2019 13:40:18 +0000 (GMT)
Received: from SFHDAG5NODE3.st.com (10.75.127.15) by SFHDAG5NODE3.st.com
 (10.75.127.15) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Tue, 26 Mar
 2019 14:40:18 +0100
Received: from SFHDAG5NODE3.st.com ([fe80::7c09:5d6b:d2c7:5f47]) by
 SFHDAG5NODE3.st.com ([fe80::7c09:5d6b:d2c7:5f47%20]) with mapi id
 15.00.1347.000; Tue, 26 Mar 2019 14:40:18 +0100
From:   Mickael GUENE <mickael.guene@st.com>
To:     Sakari Ailus <sakari.ailus@iki.fi>
CC:     "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "Hugues FRUCHET" <hugues.fruchet@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Rob Herring <robh+dt@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v3 1/2] dt-bindings: Document MIPID02 bindings
Thread-Topic: [PATCH v3 1/2] dt-bindings: Document MIPID02 bindings
Thread-Index: AQHU47s20KvqK7QEEk24mgG2TzpiYqYdw4uAgAAXIQA=
Date:   Tue, 26 Mar 2019 13:40:18 +0000
Message-ID: <7a62fee6-5792-0390-fd6f-f34aca0dc759@st.com>
References: <1552373045-134493-1-git-send-email-mickael.guene@st.com>
 <1553594620-88280-1-git-send-email-mickael.guene@st.com>
 <1553594620-88280-2-git-send-email-mickael.guene@st.com>
 <20190326121731.m7z5o2jbzlfxalu6@valkosipuli.retiisi.org.uk>
In-Reply-To: <20190326121731.m7z5o2jbzlfxalu6@valkosipuli.retiisi.org.uk>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.75.127.49]
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <E011A9079E272B4CBA276AABFCF94E11@st.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-03-26_10:,,
 signatures=0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sakari,

On 3/26/19 13:17, Sakari Ailus wrote:
> Hi Mickael,
> 
> On Tue, Mar 26, 2019 at 11:03:39AM +0100, Mickael Guene wrote:
>> This adds documentation of device tree for MIPID02 CSI-2 to PARALLEL
>> bridge.
>>
>> Signed-off-by: Mickael Guene <mickael.guene@st.com>
>> ---
>>
>> Changes in v3: None
>> Changes in v2:
>> - Add precision about first CSI-2 port data rate
>> - Document endpoints supported properties
>> - Rename 'mipid02@14' into generic 'csi2rx@14' in example
>>
>>  .../bindings/media/i2c/st,st-mipid02.txt           | 83 ++++++++++++++++++++++
>>  MAINTAINERS                                        |  7 ++
>>  2 files changed, 90 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/i2c/st,st-mipid02.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/st,st-mipid02.txt b/Documentation/devicetree/bindings/media/i2c/st,st-mipid02.txt
>> new file mode 100644
>> index 0000000..dfeab45
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/i2c/st,st-mipid02.txt
>> @@ -0,0 +1,83 @@
>> +STMicroelectronics MIPID02 CSI-2 to PARALLEL bridge
>> +
>> +MIPID02 has two CSI-2 input ports, only one of those ports can be active at a
>> +time. Active port input stream will be de-serialized and its content outputted
>> +through PARALLEL output port.
>> +CSI-2 first input port is a dual lane 800Mbps per lane whereas CSI-2 second
>> +input port is a single lane 800Mbps. Both ports support clock and data lane
>> +polarity swap. First port also supports data lane swap.
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
>> +
>> +Endpoint node optional properties for CSI-2 connection are:
>> +- bus-type: if present should be 4 - MIPI CSI-2 D-PHY.
> 
> You can drop this IMO --- there's just a single valid value so the driver
> may know that.
> 
ok
>> +- clock-lanes: should be set to <0> if present (clock lane on hardware lane 0).
> 
> And please omit this, too, if the clock lane is always 0. Please update the
> example, too. The driver doesn't need to check that either IMO, but up to
> you.
> 
ok I will drop it from device tree documentation but I will keep driver check.
I will also make data-lanes mandatory.
>> +- data-lanes: if present should be <1> for Port 1. for Port 0 dual-lane
>> +operation should be <1 2> or <2 1>. For Port 0 single-lane operation should be
>> +<1> or <2>.
>> +- lane-polarities: any lane can be inverted.
>> +
>> +Endpoint node optional properties for PARALLEL connection are:
>> +- bus-type: if present should be 5 - Parallel.
> 
> This, too, can be omitted.
> 
ok
>> +- bus-width: shall be set to <6>, <7>, <8>, <10> or <12>.
>> +- hsync-active: active state of the HSYNC signal, 0/1 for LOW/HIGH respectively.
>> +- vsync-active: active state of the VSYNC signal, 0/1 for LOW/HIGH respectively.
> 
> If these are optional, what are the defaults? IMO you could make them
> mandatory as well.
> 
I will make bus-width mandatory
hsync-active and vsync-active will stay optional with LOW being the default.
>> +
>> +Example:
>> +
>> +mipid02: csi2rx@14 {
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
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index e17ebf7..74da99d 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -14668,6 +14668,13 @@ S:	Maintained
>>  F:	drivers/iio/imu/st_lsm6dsx/
>>  F:	Documentation/devicetree/bindings/iio/imu/st_lsm6dsx.txt
>>  
>> +ST MIPID02 CSI-2 TO PARALLEL BRIDGE DRIVER
>> +M:	Mickael Guene <mickael.guene@st.com>
>> +L:	linux-media@vger.kernel.org
>> +T:	git git://linuxtv.org/media_tree.git
>> +S:	Maintained
>> +F:	Documentation/devicetree/bindings/media/i2c/st,st-mipid02.txt
>> +
>>  ST STM32 I2C/SMBUS DRIVER
>>  M:	Pierre-Yves MORDRET <pierre-yves.mordret@st.com>
>>  L:	linux-i2c@vger.kernel.org
> 
