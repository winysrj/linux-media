Return-path: <linux-media-owner@vger.kernel.org>
Received: from viefep11-int.chello.at ([62.179.121.31]:6043 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbZL2KoE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Dec 2009 05:44:04 -0500
Message-ID: <4B39DD6D.3030308@waechter.wiz.at>
Date: Tue, 29 Dec 2009 11:43:57 +0100
From: =?UTF-8?B?TWF0dGhpYXMgV8OkY2h0ZXI=?= <matthias@waechter.wiz.at>
MIME-Version: 1.0
To: Leszek Koltunski <leszek@koltunski.pl>
CC: linux-media@vger.kernel.org
Subject: Re: MANTIS / STB0899 / STB6100 card ( Twinhan VP-1041): problems
 locking 	to transponder
References: <8cd7f1780912290138q1a58d3a5xa444a9cdcd577cfd@mail.gmail.com>
In-Reply-To: <8cd7f1780912290138q1a58d3a5xa444a9cdcd577cfd@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 29.12.2009 10:38, schrieb Leszek Koltunski:
> Now , some more info:
> 
> 1. I've connected a satellite set-top-box to the signal and the STB
> can tune to and watch channels from both transponders with no problems
> at all.
> That IMHO proves that the signal is all right and the problem lies in
> the drivers, or maybe in dvbstream. ( or hopefully between the chair
> and the keyboard )
> 
> 2. I can ONLY tune to the 'freq 1150 / sr 28125' transponder. All
> others fail.  But with that one I have no problems at all, I tunes
> 100% of the time; I got it to stream for 4 days straight with no
> problems.
> 
> 3. You can see that both transponders are C-BAND , H polarization, so
> theoretically, AFAIK, if I can tune to the '1150' transponder, I
> should be able to tune to the '1190' one with no magic at all, am I
> wrong here?

The same combination of devices (Mantis, STB0899, STB6100) is used in
various cards, and at my side they still have tuning issues.

A few weeks ago, Austrian TV started to feed their transponder theirself
instead by Astra, and from that moment on it was impossible to tune to
that transponder. After some days they switched off spectral inversion,
and the cards were now able to tune again.

Furthermore, tuning is unstable here when signal quality is not optimal
leading to driver lock-ups. After a reload, tuning is again possible.

Beside some hard reboots caused by the xineliboutput/vdpau frontend,
this is the one remaining major problem at my setup.

> Could anyone shed some light on this?

– Matthias
