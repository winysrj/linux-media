Return-path: <linux-media-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:45718 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752046Ab0BHWef (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2010 17:34:35 -0500
Date: Sun, 7 Feb 2010 20:13:22 -0800
From: Greg KH <greg@kroah.com>
To: Pekka Sarnila <sarnila@adit.fi>
Cc: Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jirislaby@gmail.com>,
	Antti Palosaari <crope@iki.fi>, mchehab@infradead.org,
	linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 1/1] media: dvb-usb/af9015, fix disconnection crashes
Message-ID: <20100208041322.GA2988@kroah.com>
References: <1264007972-6261-1-git-send-email-jslaby@suse.cz> <4B5CDB53.6030009@iki.fi> <4B5D6098.7010700@gmail.com> <4B5DDDFB.5020907@iki.fi> <alpine.LRH.2.00.1001261406010.15694@twin.jikos.cz> <4B6AA211.1060707@gmail.com> <4B6ACA4B.2030906@adit.fi> <alpine.LNX.2.00.1002041425050.15395@pobox.suse.cz> <4B6AD4A8.9080101@adit.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B6AD4A8.9080101@adit.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 04, 2010 at 04:07:36PM +0200, Pekka Sarnila wrote:
> Yes, my comment maybe criticizes more the basic architectural structure of 
> usb putting it's own work up to higher layer. The only practical thing is 
> that, if there is a non-HID device suffering from that FULLSPEED problem, 
> the quirk won't help it. Anyway in current kernel structure usb layer 
> doesn't handle endpoint setup at all, thus it simply can not do the job.

Patches to the USB core to resolve this issue are always gladly
appreciated :)

thanks,

greg k-h
