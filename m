Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6A11C5CFFE
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 23:24:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AB3D2081F
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 23:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544484270;
	bh=TkmMmwwlsQC/gky4gATSzucvBtXZ2oeNoS96Eprkhy0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=DKaREkyFeMptOn2K0nwqht6gJHCx3Hrz2xRi8O34WD/HHMCbw/a6UxPkt1xSodS7T
	 gGOCJ5UTxwdjsIhh993iceKo8d+wFH28P0UJ/HCGLvpPzZqdIGfWnA8sRUrl7Nlsdc
	 G7u4mdXBjfbrCfsEgETIjEDmDLyUfQZL0gkEq7Y4=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8AB3D2081F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729121AbeLJXYZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 18:24:25 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:34684 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726693AbeLJXYY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 18:24:24 -0500
Received: by mail-ot1-f65.google.com with SMTP id t5so12261665otk.1;
        Mon, 10 Dec 2018 15:24:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KyIqd7jyECXOxDIXVZlg/O5Qa59I+DIa+Q5Wb+3up3I=;
        b=VjSN0p95v6pP56foQucg3YxRkmDsI+8eT3vSp/EAMu/oqaXzpchoSxYhPteOQYNtgJ
         omh8ey1pCbW9Hd3xSdPWWssoj1Gjw/txj7D42gZUOICR1Zdizxcs4jrKzDAQ7dY2nP3i
         peld18YvQo/AhCXoLaRhInHVv7mk+2XjDPjizk5EX4STCckKk1oNDjGXp9Iz0gu9yPVX
         k2h2qLa8msy1STs6j5t2+ljbcZB/n3TDipQJm7VgdEoUZ/dTIRjGB5X8B5kb7mkg9nTB
         xOmAn30J6tkqL8oOeHHLNmpimt7OjFZDkcua0J/qSh6hY/uIKClUoBzzL241Z195aug3
         A1HQ==
X-Gm-Message-State: AA+aEWZ+7cKW6ufD5OYcXx4/x/Q/EAP454g49J3HVZ/5PRS72/Iu+uOK
        6RlYItpf4Wge9wq9YI7/Ig==
X-Google-Smtp-Source: AFSGD/Ws1YHh3olY3PBcXpCqOH7s/gd26/9gyrW0EEeawJnBMoQ0EKgDrzJAtlkAqPn9C3omeS4hsA==
X-Received: by 2002:a9d:6a41:: with SMTP id h1mr10187527otn.332.1544484263982;
        Mon, 10 Dec 2018 15:24:23 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id c22sm6165897otr.31.2018.12.10.15.24.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 10 Dec 2018 15:24:23 -0800 (PST)
Date:   Mon, 10 Dec 2018 17:24:23 -0600
From:   Rob Herring <robh@kernel.org>
To:     Jagan Teki <jagan@amarulasolutions.com>
Cc:     Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        linux-amarula@amarulasolutions.com,
        Michael Trimarchi <michael@amarulasolutions.com>,
        Jagan Teki <jagan@amarulasolutions.com>
Subject: Re: [PATCH v3 1/6] dt-bindings: media: sun6i: Add A64 CSI compatible
Message-ID: <20181210232423.GA13891@bogus>
References: <20181210115246.8188-1-jagan@amarulasolutions.com>
 <20181210115246.8188-2-jagan@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181210115246.8188-2-jagan@amarulasolutions.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, 10 Dec 2018 17:22:41 +0530, Jagan Teki wrote:
> Allwinner A64 CSI has single channel time-multiplexed BT.656
> CMOS sensor interface like H3 but work by lowering clock than
> default mod clock.
> 
> Add a compatible string for it.
> 
> Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
> ---
>  Documentation/devicetree/bindings/media/sun6i-csi.txt | 1 +
>  1 file changed, 1 insertion(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
