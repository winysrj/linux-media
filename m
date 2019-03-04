Return-Path: <SRS0=0You=RH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87FD9C43381
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 17:32:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EAE52070B
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 17:32:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbfCDRcC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Mar 2019 12:32:02 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:36313 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbfCDRcA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2019 12:32:00 -0500
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1h0rRR-0007KJ-KJ; Mon, 04 Mar 2019 18:31:53 +0100
Received: from mfe by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1h0rRP-0007IR-Ig; Mon, 04 Mar 2019 18:31:51 +0100
Date:   Mon, 4 Mar 2019 18:31:51 +0100
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     hans.verkuil@cisco.com, mchehab@kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, graphics@pengutronix.de
Subject: Re: [PATCH 3/3] media: tc358746: update MAINTAINERS file
Message-ID: <20190304173151.zwrwuwrepzeegfa3@pengutronix.de>
References: <20181218141240.3056-1-m.felsch@pengutronix.de>
 <20181218141240.3056-4-m.felsch@pengutronix.de>
 <20190218114608.qvoeyxlaw4yjrnnh@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190218114608.qvoeyxlaw4yjrnnh@paasikivi.fi.intel.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 18:30:49 up 44 days, 22:12, 47 users,  load average: 0.05, 0.04,
 0.00
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sakari,

On 19-02-18 13:46, Sakari Ailus wrote:
> Hi Marco,
> 
> On Tue, Dec 18, 2018 at 03:12:40PM +0100, Marco Felsch wrote:
> > Add me as partial maintainer, others are welcome too.
> > 
> > Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> > ---
> >  MAINTAINERS | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 546f8d936589..f97dedbe545c 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -15230,6 +15230,13 @@ S:	Maintained
> >  F:	drivers/media/i2c/tc358743*
> >  F:	include/media/i2c/tc358743.h
> >  
> > +TOSHIBA TC358746 DRIVER
> > +M:	Marco Felsch <kernel@pengutronix.de>
> > +L:	linux-media@vger.kernel.org
> > +S:	Odd Fixes
> > +F:	drivers/media/i2c/tc358746*
> > +F:	Documentation/devicetree/bindings/media/i2c/toshiba,tc358746.txt
> > +
> >  TOSHIBA WMI HOTKEYS DRIVER
> >  M:	Azael Avalos <coproscefalo@gmail.com>
> >  L:	platform-driver-x86@vger.kernel.org
> 
> This should go together with the DT bindings, in the same patch.
> 
> I'd expect a new driver to be listed as "Maintained". "Odd Fixes" suggests
> no-one is particularly looking after it, and it's not nice if a new driver
> starts off like that. :-I

Okay, I will squash it in the v2 and set the status to "Maintained".

Regards,
Marco
 
> -- 
> Kind regards,
> 
> Sakari Ailus
> sakari.ailus@linux.intel.com
> 

