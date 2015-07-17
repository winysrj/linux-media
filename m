Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58970 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757967AbbGQLAO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2015 07:00:14 -0400
Message-ID: <1437130811.3254.1.camel@pengutronix.de>
Subject: Re: [PATCH 3/5] [media] tc358743: support probe from device tree
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mats Randgaard <matrandg@cisco.com>, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, kernel@pengutronix.de
Date: Fri, 17 Jul 2015 13:00:11 +0200
In-Reply-To: <55A4E154.8020309@xs4all.nl>
References: <1436533897-3060-1-git-send-email-p.zabel@pengutronix.de>
		 <1436533897-3060-3-git-send-email-p.zabel@pengutronix.de>
		 <55A39982.3030006@xs4all.nl> <1436868605.3793.24.camel@pengutronix.de>
	 <55A4E154.8020309@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Dienstag, den 14.07.2015, 12:15 +0200 schrieb Hans Verkuil:
[...]
> As you said, it's not public and without the formulas there is nothing you
> can do but hardcode it.
> 
> If I understand this correctly these values depend on the link frequency,
> so the DT should contain the link frequency and the driver can hardcode the
> values based on that. Which means that if someone needs to support a new
> link frequency the driver needs to be extended for that frequency.
> 
> As long as Toshiba keeps the formulas under NDA there isn't much else you can
> do.

Ok.

[...]
> >>>  	/* platform data */
> >>> -	if (!pdata) {
> >>> -		v4l_err(client, "No platform data!\n");
> >>> -		return -ENODEV;
> >>> +	if (pdata) {
> >>> +		state->pdata = *pdata;
> >>> +	} else {
> >>> +		err = tc358743_probe_of(state);
> >>> +		if (err == -ENODEV)
> >>> +			v4l_err(client, "No platform data!\n");
> >>
> >> I'd replace this with "No device tree data!" or something like that.
> > 
> > I'll do that, thank you.

On second thought, I'll keep it as is. The tc358743_probe_of function
prints its own error messages. In the platform data case it returns
-ENODEV, so that'd still be the correct message, then.

regards
Philipp

