Return-Path: <SRS0=8Y7M=QS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C8EBC169C4
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 10:48:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EFFF20863
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 10:48:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="WNhfxihI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbfBKKs2 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Feb 2019 05:48:28 -0500
Received: from rcdn-iport-4.cisco.com ([173.37.86.75]:20863 "EHLO
        rcdn-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726914AbfBKKs2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Feb 2019 05:48:28 -0500
X-Greylist: delayed 572 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Feb 2019 05:48:27 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1566; q=dns/txt; s=iport;
  t=1549882107; x=1551091707;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Yjaet96agtBDFV0rdr3iPLaMDx/7V0zcF1VNSs0/h8k=;
  b=WNhfxihIIIuui08Bs1HFreFMGbJdTGgtRenFsph/RnkGNXSDoER+YMPS
   kETdv+JLYJlMmIHt2pQT3572HCP/3Ei5CfnQ15AMTyPMKz/fXVLypUCGe
   8JoPttKSgp3JS403AzFWps3GK1h4uCncdMHFblBciVcxESWgnR3AMQTRm
   U=;
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0AEAABnUGFc/5BdJa1jGgEBAQEBAgE?=
 =?us-ascii?q?BAQEHAgEBAQGBUQUBAQEBCwGCA4FqJwqMFIttgg2CYYZJjmmBewsBAYRsgz0?=
 =?us-ascii?q?iNAkNAQMBAQIBAQJtKIVLAQUnEzQLEAIBCA4KHhAyJQIEAQ0FCIUGAxWqJTO?=
 =?us-ascii?q?KJ4xDF4FAP4QjgleCKoVgAoltmH8zCQKPFIMyIYFthUuLKIozhmmKeQIRFIE?=
 =?us-ascii?q?nHziBVnAVgyeCKBeOHkExi0OBHwEB?=
X-IronPort-AV: E=Sophos;i="5.58,358,1544486400"; 
   d="scan'208";a="515938707"
Received: from rcdn-core-8.cisco.com ([173.37.93.144])
  by rcdn-iport-4.cisco.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Feb 2019 10:38:54 +0000
Received: from XCH-ALN-015.cisco.com (xch-aln-015.cisco.com [173.36.7.25])
        by rcdn-core-8.cisco.com (8.15.2/8.15.2) with ESMTPS id x1BAcsjq016723
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Mon, 11 Feb 2019 10:38:54 GMT
Received: from xch-aln-012.cisco.com (173.36.7.22) by XCH-ALN-015.cisco.com
 (173.36.7.25) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 11 Feb
 2019 04:38:54 -0600
Received: from xch-aln-012.cisco.com ([173.36.7.22]) by XCH-ALN-012.cisco.com
 ([173.36.7.22]) with mapi id 15.00.1395.000; Mon, 11 Feb 2019 04:38:53 -0600
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
Date:   Mon, 11 Feb 2019 10:38:53 +0000
Message-ID: <3ed515b78a404ec4a22b5f69ed9d6e28@XCH-ALN-012.cisco.com>
References: <HK0PR02MB363461179B3A702DB9CAEC55B26A0@HK0PR02MB3634.apcprd02.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.61.175.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Outbound-SMTP-Client: 173.36.7.25, xch-aln-015.cisco.com
X-Outbound-Node: rcdn-core-8.cisco.com
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 09/02/2019 03:48, Wen Yang wrote:=0A=
> put_device() should be called in cec_notifier_release(),=0A=
> since the dev is being passed down to cec_notifier_get_conn(),=0A=
> which holds reference. On cec_notifier destruction, it=0A=
> should drop the reference to the device.=0A=
> =0A=
> Fixes: 6917a7b77413 ("[media] media: add CEC notifier support")=0A=
> Signed-off-by: Wen Yang <yellowriver2010@hotmail.com>=0A=
> ---=0A=
>  drivers/media/cec/cec-notifier.c | 1 +=0A=
>  1 file changed, 1 insertion(+)=0A=
> =0A=
> diff --git a/drivers/media/cec/cec-notifier.c b/drivers/media/cec/cec-not=
ifier.c=0A=
> index dd2078b..621d4ae 100644=0A=
> --- a/drivers/media/cec/cec-notifier.c=0A=
> +++ b/drivers/media/cec/cec-notifier.c=0A=
> @@ -66,6 +66,7 @@ static void cec_notifier_release(struct kref *kref)=0A=
>  		container_of(kref, struct cec_notifier, kref);=0A=
>  =0A=
>  	list_del(&n->head);=0A=
> +	put_device(n->dev);=0A=
>  	kfree(n->conn);=0A=
>  	kfree(n);=0A=
>  }=0A=
> =0A=
=0A=
Sorry, no. The dev pointer is just a search key that the notifier code look=
s=0A=
for. It is not the notifier's responsibility to take a reference, that woul=
d=0A=
be the responsibility of the hdmi and cec drivers.=0A=
=0A=
If you can demonstrate that there is an object reference leak, then please=
=0A=
provide the details: it is likely a bug elsewhere and not in the notifier=
=0A=
code.=0A=
=0A=
BTW, your patch series didn't arrive on the linux-media mailinglist for=0A=
some reason.=0A=
=0A=
Regards,=0A=
=0A=
	Hans=0A=
