Return-Path: <SRS0=EV+/=QI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 070C3C282DB
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 10:26:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C29B1218AC
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 10:26:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="reoemKBf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729293AbfBAK0v (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Feb 2019 05:26:51 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:35414 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726450AbfBAK0v (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2019 05:26:51 -0500
Received: from pendragon.ideasonboard.com (85-76-34-136-nat.elisa-mobile.fi [85.76.34.136])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 6FEB241;
        Fri,  1 Feb 2019 11:26:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1549016809;
        bh=InwLXB1TsvAFR3uAQlbJOPzL1yW7T+3c/eRASsxlF+o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=reoemKBf/mI3vMHf4KSuWTYbUeZD8r6TaM45q2I2ZOGFIgaWeiV3hfBV2Tmf98ulA
         +FRsfS/hHHugpQEsaavTXVPWavJY+tGHLnj9oo9e4puHhUQZ41DXW6Sz7lBe9cpxus
         7jESj6WwM7Xr1YBe/cK0MeYwSoG6YoJwJJEZDZvk=
Date:   Fri, 1 Feb 2019 12:26:43 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        chiranjeevi.rapolu@intel.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] uvc: Avoid NULL pointer dereference at the end of
 streaming
Message-ID: <20190201102643.GC4341@pendragon.ideasonboard.com>
References: <20190130100941.17589-1-sakari.ailus@linux.intel.com>
 <20190131020449.2CEFD20989@mail.kernel.org>
 <20190131073107.rogoi3rwmjgzq4x3@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190131073107.rogoi3rwmjgzq4x3@paasikivi.fi.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello,

On Thu, Jan 31, 2019 at 09:31:07AM +0200, Sakari Ailus wrote:
> On Thu, Jan 31, 2019 at 02:04:48AM +0000, Sasha Levin wrote:
> > Hi,
> > 
> > [This is an automated email]
> > 
> > This commit has been processed because it contains a "Fixes:" tag,
> > fixing commit: 9c0863b1cc48 [media] vb2: call buf_finish from __queue_cancel.
> > 
> > The bot has tested the following trees: v4.20.5, v4.19.18, v4.14.96, v4.9.153, v4.4.172, v3.18.133.
> > 
> > v4.20.5: Build OK!
> > v4.19.18: Build OK!
> > v4.14.96: Build OK!
> > v4.9.153: Build OK!
> > v4.4.172: Build OK!
> > v3.18.133: Failed to apply! Possible dependencies:
> >     5d0fd3c806b9 ("[media] uvcvideo: Disable hardware timestamps by default")
> > 
> > 
> > How should we proceed with this patch?
> 
> IMO 5d0fd3c806b9 should be applied as well. It's effectively a bugfix as
> well (but which also, for most users, covered the problem fixed by
> 9c0863b1cc48).
> 
> Laurent, could you confirm?

That seems good to me.

-- 
Regards,

Laurent Pinchart
