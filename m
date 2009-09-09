Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:57914 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbZIINDP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Sep 2009 09:03:15 -0400
Subject: Re: [PATCHv15 7/8] FM TX: si4713: Add Kconfig and Makefile entries
From: m7aalton <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>
Cc: ext Hans Verkuil <hverkuil@xs4all.nl>,
	ext Mauro Carvalho Chehab <mchehab@infradead.org>,
	ext Douglas Schilling Landgraf <dougsland@gmail.com>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	Linux-Media <linux-media@vger.kernel.org>
In-Reply-To: <1249729833-24975-8-git-send-email-eduardo.valentin@nokia.com>
References: <1249729833-24975-1-git-send-email-eduardo.valentin@nokia.com>
	 <1249729833-24975-2-git-send-email-eduardo.valentin@nokia.com>
	 <1249729833-24975-3-git-send-email-eduardo.valentin@nokia.com>
	 <1249729833-24975-4-git-send-email-eduardo.valentin@nokia.com>
	 <1249729833-24975-5-git-send-email-eduardo.valentin@nokia.com>
	 <1249729833-24975-6-git-send-email-eduardo.valentin@nokia.com>
	 <1249729833-24975-7-git-send-email-eduardo.valentin@nokia.com>
	 <1249729833-24975-8-git-send-email-eduardo.valentin@nokia.com>
Content-Type: text/plain
Date: Wed, 09 Sep 2009 16:02:51 +0300
Message-Id: <1252501371.19083.99.camel@masi.ntc.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2009-08-08 at 13:10 +0200, Valentin Eduardo (Nokia-D/Helsinki)
wrote:
> Simple add Makefile and Kconfig entries.
> 

...

> +	  Say Y here if you want support to Si4713 FM Radio Transmitter.
> +	  This device can transmit audio through FM. It can transmit
> +	  EDS and EBDS signals as well. This module is the v4l2 radio
            ^^^     ^^^^

These should be RDS and RBDS?

Cheers,
Matti A.


