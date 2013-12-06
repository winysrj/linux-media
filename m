Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp0.epfl.ch ([128.178.224.218]:48677 "EHLO smtp0.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757613Ab3LFKht (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Dec 2013 05:37:49 -0500
Message-ID: <52A1A76A.6070301@epfl.ch>
Date: Fri, 06 Dec 2013 11:31:06 +0100
From: Florian Vaussard <florian.vaussard@epfl.ch>
Reply-To: florian.vaussard@epfl.ch
MIME-Version: 1.0
To: Enrico <ebutera@users.berlios.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: omap3isp device tree support
References: <CA+2YH7ueF46YA2ZpOT80w3jTzmw0aFWhfshry2k_mrXAmW=MXA@mail.gmail.com>
In-Reply-To: <CA+2YH7ueF46YA2ZpOT80w3jTzmw0aFWhfshry2k_mrXAmW=MXA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 12/06/2013 11:13 AM, Enrico wrote:
> Hi,
> 
> i know there is some work going on for omap3isp device tree support,
> but right now is it possible to enable it in some other way in a DT
> kernel?
> 

The DT support is not yet ready, but an RFC binding has been proposed.
It won't be ready for 3.14.

> I've tried enabling it in board-generic.c (omap3_init_camera(...) with
> proper platform data) but it hangs early at boot, do someone know if
> it's possible and how to do it?
> 

I did the same a few days ago, and went through several problems
(panics, half DT support,...). Now I am able to probe the ISP, I still
have one kernel panic to fix. Hope to send the patches in 1 or 2 days.
We are still in a transition period, but things should calm down in the
coming releases.

Cheers,

Florian

[1] http://www.spinics.net/lists/linux-media/msg69424.html
