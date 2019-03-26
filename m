Return-Path: <SRS0=7BPv=R5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E0E4C43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 14:37:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC57E2075E
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 14:37:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731762AbfCZOh0 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Mar 2019 10:37:26 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:28869 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731491AbfCZOh0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Mar 2019 10:37:26 -0400
Received: from pps.filterd (m0046037.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x2QEaqHK025210;
        Tue, 26 Mar 2019 15:36:52 +0100
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2rddh7j3dp-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 26 Mar 2019 15:36:52 +0100
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id F386938;
        Tue, 26 Mar 2019 14:36:42 +0000 (GMT)
Received: from Webmail-eu.st.com (sfhdag5node2.st.com [10.75.127.14])
        by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 611D4A574;
        Tue, 26 Mar 2019 14:36:42 +0000 (GMT)
Received: from SFHDAG5NODE3.st.com (10.75.127.15) by SFHDAG5NODE2.st.com
 (10.75.127.14) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Tue, 26 Mar
 2019 15:36:41 +0100
Received: from SFHDAG5NODE3.st.com ([fe80::7c09:5d6b:d2c7:5f47]) by
 SFHDAG5NODE3.st.com ([fe80::7c09:5d6b:d2c7:5f47%20]) with mapi id
 15.00.1347.000; Tue, 26 Mar 2019 15:36:42 +0100
From:   Mickael GUENE <mickael.guene@st.com>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
CC:     "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "Hugues FRUCHET" <hugues.fruchet@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Petr Cvek <petrcvekcz@gmail.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Ben Kao" <ben.kao@intel.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "Todor Tomov" <todor.tomov@linaro.org>,
        Rui Miguel Silva <rui.silva@linaro.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ricardo Ribalda Delgado <ricardo@ribalda.com>,
        "Jacopo Mondi" <jacopo+renesas@jmondi.org>,
        Tianshu Qiu <tian.shu.qiu@intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>
Subject: Re: [PATCH v3 2/2] media:st-mipid02: MIPID02 CSI-2 to PARALLEL bridge
 driver
Thread-Topic: [PATCH v3 2/2] media:st-mipid02: MIPID02 CSI-2 to PARALLEL
 bridge driver
Thread-Index: AQHU47s4T23daefrHk6Z36vjlaOK2qYdtyWAgAAzRAA=
Date:   Tue, 26 Mar 2019 14:36:41 +0000
Message-ID: <fb8bf371-6158-a9b8-0822-65bc5d6db536@st.com>
References: <1552373045-134493-1-git-send-email-mickael.guene@st.com>
 <1553594620-88280-1-git-send-email-mickael.guene@st.com>
 <1553594620-88280-3-git-send-email-mickael.guene@st.com>
 <20190326113308.mp5hqdw3ktbpcawu@paasikivi.fi.intel.com>
In-Reply-To: <20190326113308.mp5hqdw3ktbpcawu@paasikivi.fi.intel.com>
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
Content-ID: <BCAF9CBA39871E478212AD357F7F4B89@st.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-03-26_10:,,
 signatures=0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Sakari,

>> +static int bpp_from_code(__u32 code)
>> +{
>> +	switch (code) {
>> +	case MEDIA_BUS_FMT_SBGGR8_1X8:
>> +	case MEDIA_BUS_FMT_SGBRG8_1X8:
>> +	case MEDIA_BUS_FMT_SGRBG8_1X8:
>> +	case MEDIA_BUS_FMT_SRGGB8_1X8:
>> +		return 8;
>> +	case MEDIA_BUS_FMT_SBGGR10_1X10:
>> +	case MEDIA_BUS_FMT_SGBRG10_1X10:
>> +	case MEDIA_BUS_FMT_SGRBG10_1X10:
>> +	case MEDIA_BUS_FMT_SRGGB10_1X10:
>> +		return 10;
>> +	case MEDIA_BUS_FMT_SBGGR12_1X12:
>> +	case MEDIA_BUS_FMT_SGBRG12_1X12:
>> +	case MEDIA_BUS_FMT_SGRBG12_1X12:
>> +	case MEDIA_BUS_FMT_SRGGB12_1X12:
>> +		return 12;
>> +	case MEDIA_BUS_FMT_UYVY8_2X8:
> 
> This is good for the parallel bus, but on CSI-2 side you should have
> MEDIA_BUS_FMT_UYVY8_1X16 instead. This isn't technically correct for a
> serial bus, but the custom is to use the one sample / pixel formats on the
> serial busses.
> 
 Should MEDIA_BUS_FMT_BGR888_1X24 be something like
MEDIA_BUS_FMT_BGR888_3X8 for parallel output bus ?

Rgs
Mickael
