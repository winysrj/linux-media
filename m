Return-Path: <SRS0=7BPv=R5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E6A5C43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 14:13:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1695B20856
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 14:13:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731599AbfCZONb convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Mar 2019 10:13:31 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:45288 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726285AbfCZONa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Mar 2019 10:13:30 -0400
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x2QEBcUu029942;
        Tue, 26 Mar 2019 15:12:56 +0100
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2rf4ybvyjy-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 26 Mar 2019 15:12:56 +0100
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 0770A49;
        Tue, 26 Mar 2019 14:12:53 +0000 (GMT)
Received: from Webmail-eu.st.com (sfhdag5node1.st.com [10.75.127.13])
        by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 66451A495;
        Tue, 26 Mar 2019 14:12:53 +0000 (GMT)
Received: from SFHDAG5NODE3.st.com (10.75.127.15) by SFHDAG5NODE1.st.com
 (10.75.127.13) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Tue, 26 Mar
 2019 15:12:53 +0100
Received: from SFHDAG5NODE3.st.com ([fe80::7c09:5d6b:d2c7:5f47]) by
 SFHDAG5NODE3.st.com ([fe80::7c09:5d6b:d2c7:5f47%20]) with mapi id
 15.00.1347.000; Tue, 26 Mar 2019 15:12:53 +0100
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
Thread-Index: AQHU47s4T23daefrHk6Z36vjlaOK2qYdtyWAgAAXcYCAABAYgIAABRaA
Date:   Tue, 26 Mar 2019 14:12:52 +0000
Message-ID: <23f2f17c-7c3d-30c0-d191-1a5c7a4a2989@st.com>
References: <1552373045-134493-1-git-send-email-mickael.guene@st.com>
 <1553594620-88280-1-git-send-email-mickael.guene@st.com>
 <1553594620-88280-3-git-send-email-mickael.guene@st.com>
 <20190326113308.mp5hqdw3ktbpcawu@paasikivi.fi.intel.com>
 <9c8fb935-5c67-d4aa-d0ba-2aae0edd2b55@st.com>
 <20190326135439.oju2k6idndjaulfj@paasikivi.fi.intel.com>
In-Reply-To: <20190326135439.oju2k6idndjaulfj@paasikivi.fi.intel.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.75.127.51]
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <C8B8D80E8F814745BEDEC1ADB4FEDAD8@st.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-03-26_10:,,
 signatures=0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Sakari,

On 3/26/19 14:54, Sakari Ailus wrote:
> Hi Mickael,
> 
> On Tue, Mar 26, 2019 at 12:57:03PM +0000, Mickael GUENE wrote:
> ...
>>>> +static int mipid02_set_fmt(struct v4l2_subdev *sd,
>>>> +			   struct v4l2_subdev_pad_config *cfg,
>>>> +			   struct v4l2_subdev_format *format)
>>>> +{
>>>> +	struct v4l2_mbus_framefmt *mbus_fmt = &format->format;
>>>> +	struct mipid02_dev *bridge = to_mipid02_dev(sd);
>>>> +	struct i2c_client *client = bridge->i2c_client;
>>>> +	struct v4l2_mbus_framefmt *fmt;
>>>> +	int ret;
>>>> +
>>>> +	dev_dbg(&client->dev, "%s for %d", __func__, format->pad);
>>>> +
>>>> +	if (format->pad >= MIPID02_PAD_NB)
>>>> +		return -EINVAL;
>>>> +	/* second CSI-2 pad not yet supported */
>>>> +	if (format->pad == 1)
>>>> +		return -EINVAL;
>>>> +
>>>> +	mutex_lock(&bridge->lock);
>>>> +
>>>> +	if (bridge->streaming) {
>>>> +		ret = -EBUSY;
>>>> +		goto error;
>>>> +	}
>>>> +
>>>> +	if (format->which == V4L2_SUBDEV_FORMAT_TRY)
>>>> +		fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
>>>> +	else
>>>> +		fmt = &bridge->fmt;
>>>> +
>>>> +	*fmt = *mbus_fmt;
>>>
>>> What are the limits of the hardware regarding the size of the image? Aren't
>>> there any?
>>>
>> There are no limits for image size.
>>> The format on the sink pad needs to be propagated to the source pad as
>>> well. I presume there's nothing to set on the sink pad for this device, is
>>> there?
>>  User only need to set format code so the driver can configure hardware.
>>  In the mipid02 we have always the same format for sink and source. So I
>>  only store one configuration during set_fmt when called from either pad0
>> (sink) or pad2 (source). Is it the correct way to implement it ? or
>> should I only accept set_fmt on pad0 ?
>>  For get_fmt I return stored configuration for pad0 and pad2.
> 
> Only 76 or so characters per line, please.
> 
> For pad 0 (sink) the format must be settable freely (as you don't have any
> hardware restrictions) and on the pad 2 (source) the driver converts the
> format set on the pad 0 according to the hardware functionality. This is
> what the link validation from the source pad onwards is based on.
> 
 So for a set_fmt on pad 2 I return current configuration ? (as
in my case I have the same configuration for pad 0 and pad2)
 And I only update format when set_fmt is called for pad 0 ?

Thanks for your help

Rgs
Mickael
