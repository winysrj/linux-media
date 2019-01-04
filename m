Return-Path: <SRS0=+L2G=PM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BIGNUM_EMAILS,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB836C43387
	for <linux-media@archiver.kernel.org>; Fri,  4 Jan 2019 12:29:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 741CC2070C
	for <linux-media@archiver.kernel.org>; Fri,  4 Jan 2019 12:29:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OkLCP1B2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbfADM3H (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 4 Jan 2019 07:29:07 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:34390 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727211AbfADM3G (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 Jan 2019 07:29:06 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x04CT45O007328;
        Fri, 4 Jan 2019 12:29:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=8H2Qi7RgJInaze6RbYtjspgTuwIA5FqMAFfI24o/QjY=;
 b=OkLCP1B23Ts1R2jXmqDFRQfC3kkOZB7i/no+dV7vIBzXk00G3+t0w2fidbOK3AKqkaAd
 idsgdySGlatiMpAKkVKJf0kDx8A2Zc5UPsjeuIPfZJkDIdHc3otJM+IeE3dd21UNHPB3
 r12BcMTF0wDG0FqVOOyuHyQcIIQSsYljaGBmr1z/HGtj+zM8m1czIxc0Otim7fE7Jclz
 vg9z7AWfKp0209nHX69/aUYWz2QJxJsAPo4oBAp6AgeKfQVLiYhUZJ17RDlyHSZR/inL
 XV+xRHBjaeFuaE2d1k+EzKgdP5s+J+07pz8Cl+2iAxtkvXPO6kSEv74QgoD+9ASKtid5 pA== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2pnxeec17e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Jan 2019 12:29:04 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x04CT3Zm032036
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Jan 2019 12:29:03 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x04CT32c011396;
        Fri, 4 Jan 2019 12:29:03 GMT
Received: from kadam (/41.202.241.42)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 04 Jan 2019 04:29:02 -0800
Date:   Fri, 4 Jan 2019 15:28:56 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     yong.zhi@intel.com
Cc:     linux-media@vger.kernel.org
Subject: [bug report] media: staging/intel-ipu3: Add imgu top level pci
 device driver
Message-ID: <20190104122856.GA1169@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9125 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901040111
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello Yong Zhi,

The patch 7fc7af649ca7: "media: staging/intel-ipu3: Add imgu top
level pci device driver" from Dec 6, 2018, leads to the following
static checker warning:

	drivers/staging/media/ipu3/ipu3.c:493 imgu_isr_threaded()
	warn: 'b' is an error pointer or valid

drivers/staging/media/ipu3/ipu3.c
    472 static irqreturn_t imgu_isr_threaded(int irq, void *imgu_ptr)
    473 {
    474 	struct imgu_device *imgu = imgu_ptr;
    475 	struct imgu_media_pipe *imgu_pipe;
    476 	int p;
    477 
    478 	/* Dequeue / queue buffers */
    479 	do {
    480 		u64 ns = ktime_get_ns();
    481 		struct ipu3_css_buffer *b;
    482 		struct imgu_buffer *buf = NULL;
    483 		unsigned int node, pipe;
    484 		bool dummy;
    485 
    486 		do {
    487 			mutex_lock(&imgu->lock);
    488 			b = ipu3_css_buf_dequeue(&imgu->css);
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
ipu3_css_buf_dequeue() doesn't return NULL.

    489 			mutex_unlock(&imgu->lock);
    490 		} while (PTR_ERR(b) == -EAGAIN);
    491
    492 		if (IS_ERR_OR_NULL(b)) {
                            ^^^^^^^^^^^^^^^^^
--> 493 			if (!b || PTR_ERR(b) == -EBUSY)	/* All done */
                                    ^^
When a function returns both NULL and error pointers, then NULL is
considered a special case of success.  Like perhaps you request a
feature, but that feature isn't enabled in the config.  It's fine,
because the user *chose* to turn off the feature, so it's not an error
but we also don't have a valid pointer we can use.

It looks like you were probably trying to do something like that but
you missed part of the commit?  Otherwise we should delete the dead
code.

    494 				break;
    495 			dev_err(&imgu->pci_dev->dev,
    496 				"failed to dequeue buffers (%ld)\n",
    497 				PTR_ERR(b));
    498 			break;
    499 		}
    500 

regards,
dan carpenter
