Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9P8ZOcD009454
	for <video4linux-list@redhat.com>; Sat, 25 Oct 2008 04:35:24 -0400
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9P8ZBE7021670
	for <video4linux-list@redhat.com>; Sat, 25 Oct 2008 04:35:11 -0400
Message-ID: <4902DB0F.4000401@hhs.nl>
Date: Sat, 25 Oct 2008 10:38:39 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Thomas Kaiser <linux-dvb@kaiser-linux.li>
References: <4900DA6B.4050902@kaiser-linux.li>	<1224831699.1761.13.camel@localhost>
	<49021251.8020402@kaiser-linux.li>
In-Reply-To: <49021251.8020402@kaiser-linux.li>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Video 4 Linux <video4linux-list@redhat.com>
Subject: Re: gspca, what do I am wrong?
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Thomas Kaiser wrote:
> Hello Jean-Francois
> 
> I got some time and I would like to test the new gspca V2 v4l2 driver 
> but with this issues I will get up soon :-(
> 
> I have about 20 webcams laying around which I would like to test with 
> the new gspca V2 "in kernel" drive with a "stock distribution (Ubuntu)" 
> kernel.
> 

Please don't give up we would really like to have you onboard, you did a greta 
job with the gspcav1 pixart drivers and I'm sure you will make a valuable 
contributor!

The problem is that gspca now is part of the v4l-dvb tree, so when you build it 
now you rebuild the entire v4l subsystem really, this means that you must make 
sure that all v4l modules, including videodev.ko are unloaded before trying to 
modprobe for example gspca_pac207, so that the new version of videodev.ko gets 
loaded.

This has been working fine for me both with older and newer kernels (on 
Fedora), so if you are really sure no old modules are loaded, it might be there 
is something funny / weird going on with the way your distribution provides 
kernel sources for building out of tree modules (as Thierry hints at).

To give you an idea, here is how I test gspca:

--- begin test.sh ---
#!/bin/bash

set -e

make
sudo make install

sudo rmmod gspca_sonixb || :
sudo rmmod gspca_spca501 || :
sudo rmmod gspca_spca561 || :
sudo rmmod gspca_pac207 || :
sudo rmmod gspca_pac7311 || :
sudo rmmod gspca_ov519 || :
sudo rmmod gspca_zc3xx || :
sudo rmmod gspca_main || :
sudo rmmod tuner || :
sudo rmmod msp3400 || :
sudo rmmod bttv || :
sudo rmmod compat_ioctl32 || :
sudo rmmod videodev || :
sudo rmmod v4l1_compat || :
sudo rmmod ir_common || :

sudo modprobe gspca_main debug=15
sudo modprobe gspca_sonixb
sudo modprobe gspca_spca501
sudo modprobe gspca_spca561
sudo modprobe gspca_pac207
sudo modprobe gspca_pac7311
sudo modprobe gspca_ov519
sudo modprobe gspca_zc3xx
sudo modprobe bttv
--- end test.sh ---

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
