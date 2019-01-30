Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60F08C282CD
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 03:46:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28FB021848
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 03:46:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="KfM9oWqF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbfA3DqT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 29 Jan 2019 22:46:19 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:35982 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727720AbfA3DqS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Jan 2019 22:46:18 -0500
Received: by mail-qt1-f195.google.com with SMTP id t13so24843638qtn.3
        for <linux-media@vger.kernel.org>; Tue, 29 Jan 2019 19:46:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=CRARLynsaObgHVWXMFzvUh8U6E6Wr0MtJoqVFpUE83E=;
        b=KfM9oWqFzrNUn/R+MKlfkRcZXSI0IwnydcrhEp39KDZbZIC0HPn5NWcKltgDtqBTHV
         2JakMFRV3TJJgwURytpeFpnc7LxDUAjoj0FA8J/uLH1daMCiQPz5+sik9h3aXmwWItwP
         GWQYdZzybkDv8ZzLUL0QTUSDDbO0X+YVGn1FOm1fkJoG6OY7379sTBUDb0NMTzfELPTs
         IanAO7kvTrsLe/LBnLOAbMNAIUCUBUcG66IkLiK0XCz/8W7LZeXKVww37ETawYiQKAx/
         o2ks+0C6w5PtWM5a2IiCou+8vQFohfBNsXlJhp2TTDeuQDkWdfMVjEooToJLBGxtFYLs
         JyYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=CRARLynsaObgHVWXMFzvUh8U6E6Wr0MtJoqVFpUE83E=;
        b=s1NiKppjkQH+dAy9YRRNLIW1jaB3u/1AUVW6xYl0gyGdlY3tIlLVAkHC18h4kQbxe1
         ncIz+ICeVRy2LwBKzK/tW6L8esZEZ3KvKGCqr9u/+T8tM2XGpyrEHhpVnASHkdpT7o3y
         2PlWymOfw2oxEqnZO5ka8LJVizrPUvUR1jLbcydHnLm5aqzzJFf+rB+HGbsiOFv7wuq/
         9yK1lQF3wE9MKeIKY2E4b2W2FGpDYjQKY3UDHoNzjzHRl9siPeEC86D6S6UzMqluB9BT
         Ky5JoaqvFZ63n3B3B9MGmOrfMsaCHcvjnk6U9j60dFOPHHkTrehddXuIlgxQZNO3vOQj
         FJlg==
X-Gm-Message-State: AJcUukeZaGxrznw/+Z4o3olJw/zN05it2r3qac8YBiPDDGFy+RvALe5O
        vMK60171KAqBNHZ4p8AfhuZosQ==
X-Google-Smtp-Source: ALg8bN4FsBCS38ucmuk8IHApcv3wYHg2pDsKE0X+xcU/Z4r0WcddBSNrbsJtxUCx0peQePoiz60VfQ==
X-Received: by 2002:ac8:65c7:: with SMTP id t7mr28015194qto.143.1548819977635;
        Tue, 29 Jan 2019 19:46:17 -0800 (PST)
Received: from skullcanyon ([192.222.193.21])
        by smtp.gmail.com with ESMTPSA id p48sm203419qtp.62.2019.01.29.19.46.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 29 Jan 2019 19:46:16 -0800 (PST)
Message-ID: <f0df52b3ac7dfd5bdac8f18053f7db27de5bc230.camel@ndufresne.ca>
Subject: Re: [PATCH v2 2/3] [media] allegro: add Allegro DVT video IP core
 driver
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Michael Tretter <m.tretter@pengutronix.de>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc:     linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de, robh+dt@kernel.org, mchehab@kernel.org,
        tfiga@chromium.org
Date:   Tue, 29 Jan 2019 22:46:15 -0500
In-Reply-To: <20190123151709.395eec98@litschi.hi.pengutronix.de>
References: <20190118133716.29288-1-m.tretter@pengutronix.de>
         <20190118133716.29288-3-m.tretter@pengutronix.de>
         <1fab228e-3a5d-d1f4-23a3-bb8ec5914851@xs4all.nl>
         <20190123151709.395eec98@litschi.hi.pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.4 (3.30.4-1.fc29) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Le mercredi 23 janvier 2019 à 15:17 +0100, Michael Tretter a écrit :
> > I have a patch pending that allows an encoder to spread the compressed
> > output over multiple buffers:
> > 
> > https://patchwork.linuxtv.org/patch/53536/
> > 
> > I wonder if this encoder would be able to use it.
> 
> I don't think that the encoder could use this, because of how the
> PUT_STREAM_BUFFER and the ENCODE_FRAME command are working: The
> ENCODE_FRAME will always write the compressed output to a single buffer.
> 
> However, if I stop passing the vb2 buffers to the encoder, use an
> internal buffer pool for the encoder stream buffers and copy the
> compressed buffer from the internal buffers to the vb2 buffers, I can
> spread the output over multiple buffers. That would also allow me, to
> get rid of putting filler nal units in front of the compressed data.
> 
> I will try to implement it that way.

As explained in my previous email, this will break current userspace
expectation, and will force userspace into parsing the following frame
to find the end of it (adding 1 frame latency).

I have used a lot the vendor driver for this platform and it has always
been able possible to get the frame size right, so this should be
possible here too.

Nicolas

