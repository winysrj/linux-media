Return-Path: <SRS0=G3Vt=RO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D916C43381
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 14:37:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C2632084F
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 14:37:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="efwm20Wa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbfCKOhl (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Mar 2019 10:37:41 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48360 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727026AbfCKOhl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Mar 2019 10:37:41 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2BEY0QG169698;
        Mon, 11 Mar 2019 14:37:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=cXCwpYkCTU5E0HBm6NpM0MFdPfXIUfb/2XLgi/Eclnk=;
 b=efwm20Wat2vJ72tJOdIB+l7+MZGkGFTCW6ztCj/wgSP/Jw+jtFJ36+pfHbwrvy+Hnnuk
 u3ZEpt7m6gQYjmJE6VP2JoQ8nysJZPU+E19s6xIqpwkugJm3PGKx2arZISav6WjL3poA
 lilz377gedsPHTf7xBMDSI8q5fEQURDHiOACKwb+y5hbDpZnjTrHCKgPAvH4+WIcjgaG
 8ouSXq7jGJHv4UUFedGeZ59oAnH4vfSJqJThCp+GVopC2GVevREN/ndS4LRauM3HtF8Q
 yldwhGo/qkO98rBJD8/6JOS3rUZGDY8WbHR+DePsQ89YqQqZElisIQLSNJMNR6aYWyap LQ== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2r464r6ray-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Mar 2019 14:37:28 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2BEbSGV000517
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Mar 2019 14:37:28 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2BEbSBk028870;
        Mon, 11 Mar 2019 14:37:28 GMT
Received: from kadam (/197.157.34.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Mar 2019 07:37:27 -0700
Date:   Mon, 11 Mar 2019 17:37:18 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Colin Ian King <colin.king@canonical.com>
Cc:     Mao Wenan <maowenan@huawei.com>, gregkh@linuxfoundation.org,
        Julia.Lawall@lip6.fr, kimbrownkd@gmail.com, hans.verkuil@cisco.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: davinci: drop pointless static qualifier in
 vpfe_resizer_init()
Message-ID: <20190311143718.GF2412@kadam>
References: <20190311141405.123611-1-maowenan@huawei.com>
 <20190311140733.GG2434@kadam>
 <bb7e58a0-2af8-efc2-1cee-0a096353c7ce@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb7e58a0-2af8-efc2-1cee-0a096353c7ce@canonical.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9192 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903110106
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Mar 11, 2019 at 02:10:12PM +0000, Colin Ian King wrote:
> On 11/03/2019 14:07, Dan Carpenter wrote:
> > On Mon, Mar 11, 2019 at 10:14:05PM +0800, Mao Wenan wrote:
> >> There is no need to have the 'T *v' variable static
> >> since new value always be assigned before use it.
> >>
> >> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> >> ---
> >>  drivers/staging/media/davinci_vpfe/dm365_resizer.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.c b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
> >> index 6098f43ac51b..a2a672d4615d 100644
> >> --- a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
> >> +++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
> >> @@ -1881,7 +1881,7 @@ int vpfe_resizer_init(struct vpfe_resizer_device *vpfe_rsz,
> >>  	struct v4l2_subdev *sd = &vpfe_rsz->crop_resizer.subdev;
> >>  	struct media_pad *pads = &vpfe_rsz->crop_resizer.pads[0];
> >>  	struct media_entity *me = &sd->entity;
> >> -	static resource_size_t  res_len;
> >> +	resource_size_t  res_len;
> >                         ^
> > Could you remove the extra space character also, please.
> 
> shouldn't checkpatch find these?
> 

We would sometimes want to add extra spaces to make struct declarations
line up in a header file.

regards,
dan carpenter

