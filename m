Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987Ab0DGUX5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Apr 2010 16:23:57 -0400
Message-ID: <4BBCE9D7.5060309@redhat.com>
Date: Wed, 07 Apr 2010 17:23:51 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] em28xx: fix locks during dvb init sequence - was: Re:
 	V4L-DVB drivers and BKL
References: <201004011001.10500.hverkuil@xs4all.nl>	 <201004011411.02344.laurent.pinchart@ideasonboard.com>	 <4BB4A9E2.9090706@redhat.com> <201004011642.19889.hverkuil@xs4all.nl>	 <4BB4B569.3080608@redhat.com>	 <x2y829197381004010958u82deb516if189d4fb00fbc5e6@mail.gmail.com>	 <4BBCE61E.3090504@redhat.com> <g2x829197381004071315o9000e858gd64d982a73d65809@mail.gmail.com>
In-Reply-To: <g2x829197381004071315o9000e858gd64d982a73d65809@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> On Wed, Apr 7, 2010 at 4:07 PM, Mauro Carvalho Chehab

> At first glance, this looks really promising.  I will have to look at
> this in more detail when I have access to the source code (I'm at the
> office right now).

Ok. Please test it when you have some time, for me to apply it upstream. 
On my tests, it worked like a charm, and the Kernel circular lock detector 
also didn't complain (it is always a good idea to have it turn on when 
touching on locks).

-- 

Cheers,
Mauro
