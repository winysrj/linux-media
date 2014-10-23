Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46204 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932336AbaJWNNx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Oct 2014 09:13:53 -0400
Message-ID: <1414070019.3854.5.camel@pengutronix.de>
Subject: Re: [PATCH v2] [media] coda: Improve runtime PM support
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Kamil Debski <k.debski@samsung.com>, linux-media@vger.kernel.org,
	Sascha Hauer <kernel@pengutronix.de>,
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Kevin Hilman <khilman@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Date: Thu, 23 Oct 2014 15:13:39 +0200
In-Reply-To: <CAPDyKFropocTuz-3rsQU_Ft-eTQAavn+P4ef4d2Qd0kuhSK3WQ@mail.gmail.com>
References: <1411401956-29330-1-git-send-email-p.zabel@pengutronix.de>
	 <CAPDyKFqSgpOCvXp0aVVTFDj5X6fYkigThXM1VKK_vTWrjhpx6A@mail.gmail.com>
	 <1414065430.3854.3.camel@pengutronix.de>
	 <CAPDyKFropocTuz-3rsQU_Ft-eTQAavn+P4ef4d2Qd0kuhSK3WQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ulf,

Am Donnerstag, den 23.10.2014, 14:15 +0200 schrieb Ulf Hansson:
> > At what point is the pm domain supposed to be enabled when I load the
> > module?
> 
> Hi Philipp,
> 
> The PM domain shall be powered on prior your driver starts probing.
> This is a common problem when using the generic PM domain. The
> workaround, which is causing other issues, is a pm_runtime_get_sync().
> 
> Now, could you please try to apply the below patchset, that should
> hopefully fix your issue:
> 
> [PATCH v3 0/9] PM / Domains: Fix race conditions during boot
> http://marc.info/?l=linux-pm&m=141320895122707&w=2

thank you, that series does fix the issue.

regards
Philipp

