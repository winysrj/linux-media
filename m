Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:49676 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbbC0RY1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2015 13:24:27 -0400
Message-ID: <55159248.6010204@gmx.com>
Date: Fri, 27 Mar 2015 18:24:24 +0100
From: Ole Ernst <olebowle@gmx.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, Nibble Max <nibble.max@gmail.com>
CC: "olli.salonen" <olli.salonen@iki.fi>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: cx23885: DVBSky S952 dvb_register failed err = -22
References: <5504920C.7080806@gmx.com>, <55055E66.6040600@gmx.com>, <550563B2.9010306@iki.fi>, <201503170953368436904@gmail.com> <201503180940386096906@gmail.com> <55093FFC.9050602@gmx.com> <55105683.40809@iki.fi> <551081CF.3080901@gmx.com> <5510992C.8060608@iki.fi> <551157AB.1090704@gmx.com> <55115E93.7030405@iki.fi> <55117A22.6010302@gmx.com> <5511811A.3010009@iki.fi> <5511C040.7040802@gmx.com>
In-Reply-To: <5511C040.7040802@gmx.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

I was able to test your current tree (8a56b6b..754594d) without SCR and
the frontends still run into a timeout. There seems to be an issue with
the patch in general. Is there something else I can test/try or do you
require some debug output?

Thanks,
Ole

Am 24.03.2015 um 20:51 schrieb Ole Ernst:
> Am 24.03.2015 um 16:22 schrieb Antti Palosaari:
>> Someone has reported SCR/Unicable does not work with that demod driver,
>> but I have no personal experience from whole thing... Could you try
>> direct connection to LNB?
> 
> I will test a direct connection over Easter, as I don't have physical
> access to the htpc right now. I will try to get someone else to test
> your patch, who hopefully doesn't use SCR.
> 
> Ole
