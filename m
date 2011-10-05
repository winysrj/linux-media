Return-path: <linux-media-owner@vger.kernel.org>
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:33971 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933916Ab1JEFQW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Oct 2011 01:16:22 -0400
Date: Tue, 4 Oct 2011 21:59:17 -0700
From: Greg KH <greg@kroah.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-serial@vger.kernel.org, linux-media@vger.kernel.org,
	linux-usb@vger.kernel.org,
	=?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
	James Courtier-Dutton <james.dutton@gmail.com>,
	HoP <jpetrous@gmail.com>,
	=?iso-8859-1?Q?Istv=E1n_V=E1radi?= <ivaradi@gmail.com>
Subject: Re: serial device name for smart card reader that is integrated to
 Anysee DVB USB device
Message-ID: <20111005045917.GB4700@kroah.com>
References: <4E8B7901.2050700@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8B7901.2050700@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 05, 2011 at 12:22:09AM +0300, Antti Palosaari wrote:
> I have been looking for correct device name for serial smart card
> reader that is integrated to Anysee DVB USB devices. Consider it
> like old so called Phoenix reader. Phoenix is de facto protocol used
> for such readers and there is whole bunch of different RS232
> (/dev/ttyS#) or USB-serial (/dev/ttyUSB#) readers using that
> protocol.
> 
> Anyhow, that one is integrated to DVB USB device that is driven by
> dvb_usb_anysee driver. As I understand, I need reserve new device
> name and major number for my device. See Documentation/devices.txt

Why not just use the usb-serial core and then you get a ttyUSB* device
node "for free"?  It also should provide a lot of the basic tty
infrastructure and ring buffer logic all ready to use.

thanks,

greg k-h



> 
> Current proof-of-concept driver can be found from:
> http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/anysee-sc
> Don't review code since it is not ready for release yet, it even
> lacks locking.
> 
> There have been some proposes about names, mainly whether to
> register it under the DVB adapter it is physically
> (/dev/dvb/adapterN/sc#) or to the root of /dev (/dev/sc#). I used sc
> as name, SC=SmartCard.
> 
> Could someone who have enough knowledge point out which one is
> correct or better?
> 
> 
> regards
> Antti
> 
> -- 
> http://palosaari.fi/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-serial" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
