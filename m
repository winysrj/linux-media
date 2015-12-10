Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58739 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbbLJKuP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2015 05:50:15 -0500
Date: Thu, 10 Dec 2015 08:50:09 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Rafael =?UTF-8?B?TG91cmVuw6dv?= de Lima Chehab
	<chehabrafael@gmail.com>, Hans Verkuil <hans.verkuil@cisco.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Antti Palosaari <crope@iki.fi>,
	Tommi Franttila <tommi.franttila@intel.com>
Subject: Re: [PATCH] [media] v4l2-core: create MC interfaces for devnodes
Message-ID: <20151210085009.47756e5a@recife.lan>
In-Reply-To: <6acbad49047e51a12d6186a6cb563d5d058e5104.1449743222.git.mchehab@osg.samsung.com>
References: <6acbad49047e51a12d6186a6cb563d5d058e5104.1449743222.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 10 Dec 2015 08:32:21 -0200
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> V4L2 device (and subdevice) nodes should create an interface, if the
> Media Controller support is enabled.
> 
> Please notice that radio devices should not create an entity, as radio
> input/output is either via wires or via ALSA.
> 
> PS.: Before this patch, au0828 should remove the media_device earlier.
> However, after the core changes, this should be postponed, otherwise
> an OOPS occurs. So, fold the au0828 changes on this patch.
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---
> 
> PS.: I'm adding this patch just after "media-device: remove interfaces and interface links".
> 
> It prevents some troubles with DEBUG_KMEMLEAK and KASAN, with makes
> them to hang the Kernel during physical device removal (or device driver
> removal). Without this, we get this error:
> 
> 	kasan: GPF could be caused by NULL-ptr deref or user memory accessgeneral protection fault: 0000 [#1] SMP KASAN


Sorry, I ended by sending the wrong patch. Please ignore this e-mail.

Regards,
Mauro
