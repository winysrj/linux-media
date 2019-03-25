Return-Path: <SRS0=dbhF=R4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECED9C43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 12:14:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAA1320830
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 12:14:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731006AbfCYMO1 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Mar 2019 08:14:27 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:38892 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730789AbfCYMO1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Mar 2019 08:14:27 -0400
Received: from pps.filterd (m0046037.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x2PCB6LS027394;
        Mon, 25 Mar 2019 13:14:07 +0100
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2rddh7b4ru-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Mon, 25 Mar 2019 13:14:07 +0100
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id CCE913F;
        Mon, 25 Mar 2019 12:14:05 +0000 (GMT)
Received: from Webmail-eu.st.com (sfhdag5node3.st.com [10.75.127.15])
        by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 94C46556A;
        Mon, 25 Mar 2019 12:14:05 +0000 (GMT)
Received: from SFHDAG5NODE3.st.com (10.75.127.15) by SFHDAG5NODE3.st.com
 (10.75.127.15) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Mon, 25 Mar
 2019 13:14:05 +0100
Received: from SFHDAG5NODE3.st.com ([fe80::7c09:5d6b:d2c7:5f47]) by
 SFHDAG5NODE3.st.com ([fe80::7c09:5d6b:d2c7:5f47%20]) with mapi id
 15.00.1347.000; Mon, 25 Mar 2019 13:14:05 +0100
From:   Mickael GUENE <mickael.guene@st.com>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
CC:     Sakari Ailus <sakari.ailus@iki.fi>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ben Kao <ben.kao@intel.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Rui Miguel Silva <rui.silva@linaro.org>,
        "Akinobu Mita" <akinobu.mita@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        "Jason Chen" <jasonx.z.chen@intel.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Tianshu Qiu <tian.shu.qiu@intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>
Subject: Re: [PATCH v1 2/3] media:st-mipid02: MIPID02 CSI-2 to PARALLEL bridge
 driver
Thread-Topic: [PATCH v1 2/3] media:st-mipid02: MIPID02 CSI-2 to PARALLEL
 bridge driver
Thread-Index: AQHU2J8yZZpo/KT5AkiuZtoI6rx6VqYOyUaAgAJWyACACxavgIAAD7oA
Date:   Mon, 25 Mar 2019 12:14:05 +0000
Message-ID: <80f98c19-6045-9f7c-d549-f559ae8eb9d9@st.com>
References: <1552373045-134493-1-git-send-email-mickael.guene@st.com>
 <1552373045-134493-3-git-send-email-mickael.guene@st.com>
 <20190316221437.e3ukdpgyn2yq72tu@valkosipuli.retiisi.org.uk>
 <024de1c6-3e40-ac5a-586e-d9878947ff18@st.com>
 <20190325111746.h26isglf4d765mtg@kekkonen.localdomain>
In-Reply-To: <20190325111746.h26isglf4d765mtg@kekkonen.localdomain>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.75.127.48]
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <924C16E91719D345BE366DEDA323D9BE@st.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-03-25_08:,,
 signatures=0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sakari,

On 3/25/19 12:17, Sakari Ailus wrote:
> Hi Mickael,
> 
> On Mon, Mar 18, 2019 at 09:57:44AM +0000, Mickael GUENE wrote:
>> Hi Sakari,
>>
>> Thanks for your review. Find my comments below.
>>
>> On 3/16/19 23:14, Sakari Ailus wrote:
> ...
>>>> +static struct v4l2_subdev *mipid02_find_sensor(struct mipid02_dev *bridge)
>>>> +{
>>>> +	struct media_device *mdev = bridge->sd.v4l2_dev->mdev;
>>>> +	struct media_entity *entity;
>>>> +
>>>> +	if (!mdev)
>>>> +		return NULL;
>>>> +
>>>> +	media_device_for_each_entity(entity, mdev)
>>>> +		if (entity->function == MEDIA_ENT_F_CAM_SENSOR)
>>>> +			return media_entity_to_v4l2_subdev(entity);
>>>
>>> Hmm. Could you instead use the link state to determine which of the
>>> receivers is active? You'll need one more pad, and then you'd had 1:1
>>> mapping between ports and pads.
>>>
>>  Goal here is not to detect which of the receivers is active but to find
>> sensor in case there are others sub-dev in chain (for example a 
>> serializer/deserializer as found in cars).
> 
> You shouldn't make assumptions on the rest of the pipeline beyond the
> device that's directly connected. You might not even have a camera there.
> 
 I have also seen your answer to '[PATCH v2 2/2] media:st-mipid02: MIPID02 CSI-2 to PARALLEL bridge driver'
concerning support of set_fmt, get_fmt and link_validate.
 My initial idea was to avoid to avoid to implement them and to avoid media ctrl configuration. According
to your remark is seems a bad idea. Right ?
 In that case I have to also implement enum_mbus_code ?
 I will drop this code and use connected device only to get link speed.

>>  For the moment the driver doesn't support second input port usage,
>> this is why there is no such second sink pad yet in the driver.
> 
> Could you add the second sink pad now, so that the uAPI remains the same
> when you add support for it? Nothing is connected to it but I don't think
> it's an issue.
> 
> ...
> 
>>>> +
>>>> +	sensor = mipid02_find_sensor(bridge);
>>>> +	if (!sensor)
>>>> +		goto error;
>>>> +
>>>> +	dev_dbg(&client->dev, "use sensor '%s'", sensor->name);
>>>> +	memset(&bridge->r, 0, sizeof(bridge->r));
>>>> +	/* build registers content */
>>>> +	code = mipid02_get_source_code(bridge, sensor);
>>>> +	ret |= mipid02_configure_from_rx(bridge, code, sensor);
>>>> +	ret |= mipid02_configure_from_tx(bridge);
>>>> +	ret |= mipid02_configure_from_code(bridge, code);
>>>> +
>>>> +	/* write mipi registers */
>>>> +	ret |= mipid02_write_reg(bridge, MIPID02_CLK_LANE_REG1,
>>>> +		bridge->r.clk_lane_reg1);
>>>> +	ret |= mipid02_write_reg(bridge, MIPID02_CLK_LANE_REG3, CLK_MIPI_CSI);
>>>> +	ret |= mipid02_write_reg(bridge, MIPID02_DATA_LANE0_REG1,
>>>> +		bridge->r.data_lane0_reg1);
>>>> +	ret |= mipid02_write_reg(bridge, MIPID02_DATA_LANE0_REG2,
>>>> +		DATA_MIPI_CSI);
>>>> +	ret |= mipid02_write_reg(bridge, MIPID02_DATA_LANE1_REG1,
>>>> +		bridge->r.data_lane1_reg1);
>>>> +	ret |= mipid02_write_reg(bridge, MIPID02_DATA_LANE1_REG2,
>>>> +		DATA_MIPI_CSI);
>>>> +	ret |= mipid02_write_reg(bridge, MIPID02_MODE_REG1,
>>>> +		MODE_NO_BYPASS | bridge->r.mode_reg1);
>>>> +	ret |= mipid02_write_reg(bridge, MIPID02_MODE_REG2,
>>>> +		bridge->r.mode_reg2);
>>>> +	ret |= mipid02_write_reg(bridge, MIPID02_DATA_ID_RREG,
>>>> +		bridge->r.data_id_rreg);
>>>> +	ret |= mipid02_write_reg(bridge, MIPID02_DATA_SELECTION_CTRL,
>>>> +		SELECTION_MANUAL_DATA | SELECTION_MANUAL_WIDTH);
>>>> +	ret |= mipid02_write_reg(bridge, MIPID02_PIX_WIDTH_CTRL,
>>>> +		bridge->r.pix_width_ctrl);
>>>> +	ret |= mipid02_write_reg(bridge, MIPID02_PIX_WIDTH_CTRL_EMB,
>>>> +		bridge->r.pix_width_ctrl_emb);
>>>
>>> Be careful with the error codes. ret will be returned by the s_stream
>>> callback below.
>>>
>>  I didn't understand your remark. Can you elaborate a little bit more ?
> 
> If the functions return different error codes, then ret possibly won't be a
> valid error code, or at least it's not going to be what it was intended to
> do. You'll need to stop when you encounter an error and then return it to
> the caller.
> 
> ...
> 
Ok
>>>> +static int mipid02_parse_tx_ep(struct mipid02_dev *bridge)
>>>> +{
>>>> +	struct i2c_client *client = bridge->i2c_client;
>>>> +	struct v4l2_fwnode_endpoint ep;
>>>> +	struct device_node *ep_node;
>>>> +	int ret;
>>>> +
>>>> +	memset(&ep, 0, sizeof(ep));
>>>> +	ep.bus_type = V4L2_MBUS_PARALLEL;
>>>
>>> You can set the field in variable declaration, and omit memset. The same in
>>> the function above.
>>>
>> According to v4l2_fwnode_endpoint_parse() documentation:
>>  * This function parses the V4L2 fwnode endpoint specific parameters from the
>>  * firmware. The caller is responsible for assigning @vep.bus_type to a valid
>>  * media bus type. The caller may also set the default configuration for the
>>  * endpoint
>> It seems safer to clear ep else it may select unwanted default configuration
>> for the endpoint ?
> 
> By setting one of the fields in a struct in declaration, the rest will be
> zeroed by the compiler. That's from the C standard.
> 
Ok
