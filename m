Return-Path: <SRS0=8Y7M=QS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDDFAC282CE
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 10:57:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9949120873
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 10:57:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="XmomXnVb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbfBKK5e (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Feb 2019 05:57:34 -0500
Received: from rcdn-iport-9.cisco.com ([173.37.86.80]:62795 "EHLO
        rcdn-iport-9.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbfBKK5e (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Feb 2019 05:57:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2101; q=dns/txt; s=iport;
  t=1549882653; x=1551092253;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=PKp+vBW5YhtnRUcOkZqPKgkvgwkJlZrR50D/cnSJiJ0=;
  b=XmomXnVbF84BfbscScuWFZJF0PvF83pmZxloEQUA/Sajm9wepWy51EYL
   t7HP3J4vGpiK8X/k/8Qrpz/Z6QPf5dTG9tFvEzoMlVciAzKbyCyKeYWk+
   99UkxVkOBiicTVT9TLbzqe8gc1ynKHzR2P33suwUw9G7RlZB5by8ow6rM
   A=;
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0AEAAA8VGFc/5pdJa1jGgEBAQEBAgE?=
 =?us-ascii?q?BAQEHAgEBAQGBUQUBAQEBCwGCA4FqJwqMFIttgg2CYYZJjmmBewsBAYRsgz0?=
 =?us-ascii?q?iNAkNAQMBAQIBAQJtKIVKAQEBAQIBJxM0CxACAQgOCh4QMiUCBAENBQiFBgM?=
 =?us-ascii?q?NCKofM4onjEMXgUA/hCOCV4IqhWACiW2YfzMJAo8UgzIhgW2FS4soijOGaYp?=
 =?us-ascii?q?5AhEUgScfOIFWcBU7gmyCKBeOHkExi0OBHwEB?=
X-IronPort-AV: E=Sophos;i="5.58,358,1544486400"; 
   d="scan'208";a="431355291"
Received: from rcdn-core-3.cisco.com ([173.37.93.154])
  by rcdn-iport-9.cisco.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Feb 2019 10:57:32 +0000
Received: from XCH-ALN-012.cisco.com (xch-aln-012.cisco.com [173.36.7.22])
        by rcdn-core-3.cisco.com (8.15.2/8.15.2) with ESMTPS id x1BAvWCJ028142
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Mon, 11 Feb 2019 10:57:32 GMT
Received: from xch-aln-012.cisco.com (173.36.7.22) by XCH-ALN-012.cisco.com
 (173.36.7.22) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 11 Feb
 2019 04:57:31 -0600
Received: from xch-aln-012.cisco.com ([173.36.7.22]) by XCH-ALN-012.cisco.com
 ([173.36.7.22]) with mapi id 15.00.1395.000; Mon, 11 Feb 2019 04:57:31 -0600
From:   "Hans Verkuil (hansverk)" <hansverk@cisco.com>
To:     Wen Yang <yellowriver2010@hotmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] media: cec-notifier: fix possible object reference
 leak
Thread-Topic: [PATCH 1/4] media: cec-notifier: fix possible object reference
 leak
Thread-Index: AQHUwCH951ryS7AxYU2IkMLJINPqbQ==
Date:   Mon, 11 Feb 2019 10:57:31 +0000
Message-ID: <6b7fc837599e4069b876b32473b31746@XCH-ALN-012.cisco.com>
References: <HK0PR02MB363461179B3A702DB9CAEC55B26A0@HK0PR02MB3634.apcprd02.prod.outlook.com>
 <3ed515b78a404ec4a22b5f69ed9d6e28@XCH-ALN-012.cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.61.175.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Outbound-SMTP-Client: 173.36.7.22, xch-aln-012.cisco.com
X-Outbound-Node: rcdn-core-3.cisco.com
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 11/02/2019 11:38, Hans Verkuil (hansverk) wrote:=0A=
> On 09/02/2019 03:48, Wen Yang wrote:=0A=
>> put_device() should be called in cec_notifier_release(),=0A=
>> since the dev is being passed down to cec_notifier_get_conn(),=0A=
>> which holds reference. On cec_notifier destruction, it=0A=
>> should drop the reference to the device.=0A=
>>=0A=
>> Fixes: 6917a7b77413 ("[media] media: add CEC notifier support")=0A=
>> Signed-off-by: Wen Yang <yellowriver2010@hotmail.com>=0A=
>> ---=0A=
>>  drivers/media/cec/cec-notifier.c | 1 +=0A=
>>  1 file changed, 1 insertion(+)=0A=
>>=0A=
>> diff --git a/drivers/media/cec/cec-notifier.c b/drivers/media/cec/cec-no=
tifier.c=0A=
>> index dd2078b..621d4ae 100644=0A=
>> --- a/drivers/media/cec/cec-notifier.c=0A=
>> +++ b/drivers/media/cec/cec-notifier.c=0A=
>> @@ -66,6 +66,7 @@ static void cec_notifier_release(struct kref *kref)=0A=
>>  		container_of(kref, struct cec_notifier, kref);=0A=
>>  =0A=
>>  	list_del(&n->head);=0A=
>> +	put_device(n->dev);=0A=
>>  	kfree(n->conn);=0A=
>>  	kfree(n);=0A=
>>  }=0A=
>>=0A=
> =0A=
> Sorry, no. The dev pointer is just a search key that the notifier code lo=
oks=0A=
> for. It is not the notifier's responsibility to take a reference, that wo=
uld=0A=
> be the responsibility of the hdmi and cec drivers.=0A=
=0A=
Correction: the cec driver should never take a reference of the hdmi device=
.=0A=
It never accesses the HDMI device, it only needs the HDMI device pointer as=
=0A=
a key in the notifier list.=0A=
=0A=
The real problem is that several CEC drivers take a reference of the HDMI d=
evice=0A=
and never release it. So those drivers need to be fixed.=0A=
=0A=
Regards,=0A=
=0A=
	Hans=0A=
=0A=
> =0A=
> If you can demonstrate that there is an object reference leak, then pleas=
e=0A=
> provide the details: it is likely a bug elsewhere and not in the notifier=
=0A=
> code.=0A=
> =0A=
> BTW, your patch series didn't arrive on the linux-media mailinglist for=
=0A=
> some reason.=0A=
> =0A=
> Regards,=0A=
> =0A=
> 	Hans=0A=
> =0A=
=0A=
