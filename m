Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:55801 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbZDCCO3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Apr 2009 22:14:29 -0400
Received: by yx-out-2324.google.com with SMTP id 31so797374yxl.1
        for <linux-media@vger.kernel.org>; Thu, 02 Apr 2009 19:14:26 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 2 Apr 2009 22:14:26 -0400
Message-ID: <dbfdd9d80904021914s3a0cc0a4ufb444d81915e612b@mail.gmail.com>
Subject: Compile of gspca
From: "Tom & Merry Cada" <thecadas@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all. I hope this is the right place to bring up this problem.

I have been attempting to set up a Microsoft VX 3000 webcam/microphone combo.

I was running Ubuntu 8.10 (intrepid ibex) with the 2.6.27-11 kernel. I
was unable to get the camera running until I found a reference to
downloading the gspca source
http://linuxtv.org/hg/~jfrancois/gspca/archive/tip.tar.bz2.

I did so and got package gspca-d8d701594f71.tar.bz2 which I unpacked,
and following the instructions compiled and installed successfully.
Upon reboot, the camera was found and the video worked very well.
However, the sound did not work although the USB mike was detected.

I knew that there were problems with pulseaudio and ALSA in Intrepid
and from work on my notebook, I knew that the upgrade to 9.04 (Jaunty
Jackalope) corrected the sound problems (new kernel
2.6.28-11-generic).

I did the upgrade with the result that the sound appeared. But the
camera disappeared. I know how to fix this. I'll just recompile and
install using the source that I had previously downloaded. I was
mistaken. I got the following:

tom@brutus:~/Desktop/gspca-d8d701594f71$ make
make -C /home/tom/Desktop/gspca-d8d701594f71/v4l
make[1]: Entering directory `/home/tom/Desktop/gspca-d8d701594f71/v4l'
perl scripts/make_config_compat.pl
/lib/modules/2.6.27-11-generic/build ./.myconfig ./config-compat.h
File not found:
/lib/modules/2.6.27-11-generic/build/include/linux/netdevice.h at
scripts/make_config_compat.pl line 15.
make[1]: *** [config-compat.h] Error 2
make[1]: Leaving directory `/home/tom/Desktop/gspca-d8d701594f71/v4l'
make: *** [all] Error 2

Further investigation showed that the symbolic link "build" in
/lib/modules/2.6.27-11-generic does not exist although the directory
/lib/modules/2.6.27-11... does.

Can I simply modify one of the files in the gspca source directory to
point to 2.6.28-11-generic and use the build link in that directory,
or is it more complicated than that? Is this a problem for the Ubuntu
folks?

Any advice or direction is most welcome.

Thanks... Tom.
