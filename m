Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:41590 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbbJBKZI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Oct 2015 06:25:08 -0400
Message-ID: <1443781507.3445.61.camel@pengutronix.de>
Subject: Re: iMX6 CSI capture support?
From: Philipp Zabel <p.zabel@pengutronix.de>
To: David =?ISO-8859-1?Q?M=FCller?= <dave.mueller@gmx.ch>
Cc: Linux Media <linux-media@vger.kernel.org>
Date: Fri, 02 Oct 2015 12:25:07 +0200
In-Reply-To: <560D4440.6030904@gmx.ch>
References: <560D4440.6030904@gmx.ch>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi David,

Am Donnerstag, den 01.10.2015, 16:33 +0200 schrieb David Müller:
> Hello
> 
> Some time ago, there were some patches around implementing CSI capture
> support for the iMX6 IPU.
> 
> It seems like these patches never made it into the vanilla kernel tree.
> 
> What is the status of iMX6 CSI capture support?
> 
> Thank you

I'm working on this on and off, whenever I find (or get allotted) time.
Mainly the media entity abstraction has to be reworked to only include
the IPU blocks that have actual direct hardware connections (CSI0/1,
VDIC, IC). And since the two IPUs share the same media device graph,
the media controller setup has to use the managed media controller API.

best regards
Philipp

