Return-Path: <SRS0=7BPv=R5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22735C43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 12:32:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F07422075E
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 12:32:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731519AbfCZMck convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Mar 2019 08:32:40 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:58005 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726307AbfCZMck (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Mar 2019 08:32:40 -0400
Received: from pps.filterd (m0046037.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x2QCLkFv018781;
        Tue, 26 Mar 2019 13:32:12 +0100
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2rddh7hf8t-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 26 Mar 2019 13:32:12 +0100
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id ADB4C38;
        Tue, 26 Mar 2019 12:32:11 +0000 (GMT)
Received: from Webmail-eu.st.com (sfhdag5node3.st.com [10.75.127.15])
        by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 70DD5579A;
        Tue, 26 Mar 2019 12:32:11 +0000 (GMT)
Received: from SFHDAG5NODE3.st.com (10.75.127.15) by SFHDAG5NODE3.st.com
 (10.75.127.15) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Tue, 26 Mar
 2019 13:32:11 +0100
Received: from SFHDAG5NODE3.st.com ([fe80::7c09:5d6b:d2c7:5f47]) by
 SFHDAG5NODE3.st.com ([fe80::7c09:5d6b:d2c7:5f47%20]) with mapi id
 15.00.1347.000; Tue, 26 Mar 2019 13:32:11 +0100
From:   Mickael GUENE <mickael.guene@st.com>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
CC:     "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "Hugues FRUCHET" <hugues.fruchet@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
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
Subject: Re: [PATCH v2 2/2] media:st-mipid02: MIPID02 CSI-2 to PARALLEL bridge
 driver
Thread-Topic: [PATCH v2 2/2] media:st-mipid02: MIPID02 CSI-2 to PARALLEL
 bridge driver
Thread-Index: AQHU4uAlvGbuxz1KVk27cUbYXXfNhaYcKbSAgAAKjACAAYUEgIAAEBSA
Date:   Tue, 26 Mar 2019 12:32:11 +0000
Message-ID: <231c710f-5a16-29bb-020c-644d88063f53@st.com>
References: <1552373045-134493-1-git-send-email-mickael.guene@st.com>
 <1553500510-153260-1-git-send-email-mickael.guene@st.com>
 <1553500510-153260-3-git-send-email-mickael.guene@st.com>
 <20190325114430.zot5tbiczqrhpskl@kekkonen.localdomain>
 <eaf82024-1f65-a1e3-8410-49209b5414aa@st.com>
 <20190326113437.bpebmfs7mipsg24y@paasikivi.fi.intel.com>
In-Reply-To: <20190326113437.bpebmfs7mipsg24y@paasikivi.fi.intel.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.75.127.47]
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <1073218CE527574D96DF8B0C8BB66382@st.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-03-26_09:,,
 signatures=0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sakari,

On 3/26/19 12:34, Sakari Ailus wrote:
> Hi Mickael,
> 
> On Mon, Mar 25, 2019 at 12:22:17PM +0000, Mickael GUENE wrote:
> ...
>>>> +	/* register it for later use */
>>>> +	bridge->rx = ep;
>>>> +	bridge->rx.link_frequencies = ep.nr_of_link_frequencies == 1 ?
>>>> +		&bridge->link_frequency : NULL;
>>>
>>> I think you need to simply ignore the link frequencies here. The
>>> transmitting device can tell the frequency based on its configuration
>>> (based on the link frequencies). You seem to have implemented that already.
>>>
>>  Idea of this was to allow some support for sensor that doesn't implement
>> V4L2_CID_PIXEL_RATE. Do you think it's useless ?
> 
> Sensor drivers need to be amended with support for that control.
> 
 Ok. I will drop mipid02_get_link_freq_from_rx_ep and mipid02_get_link_freq_from_cid_link_freq
and only use V4L2_CID_PIXEL_RATE to compute link speed.
