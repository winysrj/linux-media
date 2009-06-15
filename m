Return-path: <linux-media-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:57790 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754622AbZFRJuC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2009 05:50:02 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1MHEFu-0003ZL-7q
	for linux-media@vger.kernel.org; Thu, 18 Jun 2009 09:50:02 +0000
Received: from cs27111223.pp.htv.fi ([89.27.111.223])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 18 Jun 2009 09:50:02 +0000
Received: from ay by cs27111223.pp.htv.fi with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 18 Jun 2009 09:50:02 +0000
To: linux-media@vger.kernel.org
From: ay@nospam.invalid (Ari =?iso-8859-1?Q?Yrj=F6l=E4?=)
Subject: Re: Digital Everywhere FloppyDTV / FireDTV (incl. CI)
Date: Mon, 15 Jun 2009 22:42:14 +0300
Message-ID: <87eitlmgh5.fsf@galileo.zzint>
References: <4A197CE8.9040404@gmail.com> <4A26832B.5060508@nildram.co.uk> <e9a4f5af0906040530k3dc3095ofa621459e7eb0d12@mail.gmail.com>
Reply-To: ay@hut.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"Johannes T. K." <linuxmedia@tangkristensen.dk> writes:

>>
>> If anyone has been able to tune the cable adapter under linux I'd like to
>> hear more.
>>
>
> I have a firedtv c/ci which I have had some success with in linux. I
> have no problem tuning and watching/recoding programs as long as they
> are not scrambled.

Same here, the CI part is useless with firedtv driver. I have
self-compiled VDR v1.7.7 running with xine-plugin on Debian
testing/unstable 2.6.29 x86_64, and there's no CAM menu available in
VDR's setup screen. Tested with older SCM Conax and now CAS7 capable NP4
Conax CAM, no success. Both CAMs work fine with Sony Bravia V3000, and
SCM card was working fine in a Technotrend T1500+CI (DVB-T) with VDR v1.4.7.

Updating firmware of my FloppyDTV C/CI (which can only be done on a
Windows box, great) didn't help anything either, but it seems to have
made things even worse. Now there's occasional errors like

Jun 15 21:40:04 silver kernel: firedtv 00128726020026b2-0: FCP response timed out

which didn't show up before firmware update. Now VDR recordings from FTA
channels fail sometimes too, and kernel log gets filled with 

DVB (dvb_dmxdev_filter_start): could not alloc feed


