Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53270 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932473AbcCKQex (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2016 11:34:53 -0500
Date: Fri, 11 Mar 2016 13:34:47 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Rafael =?UTF-8?B?TG91cmVuw6dv?= de Lima Chehab
	<chehabrafael@gmail.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: Re: [PATCH 1/2] [media] au0828: disable tuner links and cache
 tuner/decoder
Message-ID: <20160311133447.31f9e3f5@recife.lan>
In-Reply-To: <56E2F1FC.1080405@osg.samsung.com>
References: <d14f3141901856eaed358ab049f4a3aac8fe4863.1457711514.git.mchehab@osg.samsung.com>
	<56E2F1FC.1080405@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 11 Mar 2016 09:27:40 -0700
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> On 03/11/2016 08:55 AM, Mauro Carvalho Chehab wrote:
> > For au0828_enable_source() to work, the tuner links should be
> > disabled and the tuner/decoder should be cached at au0828 struct.  
> 
> hmm. are you sure about needing to cache decoder in au0828 struct.
> It gets cached in au0828_card_analog_fe_setup() which is called
> from au0828_card_setup() - this step happens before
> au0828_media_device_register()
> 
> #ifdef CONFIG_MEDIA_CONTROLLER
>                 if (sd)
>                         dev->decoder = &sd->entity;
> #endif

I haven't check it. Yet, I guess the best would be to put those
caches all at au0828_media_device_register(). This way, it would be
easier to remember removing them, once we move au0828_enable_source
to the core.

(my plan is to take a look on it after the merge window, doing some
tests on more complex drivers, like em28xx and saa7134).

Regards,
Mauro
