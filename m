Return-Path: <SRS0=o7tn=RA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0BA0C43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 20:12:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C17252087C
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 20:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551125524;
	bh=EYqpBxiwBCqFzXzzjmqXlV/tauJMYgCj8aK89UbbaC0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=pn9bRoEdWUp8R/HZfJUm1nW5B1QIHWgtFPF/MlNmJIou4RbC5/QamrJZFK5fti8YS
	 UOMUturquUYpVK3aAuP6hBcJJGwC7DoDtjxfy40aAMRHx+87UrUcN0FsdXrtgIWINo
	 yHvJ3j5f3zA7HndQxhz2CB+5r7gVBSraBXEdJ1A0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbfBYUMD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Feb 2019 15:12:03 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:38238 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726888AbfBYUMD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Feb 2019 15:12:03 -0500
Received: by mail-ot1-f66.google.com with SMTP id m1so9028038otf.5;
        Mon, 25 Feb 2019 12:12:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ocAzVVfkQylopm4Ort5Wdr5rq+kFjcCkYFtUbwAEESE=;
        b=STmTX1MJf8Y0D7B7i2mzJL9ZRCyCqJWt8guuqyQluDPDFulIN+732mQvnHv83oi88j
         Vf53git+2sG57igZkMPQqhw9VUl+69KoGP/3Qo0ReTJQKLPkeFO6sJj5hjLV8LbKpaWK
         3Fsa/ghYA+N2OxfFuc4Yft03J+5Npqn3gglk/YNNMKP/7JiqgfUtL4JpbkGH0LGP8lJ4
         msfvVkrW+wip7jYvInm743WAZAe8OySFXKD/k5oGH6QsjJvcab6zOjy9vnaVIwkNBkIT
         ZqD8t92+ew2fusaLmkvIWP15RA6VXO2a4uBbKuZvqmSv1LMsxuYaQp9l5lffS/wqsmnM
         J5pw==
X-Gm-Message-State: AHQUAuYHFOKAIfCrkpybY0DWiffNeDCiwQMcMQfHiFraYKnOllbyqKFd
        wUg7eH0Ja/aqID3qGyaDiw==
X-Google-Smtp-Source: AHgI3IYtN7CQBZhIXCAXopQj8IaVCVyjHTNCXEcTEqBWp7hyuDUDW5mBbMYfibwwJKhgI/uTVe9iaw==
X-Received: by 2002:a05:6830:d0:: with SMTP id x16mr13434011oto.102.1551125522274;
        Mon, 25 Feb 2019 12:12:02 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id o8sm4423010oia.53.2019.02.25.12.12.00
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 Feb 2019 12:12:00 -0800 (PST)
Date:   Mon, 25 Feb 2019 14:11:59 -0600
From:   Rob Herring <robh@kernel.org>
To:     Marco Felsch <m.felsch@pengutronix.de>
Cc:     robh+dt@kernel.org, mchehab@kernel.org, hans.verkuil@cisco.com,
        sakari.ailus@linux.intel.com, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 1/5] dt-bindings: connector: analog: add tv norms property
Message-ID: <20190225201159.GA9207@bogus>
References: <20190202121004.9014-1-m.felsch@pengutronix.de>
 <20190202121004.9014-2-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190202121004.9014-2-m.felsch@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Sat,  2 Feb 2019 13:10:00 +0100, Marco Felsch wrote:
> Some connectors no matter if in- or output supports only a limited
> range of tv norms. It doesn't matter if the hardware behind that
> connector supports more than the listed formats since the users are
> restriced by a label e.g. to plug only a camera into this connector
> which uses the PAL format.
> 
> This patch adds the capability to describe such limitation within the
> firmware. There are no format restrictions if the property isn't
> present, so it's completely backward compatible.
> 
> Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> ---
>  .../display/connector/analog-tv-connector.txt |  4 ++
>  include/dt-bindings/media/tvnorms.h           | 42 +++++++++++++++++++
>  2 files changed, 46 insertions(+)
>  create mode 100644 include/dt-bindings/media/tvnorms.h
> 

Reviewed-by: Rob Herring <robh@kernel.org>
