Return-path: <linux-media-owner@vger.kernel.org>
Received: from out1.ip05ir2.opaltelecom.net ([62.24.128.241]:62385 "EHLO
	out1.ip05ir2.opaltelecom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752356Ab3GDNc2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Jul 2013 09:32:28 -0400
Received: from root by abf.yi.org with local (Exim 4.80)
	(envelope-from <root@abf.yi.org>)
	id 1UujUb-0007ND-J8
	for linux-media@vger.kernel.org; Thu, 04 Jul 2013 14:22:37 +0100
Date: Thu, 4 Jul 2013 14:22:37 +0100
From: root <richssat@abf.yi.org>
To: linux-media@vger.kernel.org
Subject: Re: Technisat SkyStar USB HD & DiSEqC motor
Message-ID: <20130704132237.GA28313@acer-3600>
References: <20130703190023.GA25127@acer-3600>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130703190023.GA25127@acer-3600>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

OK, after an e-mail to TechniSat tech support I've learnt the SkyStar USB HD
isn't not compatible with a DiSEqC motor, only a DiSEqC switch.

Strange to me is the motor receives enough power to drive itself, as when
receiving a non-functional 'gotox' or 'rotor' command I can use the manual
east/west buttons on the motor. The driver also pushes the correct commands
down the wire. So what's stopping it working?

I currently have a 35ukp doorstop. ;(

Thanks go out to Patrick Boettch author of dvb_usb_technisat_usb2 and
Manu Abraham author of stv090x for their input.

Hope this helps someone out in the future.

Richard.



 On Wed, Jul 03, 2013 at 08:00:23PM +0100, richards wrote:
> Hello.
> 
> I've been viewing FTA satellite for a few years using an up-to-date ubuntu distro
> and a Technisat SkyStar USB HD;
> http://www.linuxtv.org/wiki/index.php/Technisat_SkyStar_USB_HD
> 
> Recently I decided to upgrade my setup and try out a DiSEqC motor on my dish.
> 
> Cdtronix NH-210 DiSEqC 1.2 Motor
> http://cdtronix.com/motorised/new-horizons-nh-210-diseqc-1.2-motor
> 
> I am able to view/switch channels with the rotor inline between my SkyStar and
> LNB on the dish, which suggests to me the cabling is all good. However I cannot
> get the rotor to rotate.
> 
> I've used the 'gotox' util avaiable from dvb-apps and also 'rotor' from this
> source https://svn.tuxicoman.be/filedetails.php?repname=dvbgyver&path=%2Ftrunk%2Frotor.c
> as suggested by 'GMsoft' in the #linuxtv room on irc.freenode.net
> 
> Both utils seem to supply power to the rotor but they never rotate it.
> Whilst they supply power I can press manual buttons on the device to rotate East/West
> which tells me the rotor is receiving enough power.
> 
> I upped the verbosity of stv090x.ko which is itself loaded by dvb_usb_technisat_usb2.ko
> Patrick Boettch the author of dvb_usb_technisat_usb2 told me it used stv090x for
> DiSEqC commands & suggested I shout out on this mailing list.
> 
> Here are a few logs from my syslog (verbosity of stv090x upped to 5).
> 
> Inital loading of device. (Works as I can view satellite tv)
> http://bpaste.net/show/qFEde74lwn4cFquli0cx/
> 
> Command '# ./rotor -t 5 limits_off' - seems to return quickly.
> http://bpaste.net/show/EskG9QAFjTbevReVcYVm/
> 
> Command '# ./rotor -t 30 goto_x 28.2e' - DOESN'T ROTOTE ROTOR!! ;(
> http://bpaste.net/show/uJBtLqQA3VVnmCTebOPz/
> 
> Command '# ./rotor -t 5 stop' - seems to return quickly, its not moving anyway right?
> http://bpaste.net/show/eR1GmJnOWOQhFDlM4oMv/
> 
> 
> The 'gotox' from dvb-app doesn't ever move it either. I've used numerous different
> bits of cabling to eliminate that also.
> 
> Hoping somebody can suggest something either to fix or help debug futher.
> 
> Richard.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
