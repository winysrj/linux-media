Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45971 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab2JVHIO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Oct 2012 03:08:14 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1TQC7X-0003UR-Ee
	for linux-media@vger.kernel.org; Mon, 22 Oct 2012 09:08:19 +0200
Received: from dwv46.neoplus.adsl.tpnet.pl ([83.22.81.46])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 22 Oct 2012 09:08:19 +0200
Received: from acc.for.news by dwv46.neoplus.adsl.tpnet.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 22 Oct 2012 09:08:19 +0200
To: linux-media@vger.kernel.org
From: Marx <acc.for.news@gmail.com>
Subject: Re: Config does not allow DVB USB cards in 3.6 kernel
Date: Mon, 22 Oct 2012 08:57:48 +0200
Message-ID: <gc7fl9-k1u.ln1@wuwek.kopernik.gliwice.pl>
References: <20121022052006.A8BE5B830@nebuchadnezzar.smejdil.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <20121022052006.A8BE5B830@nebuchadnezzar.smejdil.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22.10.2012 07:20, cijoml@volny.cz wrote:
> Hello,
> I use several USB DVBT tuners. Till 3.5 kernel I was able to compile
> kernel with support for them. Since 3.6, the oldconfig does not enable
> support even it is present in .config.
> Would anybody tell me which feature must be enabled in 3.6 to enable
> DVB-T tuners?
> I checked KCONFIG and I would say I have everything included...
> My .config for 3.5.7 kernel is included.
> Thank you for your help
> Best regards
> Michal

I had the same problem with a few different 3.6 kernel versions. There 
is no official statement but I suspect it's caused by refactoring of v4l 
and rewriting drivers into new driver model.
There are much more dvb drivers in 3.7 kernel (but probably still not 
all of those existing in 3.5).
So I think 3.5 is for now last kernel which can be used in HTPCs/PVRs. 
It's pity that such important shortcoming  has no clear info in log of 
kernel changes.
Seeing progress in 3.7 I see that probably 3.8 will gain most of DVB 
drivers.
Marx

