Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52733 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932767Ab2GDIIT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jul 2012 04:08:19 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1SmKdD-0004OX-Fu
	for linux-media@vger.kernel.org; Wed, 04 Jul 2012 10:08:15 +0200
Received: from cgv79.neoplus.adsl.tpnet.pl ([83.30.249.79])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 04 Jul 2012 10:08:15 +0200
Received: from acc.for.news by cgv79.neoplus.adsl.tpnet.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 04 Jul 2012 10:08:15 +0200
To: linux-media@vger.kernel.org
From: Marx <acc.for.news@gmail.com>
Subject: Re: pctv452e
Date: Wed, 04 Jul 2012 09:51:49 +0200
Message-ID: <l99dc9-9hf.ln1@wuwek.kopernik.gliwice.pl>
References: <4FF1CD63.10003@nexusuk.org> <oikac9-mbk.ln1@wuwek.kopernik.gliwice.pl> <4FF37A83.2030707@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <4FF37A83.2030707@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04.07.2012 01:04, Antti Palosaari wrote:
> Your claims about my DVB-USB-framework work is quite bullshit. I am not
> going to convert all drivers to the new framework just doing compile
> tests.

I'm not bashing you, I see you are doing very good job, and not only you 
but many people here. I don't like mess and refactoring is good thing. 
The problem is that often makers of hardware doesn't support their linux 
drivers and changes in DVB core doesn't help it.
Like with pctv452e - device was working, i've bought it as supported and 
now it works only partially.
I don't think there is easy solution to that problem. Card maker should 
support drivers but in reality we should be happy if he do any working 
driver for linux.

And thank you for modified driver, I will try it at home and of course 
will write how it is working.
Marx

