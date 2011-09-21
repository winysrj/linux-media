Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:58347 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478Ab1IUI3h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Sep 2011 04:29:37 -0400
Received: from tele (unknown [IPv6:2a01:e35:2f5c:9de0:212:bfff:fe1e:8db5])
	by smtp1-g21.free.fr (Postfix) with ESMTP id D9F52940026
	for <linux-media@vger.kernel.org>; Wed, 21 Sep 2011 10:29:30 +0200 (CEST)
Date: Wed, 21 Sep 2011 10:29:46 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Question about USB interface index restriction in gspca
Message-ID: <20110921102946.070192df@tele>
In-Reply-To: <4E77A258.3050806@googlemail.com>
References: <4E6FAB94.2010007@googlemail.com>
	<20110914082513.574baac2@tele>
	<4E727251.9030308@googlemail.com>
	<20110916083302.1deb338e@tele>
	<4E77A258.3050806@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 19 Sep 2011 22:13:12 +0200
Frank Schäfer <fschaefer.oss@googlemail.com> wrote:

> > So, if your webcam is in the 99.99% which use the interface 0, use
> > gspca_dev_probe(), otherwise, YOU know the right interface, so, call
> > gspca_dev_probe2().  
> 
> Isn't it also possible that we don't know the right interface and it is 
> not interface 0 ? ;-)

I hope that the interface does not change each time you unplug/replug the
webcam :), but if different webcams with a same device ID may use
different interfaces, you should have to develop specific code in the
subdriver...

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
