Return-Path: <SRS0=E4aF=O2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B08CC43387
	for <linux-media@archiver.kernel.org>; Mon, 17 Dec 2018 21:44:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D948121783
	for <linux-media@archiver.kernel.org>; Mon, 17 Dec 2018 21:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545083069;
	bh=oVmdQkjHecEAfWrY13oBq8RmKJIQ4hHPQA7UqY5Lz1I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=IfEM0GaDYbVhkmKIQ/7QSD/gMhc342qX2CVlcqR70g0T06oGbjaw0lLZ4kzdk9Ggd
	 m7AO9wvha1MDQvh4svwP1ncLKBYmb+afU2PoiPLn7/V1bNt6kBQYiM5yMCFAOVrb3X
	 PqYobHEsKKO/TsJ3PzLdnIo7Bnr6fr8QeULEiv0I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbeLQVo2 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 17 Dec 2018 16:44:28 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:42695 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbeLQVo2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Dec 2018 16:44:28 -0500
Received: by mail-ot1-f66.google.com with SMTP id v23so13657458otk.9;
        Mon, 17 Dec 2018 13:44:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6emurhg0pNllZcFy3ENpTRIU6NvxzWM6Iw7mhqIhGGE=;
        b=YSZyvMOD15MoMkLyMCBxxnbGVgZD+KZQ31VUz0UgRaBGfHsqnvVCW51Omk6qgzo3Uh
         Nl9Suhs37yiXAjkra7j1iOIyTs6JjvLFSs+1lQGrLCl++XPLNkXr5blH0DqSTtW11y9U
         q0DvlPPTWmlZd7evHTATS5HhwAFQd+WBIP1rUN8ZwzU8EAYgJbpc0+LVQD2CSrqEjbS5
         DmzZzpKPaNQ6gDPpwECf/uL62vNO6FuC65hdTIkbqIocHdmuEX+MARi8r960eMepPnR7
         gOTERfns0/FIpLwSLGuR9VyPcCuxi3cqMWW+DgHd0y54DBeS1h+mhxbxBg3PSezW3PWS
         AceQ==
X-Gm-Message-State: AA+aEWaY68spb//eR7nR4Os2Ki1FBTvC473Nf2N6ytBuFF3IdVToiQ9E
        Z6gM2p378l4l/t0vpgLm8zR3OxY=
X-Google-Smtp-Source: AFSGD/Vhx8sU3SlXgbwjFREE2G4HFgU+1eeUPAwK1oQ7ND1kHgyPVZRM6yCm8EhCIa2IB6hmUyBm6A==
X-Received: by 2002:a9d:a83:: with SMTP id 3mr10999860otq.88.1545083067720;
        Mon, 17 Dec 2018 13:44:27 -0800 (PST)
Received: from localhost (cpe-70-114-214-127.austin.res.rr.com. [70.114.214.127])
        by smtp.gmail.com with ESMTPSA id s66sm11119757oia.55.2018.12.17.13.44.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 17 Dec 2018 13:44:27 -0800 (PST)
Date:   Mon, 17 Dec 2018 15:44:26 -0600
From:   Rob Herring <robh@kernel.org>
To:     Matt Ranostay <matt.ranostay@konsulko.com>
Cc:     linux-media@vger.kernel.org,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v4 1/2] media: dt-bindings: media: video-i2c: add melexis
 mlx90640 documentation
Message-ID: <20181217214426.GA20131@bogus>
References: <20181211151701.10002-1-matt.ranostay@konsulko.com>
 <20181211151701.10002-2-matt.ranostay@konsulko.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181211151701.10002-2-matt.ranostay@konsulko.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, 11 Dec 2018 07:17:00 -0800, Matt Ranostay wrote:
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Matt Ranostay <matt.ranostay@konsulko.com>
> ---
>  .../bindings/media/i2c/melexis,mlx90640.txt   | 20 +++++++++++++++++++
>  1 file changed, 20 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/melexis,mlx90640.txt
> 

Reviewed-by: Rob Herring <robh@kernel.org>
