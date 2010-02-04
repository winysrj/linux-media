Return-path: <linux-media-owner@vger.kernel.org>
Received: from psa.adit.fi ([217.112.250.17]:48922 "EHLO psa.adit.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932328Ab0BDOFu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Feb 2010 09:05:50 -0500
Message-ID: <4B6AD4A8.9080101@adit.fi>
Date: Thu, 04 Feb 2010 16:07:36 +0200
From: Pekka Sarnila <sarnila@adit.fi>
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Jiri Slaby <jirislaby@gmail.com>, Antti Palosaari <crope@iki.fi>,
	mchehab@infradead.org, linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 1/1] media: dvb-usb/af9015, fix disconnection crashes
References: <1264007972-6261-1-git-send-email-jslaby@suse.cz> <4B5CDB53.6030009@iki.fi> <4B5D6098.7010700@gmail.com> <4B5DDDFB.5020907@iki.fi> <alpine.LRH.2.00.1001261406010.15694@twin.jikos.cz> <4B6AA211.1060707@gmail.com> <4B6ACA4B.2030906@adit.fi> <alpine.LNX.2.00.1002041425050.15395@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1002041425050.15395@pobox.suse.cz>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Yes, my comment maybe criticizes more the basic architectural structure 
of usb putting it's own work up to higher layer. The only practical 
thing is that, if there is a non-HID device suffering from that 
FULLSPEED problem, the quirk won't help it. Anyway in current kernel 
structure usb layer doesn't handle endpoint setup at all, thus it simply 
can not do the job.

Pekka

Jiri Kosina wrote:
> 
> Yes, I still think what I have stated before, that this should be properly 
> handled in the USB stack.
> 
> On the other hand, in usbhid driver we do a lot of USB-specific 
> lower-level things anyway, so it's technically more-or-less OK to apply 
> the quirk there as well (and that's why I have accepted it back then).
> 
