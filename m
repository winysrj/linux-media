Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	T_DKIMWL_WL_HIGH,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA800C64EB1
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:23:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F81020837
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:23:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MId2ouye"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6F81020837
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbeLGNXq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 08:23:46 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:52914 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbeLGNXp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 08:23:45 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wB7AsBlK165069;
        Fri, 7 Dec 2018 13:23:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=v5A6Tuk4/q8ZCdIMJ7iQU7d4rraHEzqZD5t9Rk9xynY=;
 b=MId2ouyeQTscv3Om5GZ7bjrJzHAJEoMfO5lyuyDjAhcjhuoRijAp1/G5235FUzZA6fLX
 nVe7TheN9X4CF8nUWY9z9GNTGNLAdjIcC1epV9nUYRAdn0QywKrZ3lHgmYbu5noRQlcv
 8iMakrS6RyrGrxIZIQMegNtajuehPxasJEb+kdmUr+sUKnzPAKVkTWo8xpj/S+jEYKog
 x2BLT4eiNIOhb1kqJ6vSYJ1KGNbX7/pgO9moAcLO02oeYAYomQCx6zTbEIgCHY/xw7b2
 /Hejc5oUhVKoDtC1RFHVRV+4SsEj+ryVfXNTM1wykpdCH0MppCpKLdAvxs22Vt2uQ9FU pA== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2p3hqudvpb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Dec 2018 13:23:05 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wB7DN4WN031697
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Dec 2018 13:23:04 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wB7DN4RL011458;
        Fri, 7 Dec 2018 13:23:04 GMT
Received: from unbuntlaptop (/197.157.0.47)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 07 Dec 2018 05:23:03 -0800
Date:   Fri, 7 Dec 2018 16:22:58 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Hans Verkuil <hverkuil@xs4all.nl>, devel@driverdev.osuosl.org,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        linux-arm-kernel@lists.infradead.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] media: cedrus: don't initialize pointers with zero
Message-ID: <20181207132258.GJ3095@unbuntlaptop>
References: <dd25052db89ccf292f2a5e45b7e94e8e6d000c40.1544180158.git.mchehab+samsung@kernel.org>
 <ff5fe553-fee4-bc5c-d1e9-9dc4cc1319ba@xs4all.nl>
 <20181207093106.4f112d0b@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181207093106.4f112d0b@coco.lan>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9099 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=849
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1812070095
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Dec 07, 2018 at 09:31:06AM -0200, Mauro Carvalho Chehab wrote:
> Em Fri, 7 Dec 2018 12:14:50 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > On 12/07/2018 11:56 AM, Mauro Carvalho Chehab wrote:
> > > A common mistake is to assume that initializing a var with:
> > > 	struct foo f = { 0 };
> > > 
> > > Would initialize a zeroed struct. Actually, what this does is
> > > to initialize the first element of the struct to zero.
> > > 
> > > According to C99 Standard 6.7.8.21:
> > > 
> > >     "If there are fewer initializers in a brace-enclosed
> > >      list than there are elements or members of an aggregate,
> > >      or fewer characters in a string literal used to initialize
> > >      an array of known size than there are elements in the array,
> > >      the remainder of the aggregate shall be initialized implicitly
> > >      the same as objects that have static storage duration."
> > > 
> > > So, in practice, it could zero the entire struct, but, if the
> > > first element is not an integer, it will produce warnings:
> > > 
> > > 	drivers/staging/media/sunxi/cedrus/cedrus.c:drivers/staging/media/sunxi/cedrus/cedrus.c:78:49:  warning: Using plain integer as NULL pointer
> > > 	drivers/staging/media/sunxi/cedrus/cedrus_dec.c:drivers/staging/media/sunxi/cedrus/cedrus_dec.c:29:35:  warning: Using plain integer as NULL pointer
> > > 
> > > A proper way to initialize it with gcc is to use:
> > > 
> > > 	struct foo f = { };
> > > 
> > > But that seems to be a gcc extension. So, I decided to check upstream  
> > 
> > No, this is not a gcc extension. It's part of the latest C standard.
> 
> Sure? Where the C standard spec states that? I've been seeking for
> such info for a while, as '= {}' is also my personal preference.
> 
> I tried to build the Kernel with clang, just to be sure that this
> won't cause issues with the clang support

My test says that clang works with {}.

I support this in Smatch as well.

regards,
dan carpenter

