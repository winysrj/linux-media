Return-Path: <SRS0=vX6K=RV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E820C43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 09:09:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27BED20854
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 09:09:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfCRJJb convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Mar 2019 05:09:31 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:58425 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726835AbfCRJJ1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Mar 2019 05:09:27 -0400
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x2I997ux007855;
        Mon, 18 Mar 2019 10:09:18 +0100
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2r8rwjtj97-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Mon, 18 Mar 2019 10:09:17 +0100
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 2A8594A;
        Mon, 18 Mar 2019 09:08:58 +0000 (GMT)
Received: from Webmail-eu.st.com (sfhdag5node1.st.com [10.75.127.13])
        by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id D82C8287B;
        Mon, 18 Mar 2019 09:08:57 +0000 (GMT)
Received: from SFHDAG5NODE3.st.com (10.75.127.15) by SFHDAG5NODE1.st.com
 (10.75.127.13) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Mon, 18 Mar
 2019 10:08:57 +0100
Received: from SFHDAG5NODE3.st.com ([fe80::7c09:5d6b:d2c7:5f47]) by
 SFHDAG5NODE3.st.com ([fe80::7c09:5d6b:d2c7:5f47%20]) with mapi id
 15.00.1347.000; Mon, 18 Mar 2019 10:08:57 +0100
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
Thread-Index: AQHU2J8pWVpVm9MlqUmPoDIPHA9N66YOwYKAgAJFpQCAAAWJgIAABbcA
Date:   Mon, 18 Mar 2019 09:08:57 +0000
Message-ID: <a8dff925-3ec4-3a40-f129-ea162ca25aed@st.com>
References: <1552373045-134493-1-git-send-email-mickael.guene@st.com>
 <1552373045-134493-2-git-send-email-mickael.guene@st.com>
 <20190316214649.co63p5arhiwbuv3g@valkosipuli.retiisi.org.uk>
 <b238948a-4b08-4fb8-c955-d071bbcd3d2d@st.com>
 <20190318084825.3hpejk5xg2xt2h4b@valkosipuli.retiisi.org.uk>
In-Reply-To: <20190318084825.3hpejk5xg2xt2h4b@valkosipuli.retiisi.org.uk>
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
Content-ID: <618E78B5CF9334458B50EFA417AA7D80@st.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-03-18_07:,,
 signatures=0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Sakari,

>>>> +
>>>> +Example:
>>>> +
>>>> +mipid02: mipid02@14 {
>>>
>>> The node should be a generic name. "csi2rx" is used by a few devices now.
>>>
>>  If I understand you well, you would prefer:
>> csi2rx: mipid02@14 {
>>  I show no usage of csi2rx node naming except for MIPI-CSI2 RX controller.
> 
> The other way around. :)
> 
> The label can be more or less anything AFAIK.
> 
 Ok got it !!! So something like 'mipid02: bridge@14 {' should be ok ?

Thx
