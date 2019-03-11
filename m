Return-Path: <SRS0=G3Vt=RO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B97D3C43381
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 14:08:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85F2820657
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 14:08:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="4qvycFoM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbfCKOIE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Mar 2019 10:08:04 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43464 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727444AbfCKOID (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Mar 2019 10:08:03 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2BDrS5A128444;
        Mon, 11 Mar 2019 14:07:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=iaNuEvg1hwrPvmjS6QIGXQiQZ748sgl43/mJY01kQ5A=;
 b=4qvycFoMt+HNL6zJCVJyR4HT88W3TagD5S9IRKzYD/AME9gXHejU+8igRsMKS+/n16GO
 1csLo314PZeMnXGiRt2fLwcT/rcLPqxJGb3B+i5UTWQIlM7G8orNtA1+86+C/kIO1+V8
 Zv9sJ6V8Redx0fO34pvZTIxLRAqP6KAeoqgZXOS8c5iK48R0CETLCeiJVNVPEZ2Ys6jZ
 ktbbo65OX287rHo/aQdRGUfVJnutQhzGY/qKyjk0bFGjwV0PEiVzozIyapmAzxK91VQ8
 utWqvACByWIcgtmieX3Zn5Ul/YdNNVcLlV5l0qIcoWICPb+/MY+NCdOIMfW84Xw+Cj5b cA== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2r44wtxmph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Mar 2019 14:07:48 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2BE7klb030242
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Mar 2019 14:07:47 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2BE7hGG012572;
        Mon, 11 Mar 2019 14:07:44 GMT
Received: from kadam (/197.157.34.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Mar 2019 07:07:43 -0700
Date:   Mon, 11 Mar 2019 17:07:33 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Mao Wenan <maowenan@huawei.com>
Cc:     gregkh@linuxfoundation.org, Julia.Lawall@lip6.fr,
        kimbrownkd@gmail.com, colin.king@canonical.com,
        hans.verkuil@cisco.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: davinci: drop pointless static qualifier in
 vpfe_resizer_init()
Message-ID: <20190311140733.GG2434@kadam>
References: <20190311141405.123611-1-maowenan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190311141405.123611-1-maowenan@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9191 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903110102
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Mar 11, 2019 at 10:14:05PM +0800, Mao Wenan wrote:
> There is no need to have the 'T *v' variable static
> since new value always be assigned before use it.
> 
> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> ---
>  drivers/staging/media/davinci_vpfe/dm365_resizer.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.c b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
> index 6098f43ac51b..a2a672d4615d 100644
> --- a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
> +++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
> @@ -1881,7 +1881,7 @@ int vpfe_resizer_init(struct vpfe_resizer_device *vpfe_rsz,
>  	struct v4l2_subdev *sd = &vpfe_rsz->crop_resizer.subdev;
>  	struct media_pad *pads = &vpfe_rsz->crop_resizer.pads[0];
>  	struct media_entity *me = &sd->entity;
> -	static resource_size_t  res_len;
> +	resource_size_t  res_len;
                        ^
Could you remove the extra space character also, please.

>  	struct resource *res;
>  	int ret;

regards,
dan carpenter


