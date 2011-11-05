Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp22.services.sfr.fr ([93.17.128.12]:11541 "EHLO
	smtp22.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab1KER5k (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Nov 2011 13:57:40 -0400
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf2211.sfr.fr (SMTP Server) with ESMTP id 0852E70000C9
	for <linux-media@vger.kernel.org>; Sat,  5 Nov 2011 18:57:38 +0100 (CET)
Received: from smtp-in.softsystem.co.uk (183.95.30.93.rev.sfr.net [93.30.95.183])
	by msfrf2211.sfr.fr (SMTP Server) with SMTP id BD61370000C6
	for <linux-media@vger.kernel.org>; Sat,  5 Nov 2011 18:57:37 +0100 (CET)
Received: FROM [192.168.1.62] (gagarin [192.168.1.62])
	BY smtp-in.softsystem.co.uk [93.30.95.183] (SoftMail 1.0.6, www.softsystem.co.uk) WITH ESMTP
	FOR <linux-media@vger.kernel.org>; Sat, 05 Nov 2011 18:57:36 +0100
Subject: Re: [PATCH] Revert most of 15cc2bb [media] DVB:
 dtv_property_cache_submit shouldn't modifiy the cache
From: Lawrence Rust <lawrence@softsystem.co.uk>
To: Andreas Oberritter <obi@linuxtv.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <4EB574A3.8050503@linuxtv.org>
References: <1320506379.1731.12.camel@gagarin>
	 <4EB566CD.7050704@linuxtv.org> <1320513624.1731.20.camel@gagarin>
	 <4EB574A3.8050503@linuxtv.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Nov 2011 18:57:35 +0100
Message-ID: <1320515855.1731.28.camel@gagarin>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2011-11-05 at 18:38 +0100, Andreas Oberritter wrote:
[snip]
> I don't get how this could be useful. MythTV knows what delivery system
> it wants to use, so it should pass this information to the kernel.
> Trying to set an invalid delivery system must fail.
> 
> Using SYS_UNDEFINED as a pre-set default is different from setting
> SYS_UNDEFINED from userspace, which should always generate an error IMO,
> unless this is documented otherwise in the API specification.

It's not ideal that MythTV is setting DTV_DELIVERY_SYSTEM to 0 and I
have filed a bug against this.  But that doesn't change the fact that
the original patch significantly changed user parameter handling for no
significant benefit.  MythTV is probably the biggest client of v4l and
will greatly hinder users upgrading to (Myth)Ubuntu 12.04 or Fedora 16
both of which use Linux 3.x.
-- 
Lawrence
