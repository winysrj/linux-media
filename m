Return-Path: <SRS0=7BPv=R5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 855B8C43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 12:07:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D4A12075E
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 12:07:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbfCZMH6 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Mar 2019 08:07:58 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:60397 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725776AbfCZMH6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Mar 2019 08:07:58 -0400
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x2QC122n026241;
        Tue, 26 Mar 2019 13:07:38 +0100
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2rf4ybvbj1-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 26 Mar 2019 13:07:38 +0100
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 6722B31;
        Tue, 26 Mar 2019 12:07:37 +0000 (GMT)
Received: from Webmail-eu.st.com (sfhdag5node2.st.com [10.75.127.14])
        by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 323AB56DD;
        Tue, 26 Mar 2019 12:07:37 +0000 (GMT)
Received: from SFHDAG5NODE3.st.com (10.75.127.15) by SFHDAG5NODE2.st.com
 (10.75.127.14) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Tue, 26 Mar
 2019 13:07:36 +0100
Received: from SFHDAG5NODE3.st.com ([fe80::7c09:5d6b:d2c7:5f47]) by
 SFHDAG5NODE3.st.com ([fe80::7c09:5d6b:d2c7:5f47%20]) with mapi id
 15.00.1347.000; Tue, 26 Mar 2019 13:07:36 +0100
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
Thread-Index: AQHU2J8yZZpo/KT5AkiuZtoI6rx6VqYOyUaAgAJWyACACxavgIAAD7oAgAGIGICAAAhuAA==
Date:   Tue, 26 Mar 2019 12:07:36 +0000
Message-ID: <2d278ffa-79f8-6497-448f-0f53f7bee6df@st.com>
References: <1552373045-134493-1-git-send-email-mickael.guene@st.com>
 <1552373045-134493-3-git-send-email-mickael.guene@st.com>
 <20190316221437.e3ukdpgyn2yq72tu@valkosipuli.retiisi.org.uk>
 <024de1c6-3e40-ac5a-586e-d9878947ff18@st.com>
 <20190325111746.h26isglf4d765mtg@kekkonen.localdomain>
 <80f98c19-6045-9f7c-d549-f559ae8eb9d9@st.com>
 <20190326113725.mx3ixvy4tunb44xw@paasikivi.fi.intel.com>
In-Reply-To: <20190326113725.mx3ixvy4tunb44xw@paasikivi.fi.intel.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.75.127.45]
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <FB88194B9317AD4CBCE7E72E0329ED5D@st.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-03-26_08:,,
 signatures=0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello Sakari,

On 3/26/19 12:37, Sakari Ailus wrote:
> On Mon, Mar 25, 2019 at 12:14:05PM +0000, Mickael GUENE wrote:
>> Hi Sakari,
>>
>> On 3/25/19 12:17, Sakari Ailus wrote:
>>> Hi Mickael,
>>>
>>> On Mon, Mar 18, 2019 at 09:57:44AM +0000, Mickael GUENE wrote:
>>>> Hi Sakari,
>>>>
>>>> Thanks for your review. Find my comments below.
>>>>
>>>> On 3/16/19 23:14, Sakari Ailus wrote:
>>> ...
>>>>>> +static struct v4l2_subdev *mipid02_find_sensor(struct mipid02_dev *bridge)
>>>>>> +{
>>>>>> +	struct media_device *mdev = bridge->sd.v4l2_dev->mdev;
>>>>>> +	struct media_entity *entity;
>>>>>> +
>>>>>> +	if (!mdev)
>>>>>> +		return NULL;
>>>>>> +
>>>>>> +	media_device_for_each_entity(entity, mdev)
>>>>>> +		if (entity->function == MEDIA_ENT_F_CAM_SENSOR)
>>>>>> +			return media_entity_to_v4l2_subdev(entity);
>>>>>
>>>>> Hmm. Could you instead use the link state to determine which of the
>>>>> receivers is active? You'll need one more pad, and then you'd had 1:1
>>>>> mapping between ports and pads.
>>>>>
>>>>  Goal here is not to detect which of the receivers is active but to find
>>>> sensor in case there are others sub-dev in chain (for example a 
>>>> serializer/deserializer as found in cars).
>>>
>>> You shouldn't make assumptions on the rest of the pipeline beyond the
>>> device that's directly connected. You might not even have a camera there.
>>>
>>  I have also seen your answer to '[PATCH v2 2/2] media:st-mipid02: MIPID02 CSI-2 to PARALLEL bridge driver'
>> concerning support of set_fmt, get_fmt and link_validate.
>>  My initial idea was to avoid to avoid to implement them and to avoid media ctrl configuration. According
>> to your remark is seems a bad idea. Right ?
> 
> Yes, you'll need them. This is how the media controller pipeline works: a
> driver for a given device is generally only aware of its direct links and
> generally only communicate with drivers for devices directly connected to
> them.
> 
>>  In that case I have to also implement enum_mbus_code ?
> 
> Yes, please.
> 
Ok I will add it in v4
>>  I will drop this code and use connected device only to get link speed.
> 
> Ack.
> 
