Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40187 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759452Ab2HIUD7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2012 16:03:59 -0400
Received: by pbbrr13 with SMTP id rr13so1409317pbb.19
        for <linux-media@vger.kernel.org>; Thu, 09 Aug 2012 13:03:58 -0700 (PDT)
Date: Thu, 9 Aug 2012 13:03:56 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: Hans de Goede <hdegoede@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL for 3.6-rc1] media updates part 2
In-Reply-To: <5023AF3A.9050206@redhat.com>
Message-ID: <alpine.DEB.2.00.1208091302220.12942@chino.kir.corp.google.com>
References: <5017F674.80404@redhat.com> <alpine.DEB.2.00.1208081526320.11542@chino.kir.corp.google.com> <5023A11C.50502@redhat.com> <5023A645.40308@redhat.com> <5023AF3A.9050206@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 9 Aug 2012, Mauro Carvalho Chehab wrote:

> Yeah, that would work as well, although the code would look uglier.
> IMHO, using select/depend is better.
> 

Agreed, I think it should be "depends on LEDS_CLASS" rather than select 
it if there is a hard dependency that cannot be fixed with extracting the 
led support in the driver to #ifdef CONFIG_LEDS_CLASS code.
