Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:25682 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbZDFRP2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Apr 2009 13:15:28 -0400
Received: by yw-out-2324.google.com with SMTP id 5so2210311ywb.1
        for <linux-media@vger.kernel.org>; Mon, 06 Apr 2009 10:15:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <dbfdd9d80904021914s3a0cc0a4ufb444d81915e612b@mail.gmail.com>
References: <dbfdd9d80904021914s3a0cc0a4ufb444d81915e612b@mail.gmail.com>
Date: Mon, 6 Apr 2009 13:15:26 -0400
Message-ID: <dbfdd9d80904061015g1f34dbael113fccfd667cb77b@mail.gmail.com>
Subject: Re: Compile of gspca
From: "Tom & Merry Cada" <thecadas@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 2, 2009 at 10:14 PM, Tom & Merry Cada <thecadas@gmail.com> wrote:
> Hi all. I hope this is the right place to bring up this problem.
>
> I have been attempting to set up a Microsoft VX 3000 webcam/microphone combo.
>
> I was running Ubuntu 8.10 (intrepid ibex) with the 2.6.27-11 kernel. I
> was unable to get the camera running until I found a reference to
> downloading the gspca source
> http://linuxtv.org/hg/~jfrancois/gspca/archive/tip.tar.bz2.
>
> I did so and got package gspca-d8d701594f71.tar.bz2 which I unpacked,
> and following the instructions compiled and installed successfully.
> Upon reboot, the camera was found and the video worked very well.
> However, the sound did not work although the USB mike was detected.
>
> I knew that there were problems with pulseaudio and ALSA in Intrepid
> and from work on my notebook, I knew that the upgrade to 9.04 (Jaunty
> Jackalope) corrected the sound problems (new kernel
> 2.6.28-11-generic).
>
> I did the upgrade with the result that the sound appeared. But the
> camera disappeared. I know how to fix this. I'll just recompile and
> install using the source that I had previously downloaded. I was
> mistaken. I got the following:
>
> tom@brutus:~/Desktop/gspca-d8d701594f71$ make
> make -C /home/tom/Desktop/gspca-d8d701594f71/v4l
> make[1]: Entering directory `/home/tom/Desktop/gspca-d8d701594f71/v4l'
> perl scripts/make_config_compat.pl
> /lib/modules/2.6.27-11-generic/build ./.myconfig ./config-compat.h
> File not found:
> /lib/modules/2.6.27-11-generic/build/include/linux/netdevice.h at
> scripts/make_config_compat.pl line 15.
> make[1]: *** [config-compat.h] Error 2
> make[1]: Leaving directory `/home/tom/Desktop/gspca-d8d701594f71/v4l'
> make: *** [all] Error 2
>
> Further investigation showed that the symbolic link "build" in
> /lib/modules/2.6.27-11-generic does not exist although the directory
> /lib/modules/2.6.27-11... does.
>
> Can I simply modify one of the files in the gspca source directory to
> point to 2.6.28-11-generic and use the build link in that directory,
> or is it more complicated than that? Is this a problem for the Ubuntu
> folks?
>
> Any advice or direction is most welcome.
>
> Thanks... Tom.
>

Well, I downloaded the most recent version (935ff3ceca43) from
http://linuxtv.org/hg/~jfrancois/gspca/archive/tip.tar.bz2 and was
able to compile and install. Thanks to whoever made the changes so
that it would compile with the 2.6.28-11 version of the kernel source.

Video in skype works great. However, now the sound does not work
(sigh...). The USB mic is shown in ALSA mixer as card 1 with the gain
up at max. The mic is shown in the pulseaudio mixer as an input
device, but no sound to either skype or the gnome sound recorder.

Is this a problem with gspca, or with the other components (ALSA,
pulseaudio, OSS, or whatever - too many choices!). An external mic
through the on-board sound card works properly.

Any suggestions or direction would be most welcome.

Thanks in advance... Tom.
