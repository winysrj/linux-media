Return-path: <linux-media-owner@vger.kernel.org>
Received: from gelbbaer.kn-bremen.de ([78.46.108.116]:50544 "EHLO
	smtp.kn-bremen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab1GMX07 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2011 19:26:59 -0400
From: Juergen Lock <nox@jelal.kn-bremen.de>
Date: Thu, 14 Jul 2011 01:26:14 +0200
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Juergen Lock <nox@jelal.kn-bremen.de>, linux-media@vger.kernel.org,
	hselasky@c2i.net
Subject: Re: [PATCH] pctv452e.c: switch rc handling to rc.core
Message-ID: <20110713232614.GA57768@triton8.kn-bremen.de>
References: <20110625193427.GA66720@triton8.kn-bremen.de>
 <4E1E1CA7.5090004@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E1E1CA7.5090004@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 13, 2011 at 07:31:03PM -0300, Mauro Carvalho Chehab wrote:
> Em 25-06-2011 16:34, Juergen Lock escreveu:
> > This is on top of the submitted pctv452e.c driver and was done similar
> > to how ttusb2 works.  Tested with lirc (devinput) and ir-keytable(1).
> 
> You should submit pctv452e driver first, otherwise I can't apply
> this one ;)

Heh well Hans <hselasky@c2i.net> last did that a little while ago
iirc, tho of course he didn't write it. :)  (Do I guess right it
never got committed earlier because of stb0899 tuning problems for
which the fix(es?) are still waiting to be committed?  At least
I think I still need patches here if I don't want w_scan to miss
random transponders...  I.e. it only finds like 70% of what's on
Astra 19.2E and missed different ones each time I ran it without
stb0899 patches.)

 Cheers,
	Juergen
