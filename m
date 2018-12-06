Return-Path: <SRS0=eh97=OP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3054FC64EB1
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 16:59:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F02AC20868
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 16:59:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F02AC20868
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=chris-wilson.co.uk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbeLFQ6h convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Thu, 6 Dec 2018 11:58:37 -0500
Received: from mail.fireflyinternet.com ([109.228.58.192]:50951 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726052AbeLFQ6f (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Dec 2018 11:58:35 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 14804206-1500050 
        for multiple; Thu, 06 Dec 2018 16:58:31 +0000
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To:     jglisse@redhat.com, linux-kernel@vger.kernel.org
From:   Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20181206154704.5366-1-jglisse@redhat.com>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        =?utf-8?b?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        stable@vger.kernel.org,
        =?utf-8?q?St=C3=A9phane_Marchesin?= <marcheu@chromium.org>,
        =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        linux-media@vger.kernel.org
References: <20181206154704.5366-1-jglisse@redhat.com>
Message-ID: <154411550724.26970.8541642329782166943@skylake-alporthouse-com>
User-Agent: alot/0.6
Subject: Re: [PATCH] dma-buf: fix debugfs versus rcu and fence dumping v2
Date:   Thu, 06 Dec 2018 16:58:27 +0000
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Quoting jglisse@redhat.com (2018-12-06 15:47:04)
> From: Jérôme Glisse <jglisse@redhat.com>
> 
> The debugfs take reference on fence without dropping them. Also the
> rcu section are not well balance. Fix all that ...

Wouldn't the code be a lot simpler (and a consistent snapshot) if it used
reservation_object_get_fences_rcu()?
-Chris
