Return-Path: <SRS0=G3Vt=RO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67BA2C43381
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 14:36:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EBCF206BA
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 14:36:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b/HPaMwO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727710AbfCKOgf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Mar 2019 10:36:35 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:38758 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727629AbfCKOge (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Mar 2019 10:36:34 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2BEXwhY007588;
        Mon, 11 Mar 2019 14:36:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=q2xPT9aYNv3n8ZfbCyQkPK3lG0v/KfOw17OG2y43ouA=;
 b=b/HPaMwOYVg5MywMfXq2n4BH0Ds/ZtPF8eqxFrYuN7DptPClD1/3LAYJktPi9OwmSEvo
 /humve5iTgX6lWTwbfkApeWVpEF8KGo+8NlX2gthtgETulvzwAvQaEDFdohNKDKwO2TQ
 V9fHsmG6ewEGldzsMMFzqrB145/Vg9YFL/5FGDD8afHKuSIoLkU3Vnf8rHYjRS4xM5FO
 S0L6jX5n5xyhXFHxjohN+maVaa19TBHqHjjsNah4DrAq10Bkq1XGsSa/Uh+5KTfcNbSM
 cMhXIEAToBZ4O756ViCVsIvIC3/pqAfhwpZj77bONgBUvzpwfeGaDheg2nr4yFDuo5eH +A== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2r430ef95g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Mar 2019 14:36:03 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2BEa2ld026970
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Mar 2019 14:36:03 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2BEa1e7008547;
        Mon, 11 Mar 2019 14:36:01 GMT
Received: from kadam (/197.157.34.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Mar 2019 14:36:01 +0000
Date:   Mon, 11 Mar 2019 17:35:51 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Mao Wenan <maowenan@huawei.com>
Cc:     gregkh@linuxfoundation.org, Julia.Lawall@lip6.fr,
        kimbrownkd@gmail.com, colin.king@canonical.com,
        hans.verkuil@cisco.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] staging: davinci: drop pointless static qualifier in
 vpfe_resizer_init()
Message-ID: <20190311143551.GH2434@kadam>
References: <20190311143739.132064-1-maowenan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190311143739.132064-1-maowenan@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9192 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=957 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903110106
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Thanks!

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

