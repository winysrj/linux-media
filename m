Return-path: <linux-media-owner@vger.kernel.org>
Received: from heidi.turbocat.net ([88.198.202.214]:33496 "EHLO
	mail.turbocat.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbbEFN3U (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 May 2015 09:29:20 -0400
Message-ID: <554A175D.6030103@selasky.org>
Date: Wed, 06 May 2015 15:30:05 +0200
From: Hans Petter Selasky <hps@selasky.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Felix Janda <felix.janda@posteo.de>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/4] Wrap LFS64 functions only if __GLIBC__
References: <20150125203636.GC11999@euler> <20150505093402.4c29d565@recife.lan>
In-Reply-To: <20150505093402.4c29d565@recife.lan>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/05/15 14:34, Mauro Carvalho Chehab wrote:
> I'm afraid that removing the above would break for FreeBSD, as I think
> it also uses glibc, but not 100% sure.
>
> So, either we should get an ack from Hans Peter, or you should
> change the tests to:
>
> 	#if linux && __GLIBC__

Hi,

Linux might be defined when compiling webcamd. The following should be fine:

-#ifdef linux
+#if defined(linux) && defined(__GLIBC__)

Thank you!

--HPS
