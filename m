Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:10089 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030718AbaDCBlL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Apr 2014 21:41:11 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N3F002P6M0M5HB0@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 02 Apr 2014 21:41:10 -0400 (EDT)
Date: Wed, 02 Apr 2014 22:41:04 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: [ANNOUNCE] git web interface was changed to cgit
Message-id: <20140402224104.505dd740@samsung.com>
In-reply-to: <20140403005641.GA30534@hardeman.nu>
References: <20140402192651.7c9e3a74@samsung.com>
 <20140403005641.GA30534@hardeman.nu>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 03 Apr 2014 02:56:41 +0200
David Härdeman <david@hardeman.nu> escreveu:

> On Wed, Apr 02, 2014 at 07:26:51PM -0300, Mauro Carvalho Chehab wrote:
> >I changed today our git web interface from gitweb to cgit, due to seveal
> >reasons:
> ...
> >Please ping me if you fin any problems on it.
> 
> Hi,
> 
> one small thing I've noticed is that the repo links from
> http://linuxtv.org/cvs.php are broken now.

Thanks for noticing!

I added a rewrite rule. This way, the old URLs will still work.

Regards,
Mauro
