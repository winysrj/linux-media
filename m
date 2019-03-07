Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A63B2C10F00
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 00:27:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72F0C20675
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 00:27:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="Cq71skF+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbfCGA1F (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 19:27:05 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36536 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbfCGA1E (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 19:27:04 -0500
Received: by mail-lf1-f68.google.com with SMTP id 197so397145lfz.3
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 16:27:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=PGgDwKDi97DaYzGzFGNNNd+wQhmn7hANjPmdhqb2fhE=;
        b=Cq71skF+asI81owqvoiziWlBYS+VOhTZ8tefbE/BAuufhA/qoEIiah7I7qKNNolCwL
         DfhNGJQh+bTayAFeor2gzJhknTD8BuPzhy6r++lBxVt/XDV18/jb0QMYtjgL9xCmiCBk
         NpsixkRGUfwNWF1JjRgij7+23TilTqNHw4930jZ4plwYjXYz7g038L3Q+5m6GbNHiydj
         937XTu1KsjMqLi13M9gIh2q5XcrihCkUisqwh5IqdxBez/NRjDA7oabT777OT6CIvNfx
         ZnEWPXOtMzLIgz9HDVYVYSrlWc9F1RFlTEHyfTWBQtrA49tY1qEQtMTFYQAcd1dOWwE0
         BYew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=PGgDwKDi97DaYzGzFGNNNd+wQhmn7hANjPmdhqb2fhE=;
        b=OS8yHK1gu2qHVsrdh1Llzgk+dWNCGS+RP3XfSEcnlIsZ9WSjcuIcTwzmKtkNeJhDDB
         U6w6ieu3TnGMNTcYsMPoEUc0qjKrZMzaj3okkisXO9/ne3cakGCNd2RcDTLd/bolL6PN
         60J/Ml6PtpQVmyQY06R+IkFPspua5WYLGtA2rjkUB1JvtP2TeCfX6pHZD7V/tNPwWU85
         IEwImnVlqdzSgbx+Fm5xSG1xe7hX4mTUGTcXx62AeeBNnIiA+Fln8e1LdZQkgLtpwtrV
         QSGuNVBsBA4HCdeIjhM9owBcqSX7LnFSRGuCTFweiLPQOYmQejqfXypYZpeY8X2XLeqb
         Vs9A==
X-Gm-Message-State: APjAAAX8tKFs14vNQQPsFztovEfOCE1xfCxl+F6Dsdlc92QRrXBvzjCe
        s2clY9vq6RKlXdWSzQHWg0s/8A==
X-Google-Smtp-Source: APXvYqxWvMzg/r/lc7RErIMv/FHbQeK5DopTwjPkIsX/zxJxNdF7VKdfEzsAoiJ2PgA6Jpmj6aa7YA==
X-Received: by 2002:ac2:52ae:: with SMTP id r14mr5702153lfm.66.1551918422553;
        Wed, 06 Mar 2019 16:27:02 -0800 (PST)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id b141sm614640lfb.72.2019.03.06.16.27.01
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 06 Mar 2019 16:27:02 -0800 (PST)
From:   "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
X-Google-Original-From: Niklas =?iso-8859-1?Q?S=F6derlund?= <niklas.soderlund+renesas@ragnatech.se>
Date:   Thu, 7 Mar 2019 01:27:01 +0100
To:     Ulrich Hecht <uli@fpond.eu>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 2/3] rcar-csi2: Update start procedure for H3 ES2
Message-ID: <20190307002701.GK9239@bigcity.dyn.berto.se>
References: <20190218100313.14529-1-niklas.soderlund+renesas@ragnatech.se>
 <20190218100313.14529-3-niklas.soderlund+renesas@ragnatech.se>
 <1597578789.516973.1550488339434@webmail.strato.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1597578789.516973.1550488339434@webmail.strato.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Ulrich,

Thanks for your feedback.

On 2019-02-18 12:12:19 +0100, Ulrich Hecht wrote:
> 
> > On February 18, 2019 at 11:03 AM Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se> wrote:
> > 
> > 
> > Latest information from hardware engineers reveals that H3 ES2 and ES3
> > of behaves differently when working with link speeds bellow 250 Mpbs.
> > Add a SoC match for H3 ES2.* and use the correct startup sequence.
> 
> It would be helpful to explain how they behave differently. My guess is that the extra steps "Set the PHTW to H′0139 0105." and "Set the PHTW to the appropriate values for the HS reception frequency." from the flowchart can/must be omitted on ES2+, but I think it would be better if that were stated explicitly somewhere.

I wish I could add a more descriptive message on how they changed and 
why. All I have are the register values in a flow chart. As you point 
out one can describe how the raw values are different, but that is all 
in the code. What I really would like to add is why :-)

> 
> With that fixed:
> 
> Reviewed-by: Ulrich Hecht <uli+renesas@fpond.eu>
> 
> CU
> Uli

-- 
Regards,
Niklas Söderlund
