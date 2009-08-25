Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:43882 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460AbZHYKD5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2009 06:03:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Martin Fuzzey <mfuzzey@gmail.com>
Subject: Re: bug in pwc_set_shutter_speed v2.6.30.5 and fix
Date: Tue, 25 Aug 2009 12:07:06 +0200
Cc: treece@gsp.org, linux-media@vger.kernel.org
References: <1251061440.7262.8.camel@stoppy.bicycle.org>
In-Reply-To: <1251061440.7262.8.camel@stoppy.bicycle.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200908251207.06069.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 23 August 2009 23:04:00 Jef Treece wrote:
> I found in recent kernel versions, I think somewhere between 2.6.29.3
> and 2.6.30.3, pwc_set_shutter_speed regressed.
>
> I was able to fix it with this one-line change
> (drivers/media/video/pwc/pwc-ctrl.c line 755 in 2.6.30.5 source):
>
> 	ret = send_control_msg(pdev,
> 		SET_LUM_CTL, SHUTTER_MODE_FORMATTER, &buf, sizeof(buf));
>
> change to
>
> 	ret = send_control_msg(pdev,
> 		SET_LUM_CTL, SHUTTER_MODE_FORMATTER, &buf, 1);
>
> I hope you find this information useful.

This indeed looks like a regression to me.

Martin, as you've introduced the problem, could you look into it and send a 
patch ? There might be other occurrences of wrong integer -> sizeof 
conversions, so please review them carefully.

-- 
Regards,

Laurent Pinchart
