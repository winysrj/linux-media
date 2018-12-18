Return-Path: <SRS0=J9mZ=O3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE8DEC43387
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 16:13:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE574218A2
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 16:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545149630;
	bh=/099VrXkXSUllqd98g/tHds7GvGT+pyPdawwrtm67GA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=OsmCwT9b9uKV82zsVuWtq3oKSnvTFm5zs9fUOzRbIMmQkUlWbO8jyYVwA90MEcryI
	 W/ahCk3QUdKfQDZgF0GYDQM2wOgGh2eCYhUwqyUrR0BJqEihJ0cp5E87NfRWPJ62cs
	 lCIDbErC/J+wyKmykIxI+VXXWdxKFmC4qU2r0D+8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbeLRQNo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 18 Dec 2018 11:13:44 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:34533 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727205AbeLRQNn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Dec 2018 11:13:43 -0500
Received: by mail-ot1-f65.google.com with SMTP id t5so16221480otk.1;
        Tue, 18 Dec 2018 08:13:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=tSjoTxoGv235BBzqJEt372NZWsn6e4Eg1sBMXs5E6uM=;
        b=po99Cp2s7yat+LM61WrGHwMAXd7xaZAJLF3XWAet400SzLP90Dz1t9YRVbls99GLJJ
         Q9/8TNO4YD+KKePz/wBg1KukYTJBfO/hsFp/k9kYpVTaRP0txVjN2B4FH+eXJdn7Amfb
         xEXTBHBFIQJ/Tm+f19qhJjP80OEauMpA4qWtJIilTds0mM6N29Y1Vjpc61lAyrlQ7sSq
         ytXTNwg686Dj3suUaIp6uodtlT3OX4R2DGK2FvJB5x51ivEcI6e2foRaj0ZHGb2Buro6
         XPObCJDh4236tDV8hhHahq/8Fy+czSc0pcDM1zUq2jZMva7zUgqT+/MExZoYCSIrVW3T
         b8NQ==
X-Gm-Message-State: AA+aEWYI/stCDiO+4CBvBaJ40bNRN1O+n+nwl3LNgBlJ9k38GD0rXqz/
        MuSU7wmR1eSnSsSstnZTsg==
X-Google-Smtp-Source: AFSGD/XDuaS5YANnWoRjWw+BPNJxkLvgpmeqzjFBjnRAv9dkYIw+8dv+BWWc+DiZQjchIGwew+87wQ==
X-Received: by 2002:a05:6830:c7:: with SMTP id x7mr816850oto.31.1545149622604;
        Tue, 18 Dec 2018 08:13:42 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id h24sm9546527otm.72.2018.12.18.08.13.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 18 Dec 2018 08:13:41 -0800 (PST)
Date:   Tue, 18 Dec 2018 10:13:41 -0600
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?B?UGF3ZcWC?= Chmiel <pawel.mikolaj.chmiel@gmail.com>
Cc:     mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        hverkuil@xs4all.nl, fischerdouglasc@gmail.com,
        keescook@chromium.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        =?utf-8?B?UGF3ZcWC?= Chmiel <pawel.mikolaj.chmiel@gmail.com>
Subject: Re: [PATCH v2 4/4] media: dt-bindings: Add binding for si470x radio
Message-ID: <20181218161341.GA5282@bogus>
References: <20181207135812.12842-1-pawel.mikolaj.chmiel@gmail.com>
 <20181207135812.12842-5-pawel.mikolaj.chmiel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181207135812.12842-5-pawel.mikolaj.chmiel@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri,  7 Dec 2018 14:58:12 +0100, =?UTF-8?q?Pawe=C5=82=20Chmiel?= wrote:
> Add device tree bindings for si470x family radio receiver driver.
> 
> Signed-off-by: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
> ---
> Changes from v1:
> 	- squashed with patch adding reset-gpio documentation
> ---
>  .../devicetree/bindings/media/si470x.txt      | 26 +++++++++++++++++++
>  1 file changed, 26 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/si470x.txt
> 

Reviewed-by: Rob Herring <robh@kernel.org>
