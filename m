Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:55655
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751132AbdH0Owo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 27 Aug 2017 10:52:44 -0400
Date: Sun, 27 Aug 2017 11:52:33 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: <Yasunari.Takiguchi@sony.com>
Cc: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <tbird20d@gmail.com>,
        <frowand.list@gmail.com>,
        Masayuki Yamamoto <Masayuki.Yamamoto@sony.com>,
        Hideki Nozawa <Hideki.Nozawa@sony.com>,
        "Kota Yonezawa" <Kota.Yonezawa@sony.com>,
        Toshihiko Matsumoto <Toshihiko.Matsumoto@sony.com>,
        Satoshi Watanabe <Satoshi.C.Watanabe@sony.com>
Subject: Re: [PATCH v3 05/14] [media] cxd2880: Add tuner part of the driver
Message-ID: <20170827115233.736ac717@vento.lan>
In-Reply-To: <20170827114544.39865dbb@vento.lan>
References: <20170816041714.20551-1-Yasunari.Takiguchi@sony.com>
        <20170816043714.21394-1-Yasunari.Takiguchi@sony.com>
        <20170827114544.39865dbb@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 27 Aug 2017 11:45:44 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:

> Em Wed, 16 Aug 2017 13:37:14 +0900
> <Yasunari.Takiguchi@sony.com> escreveu:
> 
> > From: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
> > 
> > This part of the driver has the main routines to handle
> > the tuner and demodulator functionality.  The tnrdmd_mon.* files
> > have monitor functions for the driver.
> > This is part of the Sony CXD2880 DVB-T2/T tuner + demodulator driver.
> 
> This series is on a much better state. Thanks!
> 
> Patches 1-4 sound ok to me.
> 
> Still, there are a few issues on this patch. See below.
> 
> > 
> > [Change list]
> > Changes in V3
> >    drivers/media/dvb-frontends/cxd2880/cxd2880_dtv.h
> >       -removed code relevant to ISDB-T

Forgot to mention... Just a small detail: the change list is important for
us to understand the differences between submitted versions, but it makes
no sense to track them when patches get merged upstream, as the previous
versions of the patches won't be there at the git history.

So, please put change lists after a blank line with just "---", e. g.:


	From: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>

	This part of the driver has the main routines to handle
	the tuner and demodulator functionality.  The tnrdmd_mon.* files
	have monitor functions for the driver.
	This is part of the Sony CXD2880 DVB-T2/T tuner + demodulator driver.

	---

	(change list and whatever other notes that are relevant to the
	 patch reviewers but won't be merged upstream)

The reason is simple: Kernel maintainers' scripts will just remove
everything after the "---" line when applying the series ;-)

Thanks,
Mauro
