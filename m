Return-path: <linux-media-owner@vger.kernel.org>
Received: from vie01a-qmta-at02-1.mx.upcmail.net ([62.179.121.175]:10627 "EHLO
	vie01a-qmta-at02-1.mx.upcmail.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752354AbcFVOIm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2016 10:08:42 -0400
Received: from [172.31.218.22] (helo=vie01a-dmta-at01-1.mx.upcmail.net)
	by vie01a-pqmta-at02.mx.upcmail.net with esmtp (Exim 4.87)
	(envelope-from <hurda@chello.at>)
	id 1bFifD-0005tC-Ai
	for linux-media@vger.kernel.org; Wed, 22 Jun 2016 15:57:55 +0200
Received: from [172.31.216.43] (helo=vie01a-pemc-psmtp-pe01)
	by vie01a-dmta-at01.mx.upcmail.net with esmtp (Exim 4.87)
	(envelope-from <hurda@chello.at>)
	id 1bFifA-0005qB-OJ
	for linux-media@vger.kernel.org; Wed, 22 Jun 2016 15:57:52 +0200
Message-ID: <576A995F.2050505@chello.at>
Date: Wed, 22 Jun 2016 15:57:51 +0200
From: Hurda <hurda@chello.at>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Problems with Si2168 DVB-C card (cx23885)
References: <10ab0033-763e-94d8-f638-716c5b2507e8@ipvs.uni-stuttgart.de>
In-Reply-To: <10ab0033-763e-94d8-f638-716c5b2507e8@ipvs.uni-stuttgart.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> kernel: si2168 8-0064: found a 'Silicon Labs Si2168-B40'
> kernel: si2168 8-0064: downloading firmware from file
> 'dvb-demod-si2168-b40-01.fw'
> kernel: si2168 8-0064: firmware version: 4.0.19
>
>
> Distribution is Arch. Kernel version is 4.6.2.

IIRC you have to use firmware-version 4.0.11 in pre-4.8-kernels.
http://palosaari.fi/linux/v4l-dvb/firmware/Si2168/Si2168-B40/4.0.11/
There was a message on this mailing list a few weeks ago (May 21st, regarding 
DVBSky T330).

Might work with that.
