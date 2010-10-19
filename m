Return-path: <mchehab@pedra>
Received: from web25407.mail.ukl.yahoo.com ([217.12.10.141]:27903 "HELO
	web25407.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751791Ab0JSUDd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 16:03:33 -0400
Message-ID: <968618.5175.qm@web25407.mail.ukl.yahoo.com>
References: <259225.84971.qm@web25402.mail.ukl.yahoo.com> <201010192032.50484.albin.kauffmann@gmail.com>
Date: Tue, 19 Oct 2010 20:56:51 +0100 (BST)
From: fabio tirapelle <ftirapelle@yahoo.it>
Subject: Re: Hauppauge WinTV-HVR-1120 on Unbuntu 10.04
To: Albin Kauffmann <albin.kauffmann@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <201010192032.50484.albin.kauffmann@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi 

Yes, the same behaviour: random (after 3-4 boots) the card works correctly.

The WinTV did work correctly with ubuntu 9.10. In Ubuntu 9.10 the 
package linux-firmware-nonfree didn't include the dvb-fe-tda10048-1.0.fw. I 
remember that Ubuntu 9.10 used for my card the dvb-fe-tda10046.fw. 

Now, Ubuntu 10.04 loads for my card the dvb-fe-tda10048-1.0.fw
Its seems that with the 9.10 version, the card is recognized as WinTV-HVR-1100 
or 1110 and now as WinTV-HVR-1120. 


I wait until you recompile the kernel  with the v4l. Please tell me if this 
solves
the problem

Thanks



----- Messaggio originale -----
> Da: Albin Kauffmann <albin.kauffmann@gmail.com>
> A: fabio tirapelle <ftirapelle@yahoo.it>
> Cc: linux-media@vger.kernel.org
> Inviato: Mar 19 ottobre 2010, 20:32:50
> Oggetto: Re: Hauppauge WinTV-HVR-1120 on Unbuntu 10.04
> 
> On Monday 11 October 2010 11:57:14 fabio tirapelle wrote:
> > Hi
> > 
> > After upgrading from Ubuntu 9.10 to Ubuntu 10.04 my Hauppauge
> >  WinTV-HVR-1120 (sometimes) doesn't work correctly.
> > I get random the  following errors:
> > 
> > [   53.216153] DVB: registering new  adapter (saa7133[0])
> > [   53.216156] DVB: registering adapter 2  frontend 0 (NXP TDA10048HN
> > DVB-T)... [   53.840013]  tda10048_firmware_upload: waiting for firmware
> > upload  (dvb-fe-tda10048-1.0.fw)...
> > [   53.840019] saa7134 0000:01:06.0:  firmware: requesting
> > dvb-fe-tda10048-1.0.fw [   53.880505]  tda10048_firmware_upload: firmware
> > read 24878 bytes. [   53.880509]  tda10048_firmware_upload: firmware
> > uploading
> > [   58.280136]  tda10048_firmware_upload: firmware uploaded
> > [   59.024537]  tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer
> > returned:  -5
> > [   59.024541] tda18271c2_rf_tracking_filters_correction: error  -5 on line
> > 264 [   59.420153] tda18271_write_regs: ERROR: idx =  0x5, len = 1,
> > i2c_transfer returned: -5
> > [   59.420157]  tda18271_toggle_output: error -5 on line 47
> > [   91.004019]  Clocksource tsc unstable (delta = -295012684 ns)
> > [  256.293639]  eth0: link up.
> > [  256.294750] ADDRCONF(NETDEV_CHANGE): eth0: link  becomes ready
> > [  263.523498] eth0: link down.
> > [   265.258740] eth0: link up.
> > [  266.460026] eth0: no IPv6 routers  present
> > [ 9869.636167] tda18271_write_regs: ERROR: idx = 0x5, len = 1,  i2c_transfer
> > returned: -5
> > [ 9869.636178] tda18271_init: error -5  on line 826
> > [ 9872.636220] tda18271_write_regs: ERROR: idx = 0x5, len =  1, i2c_transfer
> > returned: -5
> > [ 9872.636232]  tda18271_toggle_output: error -5 on line 47
> > [ 9998.240167]  tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer
> > returned:  -5
> > [ 9998.240178] tda18271_init: error -5 on line 826
> >  [10001.240179] tda18271_write_regs: ERROR: idx = 0x5, len = 1,  
i2c_transfer
> > returned: -5
> > [10001.240190] tda18271_toggle_output:  error -5 on line 47
> 
> Hi,
> 
> I have the same HVR-1120 TV card and I get  the same kind of errors happening 
> on my ArchLinux installation (kernel  2.6.35). However, these errors are not 
> occuring after all boots. Indeed, I  can watch TV (DVB-T) with no problem after 
>
> 3/4 of my reboots. Is your  problem happening at all time ?
> 
> I've started to recompile my own kernel  with the v4l module from the hg 
> repository. I'll tell you if it improves the  behavior.
> 
> I don't use Ubuntu on my desktop computer but, as far as you  are concerned, 
> you could first try to update your installation to the last  Ubuntu 10.10 or to 
>
> compile the last Linux kernel. And tell us if it improves  something ;)
> 
> Cheers,
> 
> -- 
> Albin Kauffmann
> Open Wide -  Architecte Open Source
> --
> To unsubscribe from this list: send the line  "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More  majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


      
