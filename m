Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A984C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 08:49:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE7D62075C
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 08:49:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="2QrKDX+1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730013AbfAIItL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 03:49:11 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:35786 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbfAIItK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 03:49:10 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x098hpMu035818;
        Wed, 9 Jan 2019 08:49:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=hmHyLk6AZfrgMOpGkFKNxGnAtkbRW++tU6RVBJIKbzk=;
 b=2QrKDX+1ej3Zupom5fj7NyJtwr/zyOp/zRIlZUbcBHdKXhEo0ptCHk1aVaHW9aULqgNr
 gsLiFsnd9eYKanLx2Y2opyNcXAy1lqIYKeRCplsghHKdh1o6Bqj4IT9ZXec+GUtkNU/l
 UYz5MYD/a5bdQyDx02CcnpDX+GH5A+KXH8FMwp/K7D66Lh+8Hhp4ee9sz9Df43zrCPUF
 c4CSgmEfjmdgewJhDRRtfMCA4gb6sX4pwaAvFcakkFIgg+7zmZq3OmLo+lhyIlCNi9A2
 L+djnGAew7yozoWLYqYpU/KnZFBAhG0AHhhJRjqUIqdtIcSwTxMjRSr5JMF6v13LZtBZ 8A== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2ptn7qyvwb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jan 2019 08:49:07 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x098n7Q8014235
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Jan 2019 08:49:07 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x098n6iQ007060;
        Wed, 9 Jan 2019 08:49:06 GMT
Received: from kadam (/41.202.241.8)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Jan 2019 00:49:03 -0800
Date:   Wed, 9 Jan 2019 11:48:54 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        devel@driverdev.osuosl.org, linux-media@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.20 056/117] media: cedrus: don't initialize
 pointers with zero
Message-ID: <20190109084854.GA1743@kadam>
References: <20190108192628.121270-1-sashal@kernel.org>
 <20190108192628.121270-56-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190108192628.121270-56-sashal@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9130 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=604
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901090076
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This is a pure cleanup patch, it doesn't affect runtime.

On Tue, Jan 08, 2019 at 02:25:24PM -0500, Sasha Levin wrote:
> From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> 
> [ Upstream commit e4d7b113fdccde1acf8638c5879f2a450d492303 ]
> 
> A common mistake is to assume that initializing a var with:
> 	struct foo f = { 0 };
> 
> Would initialize a zeroed struct. Actually, what this does is
> to initialize the first element of the struct to zero.
> 
> According to C99 Standard 6.7.8.21:
> 
>     "If there are fewer initializers in a brace-enclosed
>      list than there are elements or members of an aggregate,
>      or fewer characters in a string literal used to initialize
>      an array of known size than there are elements in the array,
>      the remainder of the aggregate shall be initialized implicitly
>      the same as objects that have static storage duration."

Static storage is initialized to zero so this is fine.  It's just
that Sparse complains if you mix NULL and zero.

regards,
dan carpenter

