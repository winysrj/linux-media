Return-path: <mchehab@pedra>
Received: from smtp3-g21.free.fr ([212.27.42.3]:37272 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457Ab1AJULS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 15:11:18 -0500
Date: Mon, 10 Jan 2011 21:11:28 +0100
From: Thierry Merle <thierry.merle@free.fr>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PATCHES FOR 2.6.38] usbvision BKL removal and cleanup
Message-ID: <20110110211128.3afe0c8e@gorbag.houroukhai.org>
In-Reply-To: <201012291756.37115.hverkuil@xs4all.nl>
References: <201012291756.37115.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

Le Wed, 29 Dec 2010 17:56:36 +0100,
Hans Verkuil <hverkuil@xs4all.nl> a écrit :

> Hi Mauro,
> 
> The first patch converts usbvision to core-assisted locking, the
> others do a big coding style cleanup.
> 
> I want to clean up this driver in the future, so the first step is to
> fix all the coding style violations first. That way I can actually
> read the source code :-)
> 

Good intention. This is something I wanted to do but lack of time.
There is a compression algorithm in this driver that should go into
userspace. I think this is the hardest part.
I can help for the cleanup but cannot lead it right now.

Regards,
Thierry
