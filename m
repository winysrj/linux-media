Return-path: <linux-media-owner@vger.kernel.org>
Received: from 216-82-208-22.static.grandenetworks.net ([216.82.208.22]:48277
	"EHLO mx1.mthode.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934247AbaFTPc7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jun 2014 11:32:59 -0400
Received: from [10.6.185.150] (unknown [10.0.3.43])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.mthode.org (Postfix) with ESMTPSA id 8BB5D1807F
	for <linux-media@vger.kernel.org>; Fri, 20 Jun 2014 11:32:56 -0400 (EDT)
In-Reply-To: <CALzAhNUb_J+tcqaaRLm_x=pAVDNWZp6EFuPBGKiS4VMiVtRwag@mail.gmail.com>
References: <53A3CB23.2000209@gentoo.org> <CALzAhNUb_J+tcqaaRLm_x=pAVDNWZp6EFuPBGKiS4VMiVtRwag@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: pvrusb2 has a new device (wintv-hvr-1955)
From: Matthew Thode <prometheanfire@gentoo.org>
Date: Fri, 20 Jun 2014 10:31:36 -0500
To: Linux-Media <linux-media@vger.kernel.org>
Message-ID: <08c06a97-d24b-4eeb-9c3e-d7a923ec1ea1@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On June 20, 2014 7:29:42 AM CDT, Steven Toth <stoth@kernellabs.com> wrote:
>On Fri, Jun 20, 2014 at 1:48 AM, Matthew Thode
><prometheanfire@gentoo.org> wrote:
>> Just bought a wintv-hvr-1955 (sold as a wintv-hvr-1950)
>> 160111 LF
>> Rev B1|7
>
>Talk to Hauppauge, they've already announced that they have a working
>Linux driver.

I talked to them and they did say that the driver hasn't been upstreamed, also gave me some hardware info.  They wouldn't give me a driver/firmware that worked though and offered to RMA for an older device.

The demodulator is a Si2177, can't find anything about it in the kernel though.

They also mentioned a LG3306a, wasn't able to find anything on it (might have misheard a character).
-- Matthew Thode (prometheanfire)
