Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72C0CC43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 10:24:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4518F2146E
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 10:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553077463;
	bh=pxfmXR9ycIrnrVUwiWGXZCT3N1Zqisglxy+LBqUOjZI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=gyZTnFptNFgLUuRBIFxooYMVME4m3FrfsntPUM9c4N07LZHVWuLagWQ+pkmC0kpKu
	 v3YuzI48DxA/8/izGEPTEOcRWMmmKzHfLNg9K993hn1bYUDKRucEhLIM7O8E94TIKJ
	 OO1ml8Mj2PPKNId6ycucXlLEogtZBBiof0Qj3//0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727585AbfCTKYW (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 06:24:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:52448 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbfCTKYW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 06:24:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dLovM1MleCv3EaeDZoqWZseslMOxNs7Z2+PZ2pEaxS8=; b=rn6KGsOOou1h9gnPubcDvLY+xJ
        p0R+rvGi5smpe47JMw5a3qoQVosIpGg/r2VPVzgp5L3C3zh8vV+QRMlvtJZaQ96vjG15X0s+ZP4N9
        AyVuBmiH6hvdbm6TlbL+TIl6HXRArGi4EHbx/GPzqSRHTpX4wzzfvIw4xaigDrFxF+XiPMSTdUkTy
        iW/eG5o/9gyOknUOyNFPmYAKcjhwCur6G6jdLKx0LI7p8yF0s/rtNyH4AKq/MXwQjP1uy5qaEGbF9
        CZcw7bPy54FT+KDULN6rVDn64caknZ3/ESJzs/IJuzfIGZLf+lWV/BIW3uO/DeMSBeGUCFwipZJZi
        q/gJ9bmg==;
Received: from [179.95.24.146] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1h6YOS-0001on-HE; Wed, 20 Mar 2019 10:24:21 +0000
Date:   Wed, 20 Mar 2019 07:24:16 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Dafna Hirschfeld <dafna3@gmail.com>,
        Helen Koike <helen.koike@collabora.com>
Subject: Re: [GIT PULL FOR v5.2] vicodec: support the stateless decoder
Message-ID: <20190320072416.6dd14e24@coco.lan>
In-Reply-To: <147cd6cd-d5be-a183-ebb6-c6be03f71163@xs4all.nl>
References: <147cd6cd-d5be-a183-ebb6-c6be03f71163@xs4all.nl>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Thu, 14 Mar 2019 09:04:24 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Hi Mauro,
> 
> This series adds support for a stateless decoder to vicodec.
> 
> The first two patches are to vicodec bug fixes.

I applied those.

> Patches 3-5 add the V4L2_BUF_CAP_REQUIRES_REQUESTS flag: this will be used
> for stateless codecs that require the use of requests.

I raised a concern about patch 3. At very least, it would require a lot
more documentation than what's there.

> 
> Patches 6-19 fix bugs and prepare vicodec for adding the stateless decoder.

I suspect that those would not depend on patches 3-5. Yet, I guess
it is better to just wait for a new series, after my concerns got
addressed.

So, applied only patches 1 and 2 from this series.


Thanks,
Mauro
