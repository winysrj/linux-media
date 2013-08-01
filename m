Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:19671 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685Ab3HARPZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Aug 2013 13:15:25 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MQV004AV3WKUY60@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 01 Aug 2013 13:15:23 -0400 (EDT)
Date: Thu, 01 Aug 2013 14:15:18 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Luis Polasek <pola@sol.info.unlp.edu.ar>,
	linux-media@vger.kernel.org,
	"jbucar@lifia.info.unlp.edu.ar" <jbucar@lifia.info.unlp.edu.ar>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: dib8000 scanning not working on 3.10.3
Message-id: <20130801141518.258ff0a3@samsung.com>
In-reply-to: <20130801163624.GA10498@localhost>
References: <CAER7dwe+kkVoDbRt9Xj8+77tJnL29bxRzHbSPYOrck_HxVsENw@mail.gmail.com>
 <CAER7dwe8UQZ=5iZhCi1C1-DGi7t_Hz43M4QamnBSNerHNnDCvg@mail.gmail.com>
 <20130801163624.GA10498@localhost>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 1 Aug 2013 13:36:25 -0300
Ezequiel Garcia <ezequiel.garcia@free-electrons.com> escreveu:

> Hi Luis,
> 
> (I'm Ccing Mauro, who mantains this driver and might know what's going on).
> 
> On Wed, Jul 31, 2013 at 03:47:10PM -0300, Luis Polasek wrote:
> > Hi, I just upgraded my kernel to 3.10.3, and dib8000 scanning does not
> > work anymore.
> > 
> > I tested using dvbscan (from dvb-apps/util/) and w_scan on a Prolink
> > Pixelview SBTVD (dib8000 module*).This tools worked very well on
> > version 3.9.9 , but now it does not produces any result, and also
> > there are no error messages in the logs (dmesg).
> > 
> 
> Please run a git bisect and report your findings.
> 
> Note that dibcom8000 shows just a handful of commit on 2013,
> so you could start reverting those and see what happens.

Perhaps it is a failure at the DVBv3 emulation.

Did it also break using dvbv5-scan (part of v4l-utils)?

Regards,
Mauro
-- 

Cheers,
Mauro
