Return-Path: <SRS0=vX6K=RV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF34EC43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 10:01:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 878972070D
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 10:01:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbfCRKBU convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Mar 2019 06:01:20 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:6693 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727246AbfCRKBT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Mar 2019 06:01:19 -0400
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x2I9ugkL028540;
        Mon, 18 Mar 2019 11:01:05 +0100
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2r8q5b399x-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Mon, 18 Mar 2019 11:01:05 +0100
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id D8A5846;
        Mon, 18 Mar 2019 10:01:04 +0000 (GMT)
Received: from Webmail-eu.st.com (sfhdag5node1.st.com [10.75.127.13])
        by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 869F62A78;
        Mon, 18 Mar 2019 10:01:04 +0000 (GMT)
Received: from SFHDAG5NODE3.st.com (10.75.127.15) by SFHDAG5NODE1.st.com
 (10.75.127.13) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Mon, 18 Mar
 2019 11:01:04 +0100
Received: from SFHDAG5NODE3.st.com ([fe80::7c09:5d6b:d2c7:5f47]) by
 SFHDAG5NODE3.st.com ([fe80::7c09:5d6b:d2c7:5f47%20]) with mapi id
 15.00.1347.000; Mon, 18 Mar 2019 11:01:04 +0100
From:   Mickael GUENE <mickael.guene@st.com>
To:     Sakari Ailus <sakari.ailus@iki.fi>
CC:     "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        "Wolfram Sang" <wsa@the-dreams.de>,
        "David S. Miller" <davem@davemloft.net>,
        "Nicolas Ferre" <nicolas.ferre@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 3/3] media: MAINTAINERS: add entry for
 STMicroelectronics MIPID02 media driver
Thread-Topic: [PATCH v1 3/3] media: MAINTAINERS: add entry for
 STMicroelectronics MIPID02 media driver
Thread-Index: AQHU2J88IeZOwXdC6EqO9OUXU8uOUKYOwcEAgAJfOoA=
Date:   Mon, 18 Mar 2019 10:01:04 +0000
Message-ID: <0b558809-07ec-5330-cb75-351b5abd3c66@st.com>
References: <1552373045-134493-1-git-send-email-mickael.guene@st.com>
 <1552373045-134493-4-git-send-email-mickael.guene@st.com>
 <20190316214742.64wxxracq6giv3kk@valkosipuli.retiisi.org.uk>
In-Reply-To: <20190316214742.64wxxracq6giv3kk@valkosipuli.retiisi.org.uk>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.75.127.50]
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <EB86C05A335EBF4DA4960789D34DCCA7@st.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-03-18_07:,,
 signatures=0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Sakari,

On 3/16/19 22:47, Sakari Ailus wrote:
> On Tue, Mar 12, 2019 at 07:44:05AM +0100, Mickael Guene wrote:
>> Add maintainer entry for the STMicroelectronics MIPID02 CSI-2 to PARALLEL
>> bridge driver and dt-bindings.
>>
>> Signed-off-by: Mickael Guene <mickael.guene@st.com>
>> ---
>>
>>  MAINTAINERS | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 1c6ecae..4bd36b1 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -14424,6 +14424,14 @@ S:	Maintained
>>  F:	drivers/iio/imu/st_lsm6dsx/
>>  F:	Documentation/devicetree/bindings/iio/imu/st_lsm6dsx.txt
>>  
>> +ST MIPID02 CSI-2 TO PARALLEL BRIDGE DRIVER
>> +M:	Mickael Guene <mickael.guene@st.com>
>> +L:	linux-media@vger.kernel.org
>> +T:	git git://linuxtv.org/media_tree.git
>> +S:	Maintained
>> +F:	drivers/media/i2c/st-mipid02.c
>> +F:	Documentation/devicetree/bindings/media/i2c/st,st-mipid02.txt
> 
> Could you squash this to the first patch, so that there are no files added
> without them being listed here?
> 
 Ok for the v2 I will squash it with dt-bindings documentation patch.
