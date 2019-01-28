Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A23CC282CF
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 11:56:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A3712086C
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 11:56:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="njBmRco8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfA1L4O (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 06:56:14 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:36586 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726611AbfA1L4O (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 06:56:14 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0SBrTlF055124;
        Mon, 28 Jan 2019 11:55:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=ENRfTUMKlcWc9Se6/czafUBFgumrLSybhg8HVa7DJkc=;
 b=njBmRco8EXcPkH2o7Ta47BqSxkB/QHxNusmCm9J9PSYNrRcKMGFlbvH8a/FGKFeZEKVJ
 wtjyeRDasi/lz7G7FyLng+o6s4WgyFT3azzKRkeOsc3EhEbLcFIAjS4FrOLtFPpPt/A3
 vCSiVyk5P1aqzm8nwqLlWVEvJoY2i5aufRZODwuW4Ou2F55+WaZ5/2Yjq1yI24gAzM+6
 Kre2eIlyDl36bHVRoAwjNIf9VTm8JTQ4V0DGPI3dD6Wn+Cu+5kpy7kEvmwiJLDi0Wi/p
 1i0Ahb8+ov8GaDLhosVenolzM5TsnlmXLcHCY/pLdSSsHEPA4zSCFBJCyT+mH/BUFPHX 9Q== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2q8eyu5nfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Jan 2019 11:55:08 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x0SBt2Kj022757
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Jan 2019 11:55:02 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x0SBt2qs022852;
        Mon, 28 Jan 2019 11:55:02 GMT
Received: from kadam (/197.157.34.178)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Jan 2019 03:55:01 -0800
Date:   Mon, 28 Jan 2019 14:54:50 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Prashantha SP <prashanth.sp98@gmail.com>
Cc:     sakari.ailus@linux.intel.com, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        mchehab@kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 3/3] Staging: media: ipu3: fixed max charecter style issue
Message-ID: <20190128115450.GF1795@kadam>
References: <20190127165416.13287-1-prashanth.sp98@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190127165416.13287-1-prashanth.sp98@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9149 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901280097
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Sun, Jan 27, 2019 at 10:24:16PM +0530, Prashantha SP wrote:
> fixed coding style issue.
> 
> Signed-off-by: Prashantha SP <prashanth.sp98@gmail.com>
                            ^^

Please use your full name that you would use to sign legal documents.

> ---
>  drivers/staging/media/ipu3/ipu3-css.c | 178 ++++++++++++++------------
>  1 file changed, 94 insertions(+), 84 deletions(-)
> 
> diff --git a/drivers/staging/media/ipu3/ipu3-css.c b/drivers/staging/media/ipu3/ipu3-css.c
> index 44c55639389a..466a1a8cc422 100644
> --- a/drivers/staging/media/ipu3/ipu3-css.c
> +++ b/drivers/staging/media/ipu3/ipu3-css.c
> @@ -186,7 +186,8 @@ static bool ipu3_css_queue_enabled(struct ipu3_css_queue *q)
>  /******************* css hw *******************/
>  
>  /* In the style of writesl() defined in include/asm-generic/io.h */
> -static inline void writes(const void *mem, ssize_t count, void __iomem *addr)
> +static inline void writes(const void *mem, ssize_t count,
> +			  void __iomem *addr)
>  {
>  	if (count >= 4) {
>  		const u32 *buf = mem;
> @@ -671,8 +672,9 @@ static void ipu3_css_pipeline_cleanup(struct ipu3_css *css, unsigned int pipe)
>  	ipu3_css_pool_cleanup(imgu, &css->pipes[pipe].pool.obgrid);
>  
>  	for (i = 0; i < IMGU_ABI_NUM_MEMORIES; i++)
> -		ipu3_css_pool_cleanup(imgu,
> -				      &css->pipes[pipe].pool.binary_params_p[i]);
> +		ipu3_css_pool_cleanup
> +			(imgu,
> +			&css->pipes[pipe].pool.binary_params_p[i]);

The original is better.

regards,
dan carpenter

