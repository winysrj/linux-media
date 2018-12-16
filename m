Return-Path: <SRS0=vP0A=OZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 921B7C43387
	for <linux-media@archiver.kernel.org>; Sun, 16 Dec 2018 21:47:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61BEB206BA
	for <linux-media@archiver.kernel.org>; Sun, 16 Dec 2018 21:47:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730943AbeLPVrx convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Sun, 16 Dec 2018 16:47:53 -0500
Received: from mail-oln040092066046.outbound.protection.outlook.com ([40.92.66.46]:42550
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727256AbeLPVrx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Dec 2018 16:47:53 -0500
Received: from HE1EUR01FT048.eop-EUR01.prod.protection.outlook.com
 (10.152.0.60) by HE1EUR01HT179.eop-EUR01.prod.protection.outlook.com
 (10.152.1.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1446.11; Sun, 16 Dec
 2018 21:47:49 +0000
Received: from AM0PR03MB4676.eurprd03.prod.outlook.com (10.152.0.54) by
 HE1EUR01FT048.mail.protection.outlook.com (10.152.1.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1446.11 via Frontend Transport; Sun, 16 Dec 2018 21:47:49 +0000
Received: from AM0PR03MB4676.eurprd03.prod.outlook.com
 ([fe80::f02a:2a6f:1b3b:ee3e]) by AM0PR03MB4676.eurprd03.prod.outlook.com
 ([fe80::f02a:2a6f:1b3b:ee3e%4]) with mapi id 15.20.1425.021; Sun, 16 Dec 2018
 21:47:49 +0000
From:   Jonas Karlman <jonas@kwiboo.se>
To:     "hverkuil-cisco@xs4all.nl" <hverkuil-cisco@xs4all.nl>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC:     Alexandre Courbot <acourbot@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>
Subject: Re: [PATCHv5 5/8] videodev2.h: add v4l2_timeval_to_ns inline function
Thread-Topic: [PATCHv5 5/8] videodev2.h: add v4l2_timeval_to_ns inline
 function
Thread-Index: AQHUkhes5bjxk1PbeEGB4X8SqX/SHaWB7iSA
Date:   Sun, 16 Dec 2018 21:47:48 +0000
Message-ID: <AM0PR03MB4676BB01D8793B9F8B7763D4ACA30@AM0PR03MB4676.eurprd03.prod.outlook.com>
References: <20181212123901.34109-1-hverkuil-cisco@xs4all.nl>
 <20181212123901.34109-6-hverkuil-cisco@xs4all.nl>
In-Reply-To: <20181212123901.34109-6-hverkuil-cisco@xs4all.nl>
Accept-Language: sv-SE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1P190CA0025.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:52::14)
 To AM0PR03MB4676.eurprd03.prod.outlook.com (2603:10a6:208:cc::33)
x-incomingtopheadermarker: OriginalChecksum:2A909DC114F969A425EAD2675BDF6A42401EF63F2958592E83E7EC7AF0F20DB5;UpperCasedChecksum:34F5FAF4D199A6923F07473E0950B9CE15BB92534A4386B7139255E395151622;SizeAsReceived:7805;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [mz3NweQrbGu9o9bhRyWY8wsASmlEY1+e]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;HE1EUR01HT179;6:Nw417/iKPA5bTFqteHnHPoUOedhULA8fjhIlLzGJ4LDdD+fOHggZo61nhDvyP7TlGvRw8XFUcZlhN+siizTNYfWzLwOkFZbsKp3QJN9rLwvojxc4xQhdvVEEWYSMWxqav5YP/4ZkSNsTMaeeIOD0c6SL0GH7AGxgQjebXijBOePVRgmiqMhnzA6FXChJMiL18O4k1d0EXVFkZ27I2UM3Zs2bsyB0HgOoU8uOf8Md+9JnL0fPfkQgwwHWPvZ0kvNd1T2lt5saARs38CgsMQnOgW7b26BpCfFFY4Ap9AeIf4trBHnZAdPBfnNTUegoMRkwyq6ckmHZXfy9m0TXCieMjZ5fOy+/oMNueiCWhOjxitGd5o2iEUgChiYmbQVxkp5svbOpAORXDFyQ6OEjWP7HXWyg19V94ZaI8n21jcjPdPLMM1aLRqIJ3bfPrB7NbxnD0S0Xe/O8Bdd3rrzVj3uZGA==;5:Q/zM1hP4/kR0JyyeOrkxuW33R0wrJD/mpRJQur9gTFUegfS/CUH1zKm+AtalkMSlAkmOqDJwde5vPBSyGwYW7HLGShvjjZvFBumVssae6VHk0kAoobKiuBSoqMLL7YE4qPy2HoYPDee73OgsGIK5eyHv+JYqIdYYkvS/hTtVfXE=;7:tISiEHSBPRBP8ks6sTL6EVB3susquIaQz+16CIkILbkxCOWPF4bf4cY2v01YIHUeLSmn7NdEgFBQ1aqMAEG3a1zno0u6T4WNAfOlqP3MkZ4EX7IKQ8whoGYMTP+QoQ1ewLqZS6vh3OlxbqFfZYkBLQ==
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(201702061078)(5061506573)(5061507331)(1603103135)(2017031320274)(2017031323274)(2017031324274)(2017031322404)(1601125500)(1603101475)(1701031045);SRVR:HE1EUR01HT179;
x-ms-traffictypediagnostic: HE1EUR01HT179:
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(4566010)(82015058);SRVR:HE1EUR01HT179;BCL:0;PCL:0;RULEID:;SRVR:HE1EUR01HT179;
x-microsoft-antispam-message-info: UAnxHvfqVjtlFhmyEgTIU7xL4wsbykHE7KNF0pdBLyOa1pUcTpcRCiTLDNFrcL+e
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <9AB7966A310A544AB2C92A18ACCF98C6@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 54485d23-c432-40fe-8436-6091d627118c
X-MS-Exchange-CrossTenant-Network-Message-Id: e0dd6561-72cf-4f1c-edb4-08d663a01f02
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 54485d23-c432-40fe-8436-6091d627118c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2018 21:47:48.9819
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1EUR01HT179
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


On 2018-12-12 13:38, hverkuil-cisco@xs4all.nl wrote:
> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>
> We want to be able to uniquely identify buffers for stateless
> codecs. The internal timestamp (a u64) as stored internally in the
> kernel is a suitable candidate for that, but in struct v4l2_buffer
> it is represented as a struct timeval.
>
> Add a v4l2_timeval_to_ns() function that converts the struct timeval
> into a u64 in the same way that the kernel does. This makes it possible
> to use this u64 elsewhere as a unique identifier of the buffer.
>
> Since timestamps are also copied from the output buffer to the
> corresponding capture buffer(s) by M2M devices, the u64 can be
> used to refer to both output and capture buffers.
>
> The plan is that in the future we redesign struct v4l2_buffer and use
> u64 for the timestamp instead of a struct timeval (which has lots of
> problems with 32 vs 64 bit and y2038 layout changes), and then there
> is no more need to use this function.
>
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> ---
>  include/uapi/linux/videodev2.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 2db1635de956..3580c1ea4fba 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -971,6 +971,18 @@ struct v4l2_buffer {
>  	};
>  };
>  
> +/**
> + * v4l2_timeval_to_ns - Convert timeval to nanoseconds
> + * @ts:		pointer to the timeval variable to be converted
> + *
> + * Returns the scalar nanosecond representation of the timeval
> + * parameter.
> + */
> +static inline u64 v4l2_timeval_to_ns(const struct timeval *tv)
> +{
> +	return (__u64)tv->tv_sec * 1000000000ULL + tv->tv_usec * 1000;
> +}
This is causing a compile issue in userspace application, replacing u64
with __u64 solves the compile issue below.

In file included from libavcodec/v4l2_request.h:22,
                 from libavcodec/v4l2_request.c:28:
/home/docker/LibreELEC/build.LibreELEC-H3.arm-9.0-devel/toolchain/armv7ve-libreelec-linux-gnueabi/sysroot/usr/include/linux/videodev2.h:975:19:
error: unknown type name 'u64'
 static __inline__ u64 v4l2_timeval_to_ns(const struct timeval *tv)
                   ^~~

Regards,
Jonas
> +
>  /*  Flags for 'flags' field */
>  /* Buffer is mapped (flag) */
>  #define V4L2_BUF_FLAG_MAPPED			0x00000001
