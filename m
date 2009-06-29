Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:53286 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbZF2HZS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2009 03:25:18 -0400
Date: Mon, 29 Jun 2009 09:25:41 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Peter =?ISO-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: Re: Problem with 046d:08af Logitech Quickcam Easy/Cool - broken
 with in-kernel drivers, works with gspcav1
Message-ID: <20090629092541.2be8f020@free.fr>
In-Reply-To: <200906282250.58652.PeterHuewe@gmx.de>
References: <200906281514.10689.PeterHuewe@gmx.de>
	<20090628201447.792efe63@free.fr>
	<200906282250.58652.PeterHuewe@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 28 Jun 2009 22:50:58 +0200
Peter Hüwe <PeterHuewe@gmx.de> wrote:
 
> I tried using cheese with 
> LD_PRELOAD=/usr/lib64/libv4l/v4l1compat.so - and it works!
> 
> However this does not work with skype :/ (skype does not allow
> preloading)
> 
> Any suggestions how I get skype to use the compat wrapper?

Hi Peter,

You must export LD_PRELOAD. I use a simple script:

	#!/bin/sh
	export LD_PRELOAD=/usr/lib/libv4l/v4l1compat.so
	exec /usr/bin/skype

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
