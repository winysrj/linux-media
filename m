Return-Path: <SRS0=o7tn=RA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7D46C43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 14:27:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B798E20842
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 14:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551104845;
	bh=oYCSwjQPfFWBZTPxr1ePAUFzju9Grnx9JoGItDN6l/8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=q/+UUQxz358h2peHsUOJBN3KLlzdDpKfX7sEbZxWWc0ToSX8SfAtghrwXhgFjBZgW
	 6+PAAvc2f3UYJva+qUSpVU39habNFkHJGynr3rSl5N/smJ4Lu8Wgx2uml4ox0LMur0
	 rs4HnyrngQtQLI/2SgmTxn34SLb0GlvzB8cxuxBE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbfBYO1U (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Feb 2019 09:27:20 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:44388 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726764AbfBYO1U (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Feb 2019 09:27:20 -0500
Received: by mail-oi1-f194.google.com with SMTP id a81so7334092oii.11;
        Mon, 25 Feb 2019 06:27:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ihiU+3n7h/gaAsQlqiSrq+3amM5GIY0eWEX29/lDcjQ=;
        b=C96yFxy/yqQyatlRq2JJENoWw0fl3iWR92fzzsF/VJCLwlJCUc8TcQV6iejVgjyl8j
         Ycqkiu9xUyPqUuooDNHN9Jc/V5sMZ8sr/+RDbIVaQV0Bnt2s+PDraiI2PyMbMFj+2TFM
         q8Jrt6WkWP5rBFnUYF6szsSyxKlPOuhI9W3zG5XtNMOtTJ1CAGxHyCJnBmKga8UOdKQc
         FKkKK7zsK1OxhIpZs/2vTMnBiH1X3udh/0HI8vcq6NI6R35qYgxetFwZxVAnUaI9q2cZ
         HYymnAxu1CqXX91Wy8eCZ0Ilgv9YAR5InT0bwSKFfo7zPWfzQdOc+0dRzLsJ8AXvuk3+
         PIMg==
X-Gm-Message-State: AHQUAua8PLS8c0KeSk10S5IL3OgmUbcfU1z6/TaRBN344Z65gV7DqQhJ
        eczqa1f3wMcw7b33nTEwcQ==
X-Google-Smtp-Source: AHgI3IZ6apreZ78o4sLjGiIC8bpimsbT4Nk/ecvVgZFMtigSXkVkYd4tNgh+HzDxUvGtx6aZEV80Ng==
X-Received: by 2002:aca:a90f:: with SMTP id s15mr11456206oie.42.1551104839108;
        Mon, 25 Feb 2019 06:27:19 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id 3sm1335113ots.75.2019.02.25.06.27.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 Feb 2019 06:27:18 -0800 (PST)
Date:   Mon, 25 Feb 2019 08:27:17 -0600
From:   Rob Herring <robh@kernel.org>
To:     Jernej Skrabec <jernej.skrabec@siol.net>
Cc:     maxime.ripard@bootlin.com, wens@csie.org, mchehab@kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH 1/6] dt-bindings: media: cedrus: Add H6 compatible
Message-ID: <20190225142717.GA27983@bogus>
References: <20190128205504.11225-1-jernej.skrabec@siol.net>
 <20190128205504.11225-2-jernej.skrabec@siol.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190128205504.11225-2-jernej.skrabec@siol.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, 28 Jan 2019 21:54:59 +0100, Jernej Skrabec wrote:
> This adds a compatible for H6. H6 VPU supports 10-bit HEVC decoding and
> additional AFBC output format for HEVC.
> 
> Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
> ---
>  Documentation/devicetree/bindings/media/cedrus.txt | 1 +
>  1 file changed, 1 insertion(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
