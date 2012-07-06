Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm9-vm0.bullet.mail.ird.yahoo.com ([77.238.189.197]:38085 "HELO
	nm9-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932381Ab2GFLB2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Jul 2012 07:01:28 -0400
Message-ID: <1341572487.22318.YahooMailClassic@web29402.mail.ird.yahoo.com>
Date: Fri, 6 Jul 2012 12:01:27 +0100 (BST)
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Subject: Re: media_build and Terratec Cinergy T Black.
To: Antti Palosaari <crope@iki.fi>, mchehab@redhat.com
Cc: linux-media@vger.kernel.org
In-Reply-To: <1341572070.43713.YahooMailClassic@web29402.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

One more comment: blowing away /lib/modules/`uname -r`/kernel/drivers/ seems drastic?

The compat-wireless people uses some clever tricks to get modprobe to preferentially load /lib/modules/`uname -r`/updates first. This way you can just remove that, run 'depmod -a' and go back to stock distro kernel behavior.

Also it might be useful/quicker not to build the whole 500+ kernel modules...

--- On Fri, 6/7/12, Hin-Tak Leung <htl10@users.sourceforge.net> wrote:

> From: Hin-Tak Leung <htl10@users.sourceforge.net>
> Subject: media_build and Terratec Cinergy T Black.
> To: "Antti Palosaari" <crope@iki.fi>, mchehab@redhat.com
> Cc: linux-media@vger.kernel.org
> Date: Friday, 6 July, 2012, 11:54
> Firstly, the downloaded
> linux-media.tar.bz2 has some simple typos, missing 3
> brackets:
> 
> (please feel free to add my signed-off though this is
> trivial).
> 
> -------------
> ---
> linux/drivers/media/video/v4l2-compat-ioctl32.c~   
> 2012-07-06 04:45:17.000000000 +0100
> +++
> linux/drivers/media/video/v4l2-compat-ioctl32.c   
> 2012-07-06 07:35:54.166512279 +0100
> @@ -387,7 +387,7 @@
>         
> get_user(kp->index, &up->index) ||
>          get_user(kp->type,
> &up->type) ||
>         
> get_user(kp->flags, &up->flags) ||
> -       
> get_user(kp->memory, &up->memory)
> +       
> get_user(kp->memory, &up->memory))
>             
> return -EFAULT;
>  
>      if (V4L2_TYPE_IS_OUTPUT(kp->type))
> @@ -471,7 +471,7 @@
>         
> put_user(kp->index, &up->index) ||
>          put_user(kp->type,
> &up->type) ||
>         
> put_user(kp->flags, &up->flags) ||
> -       
> put_user(kp->memory, &up->memory)
> +       
> put_user(kp->memory, &up->memory))
>             
> return -EFAULT;
>  
>      if (put_user(kp->bytesused,
> &up->bytesused) ||
> @@ -481,7 +481,7 @@
>         
> copy_to_user(&up->timecode, &kp->timecode,
> sizeof(struct v4l2_timecode)) ||
>         
> put_user(kp->sequence, &up->sequence) ||
>         
> put_user(kp->reserved2, &up->reserved2) ||
> -       
> put_user(kp->reserved, &up->reserved)
> +       
> put_user(kp->reserved, &up->reserved))
>             
> return -EFAULT;
>  
>      if
> (V4L2_TYPE_IS_MULTIPLANAR(kp->type)) {
> ------------
> 
> A few comments & issues:
> 
> - don't realy like the build script trying to clone
> media_tree, etc had hard-coded remotes - if(0) out'ed the
> whole git-on-the-fly block inside to make it use an existing
> symlink'ed checkout - consider offering something similar?
> 
> - $ lsdvb seems to be doing garbage:(fedora 17's)
> 
> usb (-1975381336:62 64848224:32767) on PCI
> Domain:-1965359032 Bus:62 Device:64848416 Function:32767
>     DEVICE:0 ADAPTER:0 FRONTEND:0 (Realtek
> RTL2832 (DVB-T)) 
>          FE_OFDM
> Fmin=174MHz Fmax=862MHz
> 
> lsdvb on mercury is only marginally better with the PCI
> zero's, but the other numbers swapped:
> 
> usb (62:-1975379912 32767:-348245472) on PCI Domain:0 Bus:0
> Device:0 Function:0
>     DEVICE:0 ADAPTER:0 FRONTEND:0 (Realtek
> RTL2832 (DVB-T)) 
>          FE_OFDM
> Fmin=174MHz Fmax=862MHz
> 
> - 'scandvb' segfault at the end on its own.
> 
> 
> - "scandvb /usr/share/dvb/dvb-t/uk-SandyHeath" (supposedly
> where I am) got a few "WARNING: >>> tuning
> failed!!!" and no list.
> 
> - 'w_scan -G -c GB'
>   have a few curious
> WARNING: received garbage data: crc = 0xcc93876c; expected
> crc = 0xb81bb6c4
> 
> return a list of 26, with entries like (which seems to be
> vaguely correct):
> 
> BBC
> ONE;(null):522000:B8C23D0G32M64T8Y0:T:27500:101=2:102,106=eng:0:0:4173:9018:4173:0:100
> 
> So I just put it in ~/.mplayer:channels.conf
> 
> Took me a while to figure out that mplayer wants:
> 
> mplayer 'dvb://BBC ONE;(null)'
> 
> rather than anything else - curious about the ';(null)'
> part.
> 
> --------
> Playing dvb://BBC ONE;(null).
> dvb_tune Freq: 522000
> ERROR IN SETTING DMX_FILTER 9018 for fd 4: ERRNO: 22ERROR,
> COULDN'T SET CHANNEL  8: Failed to open dvb://BBC
> ONE;(null).
> ----------
> 
> At this point I am lost :-).
> 
> 
> 
> 
> 
> 
> 
