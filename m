Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.juropnet.hu ([212.24.188.131]:48404 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab0AGTrL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Jan 2010 14:47:11 -0500
Received: from kabelnet-196-187.juropnet.hu ([91.147.196.187])
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1NSyHf-0003Y4-Ll
	for linux-media@vger.kernel.org; Thu, 07 Jan 2010 20:44:42 +0100
Message-ID: <4B463AC6.2000901@mailbox.hu>
Date: Thu, 07 Jan 2010 20:49:26 +0100
From: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: DTV2000 H Plus issues
References: <4B3F6FE0.4040307@internode.on.net> <4B3F7B0D.4030601@mailbox.hu> <4B405381.9090407@internode.on.net> <4B421BCB.6050909@mailbox.hu> <4B4294FE.8000309@internode.on.net>
In-Reply-To: <4B4294FE.8000309@internode.on.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/05/2010 02:25 AM, Raena Lea-Shannon wrote:

> Thanks. Will try again later.

By the way, for those who would like to test it, here is a patch based
on Devin Heitmueller's XC4000 driver and Mirek Slugen's older patch,
that adds support for this card:
  http://www.sharemation.com/IstvanV/v4l/dtv2000h+.patch
It can be applied to this version of the v4l-dvb code:
  http://linuxtv.org/hg/v4l-dvb/archive/75c97b2d1a2a.tar.bz2
This is experimental code, so use it at your own risk. The analogue
parts (TV and FM radio) basically work, although there are some minor
issues to be fixed. Digital TV is not tested yet, but is theoretically
implemented; reports on whether it actually works are welcome.
The XC4000 driver also requires a firmware file:
  http://www.sharemation.com/IstvanV/v4l/dvb-fe-xc4000-1.4.1.fw
