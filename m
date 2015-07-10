Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41332 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201AbbGJNjJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jul 2015 09:39:09 -0400
Message-ID: <1436535548.3850.46.camel@pengutronix.de>
Subject: Re: [PATCH 01/53] [media] coda: Use S_PARM to set nominal framerate
 for h.264 encoder
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <kamil@wypas.org>
Cc: linux-media@vger.kernel.org, kernel@pengutronix.de
Date: Fri, 10 Jul 2015 15:39:08 +0200
In-Reply-To: <1436535406-13575-1-git-send-email-p.zabel@pengutronix.de>
References: <1436535406-13575-1-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Freitag, den 10.07.2015, 15:35 +0200 schrieb Philipp Zabel:
> The encoder needs to know the nominal framerate for the constant bitrate
> control mechanism to work. Currently the only way to set the framerate is
> by using VIDIOC_S_PARM on the output queue.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Sorry, please ignore this one. I forgot to add -1 to the git send-email
prompt.

regards
Philipp

