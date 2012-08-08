Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42717 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106Ab2HHW2G (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2012 18:28:06 -0400
Received: by pbbrr13 with SMTP id rr13so2133051pbb.19
        for <linux-media@vger.kernel.org>; Wed, 08 Aug 2012 15:28:06 -0700 (PDT)
Date: Wed, 8 Aug 2012 15:28:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL for 3.6-rc1] media updates part 2
In-Reply-To: <5017F674.80404@redhat.com>
Message-ID: <alpine.DEB.2.00.1208081526320.11542@chino.kir.corp.google.com>
References: <5017F674.80404@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 31 Jul 2012, Mauro Carvalho Chehab wrote:

>       [media] radio-shark: New driver for the Griffin radioSHARK USB radio receiver

This one gives me a build warning if CONFIG_LEDS_CLASS is disabled:

ERROR: "led_classdev_register" [drivers/media/radio/shark2.ko] undefined!
ERROR: "led_classdev_unregister" [drivers/media/radio/shark2.ko] undefined!
