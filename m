Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:44478 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbZCMANJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 20:13:09 -0400
Date: Thu, 12 Mar 2009 17:13:06 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Alan McIvor <alan.mcivor@reveal.co.nz>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] Add support for ProVideo PV-183 to bttv
In-Reply-To: <20090313114649.e774c9be.alan.mcivor@reveal.co.nz>
Message-ID: <Pine.LNX.4.58.0903121711370.28292@shell2.speakeasy.net>
References: <20090313114649.e774c9be.alan.mcivor@reveal.co.nz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 13 Mar 2009, Alan McIvor wrote:
> +
> +        { 0x15401830, BTTV_BOARD_PV183,         "Provideo PV183-1" },
> +        { 0x15401831, BTTV_BOARD_PV183,         "Provideo PV183-2" },
> +        { 0x15401832, BTTV_BOARD_PV183,         "Provideo PV183-3" },
> +        { 0x15401833, BTTV_BOARD_PV183,         "Provideo PV183-4" },
> +        { 0x15401834, BTTV_BOARD_PV183,         "Provideo PV183-5" },
> +        { 0x15401835, BTTV_BOARD_PV183,         "Provideo PV183-6" },
> +        { 0x15401836, BTTV_BOARD_PV183,         "Provideo PV183-7" },
> +        { 0x15401837, BTTV_BOARD_PV183,         "Provideo PV183-8" },
> +
>  	{ 0, -1, NULL }
>  };

Looks like you used spaces here instead of tabs.  If you run make commit
from the v4l-dvb tree it will fix these things.
