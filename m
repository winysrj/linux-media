Return-path: <linux-media-owner@vger.kernel.org>
Received: from icp-osb-irony-out3.external.iinet.net.au ([203.59.1.219]:65241
	"EHLO icp-osb-irony-out3.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751057AbaJTBoa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Oct 2014 21:44:30 -0400
From: Rodney Baker <rodney@jeremiah31-10.net>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (1.0)
Subject: Re: Kernel 3.17.0 broke xc4000-based DTV1800h
Message-Id: <BD61E1D7-8FFA-4559-80EC-068047EBB0C0@jeremiah31-10.net>
Date: Mon, 20 Oct 2014 11:40:56 +1030
References: <1637119.5DTscVEVRC@mako>
In-Reply-To: <1637119.5DTscVEVRC@mako>
To: Linux-Media <linux-media@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ping? Does anybody have any idea where to star digging on this? 

Sent from my iPad

> On 16 Oct 2014, at 17:33, Rodney Baker <rodney.baker@iinet.net.au> wrote:
> 
> Since installing kernel 3.17.0-1.gc467423-desktop (on openSuSE 13.1) my 
> xc4000/zl10353/cx88 based DTV card has failed to initialise on boot.
> 
> The following messages are from dmesg; 
> 
> [   78.468221] xc4000: I2C read failed
> [   80.074604] xc4000: I2C read failed
> [   80.074605] Unable to read tuner registers.
> [   82.622062] Selecting best matching firmware (7 bits differ) for type=(0), 
> id 000000200000b700:
> [   82.626375] i2c i2c-0: sendbytes: NAK bailout.
> [  148.063594] xc4000: I2C read failed
> [  149.669994] xc4000: I2C read failed
> [  149.669995] Unable to read tuner registers.
> [  149.670198] cx88[0]/0: registered device video1 [v4l2]
> [  149.670287] cx88[0]/0: registered device vbi0
> [  149.670338] cx88[0]/0: registered device radio0
> [  149.670340] cx88[0]/0: failed to create cx88 audio thread, err=-4
> [  149.670382] cx88[0]/2: cx2388x based DVB/ATSC card
> [  149.670384] cx8802_alloc_frontends() allocating 1 frontend(s)
> [  149.670515] cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
> [  151.305364] zl10353_read_register: readreg error (reg=127, ret==-6)
> [  151.305367] cx88[0]/2: frontend initialization failed
> [  151.305369] cx88[0]/2: dvb_register failed (err = -22)
> [  151.305370] cx88[0]/2: cx8802 probe failed, err = -22
> 
> It worked with 3.16.3-1.gd2bbe7f-desktop on the same machine.
> 
> Regards,
> Rodney.
> 
> -- 
> ==============================================================
> Rodney Baker VK5ZTV
> rodney.baker@iinet.net.au
> ==============================================================
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
