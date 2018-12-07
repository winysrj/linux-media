Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	T_DKIMWL_WL_HIGH,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95F93C07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:39:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D5F020989
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:39:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DhMnHDi4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D5F020989
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbeLGNjK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 08:39:10 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:48744 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbeLGNjK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 08:39:10 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wB7DYhnC055051;
        Fri, 7 Dec 2018 13:38:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=+TpX5q9EW815UhqRDaBznzaJoMwUNrjVTJwFa9jjIiE=;
 b=DhMnHDi4ZLefZJGnkBICEr3nS5XdAkTf04EIX8mHS2ty19xqdQ2314WiD7SomAMgZiST
 xGXtHsAgjK9yuTBq5A6oErhhSL/Q+3Rgb64RsJ4Na8TlwR4AnqT5K4IIjjM/Swy3/sFU
 oI2rESIuX9lMxTOH29pAZ/MIUCFzEE2cj9s/xd6vH3QEXFJhFpEStiopKsPSSnx3KF7g
 XhvSra/k6HkIAPluKiu2bBL2vdI3sN3kPUlZANFRriDcP39EnJrmV3yG/wZ34c7rSKt0
 tECG95t538LMUIJzjvv/p5oVfvEwteydkOE9hdAUVUZApRjJ3mlFvLuRncjB9bI9U5k3 dQ== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2p3ftfhu6u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Dec 2018 13:38:59 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wB7Dcwpl013048
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Dec 2018 13:38:58 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wB7Dcwr7019216;
        Fri, 7 Dec 2018 13:38:58 GMT
Received: from unbuntlaptop (/197.157.0.47)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 07 Dec 2018 05:38:57 -0800
Date:   Fri, 7 Dec 2018 16:38:49 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Rui Miguel Silva <rui.silva@linaro.org>,
        sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v9 00/13] media: staging/imx7: add i.MX7 media driver
Message-ID: <20181207133849.GK3095@unbuntlaptop>
References: <20181122151834.6194-1-rui.silva@linaro.org>
 <757f8c52-7c23-7cf7-32ee-75ddba767ff8@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <757f8c52-7c23-7cf7-32ee-75ddba767ff8@xs4all.nl>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9099 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1812070108
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Dec 07, 2018 at 01:44:00PM +0100, Hans Verkuil wrote:
> CHECK: Alignment should match open parenthesis
> #936: FILE: drivers/staging/media/imx/imx7-mipi-csis.c:921:
> +       ret = v4l2_async_register_fwnode_subdev(mipi_sd,
> +                               sizeof(struct v4l2_async_subdev), &sink_port, 1,
> 
> Apparently the latest coding style is that alignment is more important than
> line length, although I personally do not agree. But since you need to
> respin in any case due to the wrong SPDX identifier you used you might as
> well take this into account.

I'm pretty sure it complains about both equally.  If you make fix one
warning it will complain about the other.  So you just have to pick
which warning to not care about.

regards,
dan carpenter

