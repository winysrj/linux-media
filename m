Return-path: <linux-media-owner@vger.kernel.org>
Received: from cloudserver096301.home.net.pl ([79.96.179.35]:60829 "HELO
	cloudserver096301.home.net.pl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751059AbcHFWV3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Aug 2016 18:21:29 -0400
Date: Sat, 6 Aug 2016 17:14:46 +0200
From: Piotr =?iso-8859-1?Q?Kr=F3l?= <piotr.krol@3mdeb.com>
To: Bastiaan van den Berg <buzztiaan@gmail.com>
Cc: linux-media@vger.kernel.org,
	"linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
	Thomas Johnson <tjohnson@motionfigures.com>,
	George Saliba <grgsaliba@gmail.com>
Subject: Re: [linux-sunxi] uvcvideo: Failed to submit URB 0 (-28) with Cam
 Sync HD VF0770 (041e:4095)
Message-ID: <20160806151446.gyrtri4pphpasaoj@haysend>
References: <20160806140022.rgy6f63xtx6667lg@haysend>
 <CACLj26K4UC9rAdgm-AF_6qcuSxrLoTRBNaqvsu-gbGP2MNJwRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACLj26K4UC9rAdgm-AF_6qcuSxrLoTRBNaqvsu-gbGP2MNJwRQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Aug 06, 2016 at 04:05:04PM +0200, Bastiaan van den Berg wrote:

Hi Bastiaan,

> First google hit on actual error suggests the 'out of space' is a way to denote
> bandwidth limitation
> it also has a workaround
> 
> http://answers.ros.org/question/12582/usb_cam-vidioc_streamon-error-28/

Apparently my goole results are not tweaked well for UVC issues. Thanks
for this link.

Unfortunately this doesn't help. Full test log can be found here [1].

I assume this log mean quirk was applied correctly:
# modprobe uvcvideo quirks=128
[   63.137035] uvcvideo: Found UVC 1.00 device Live! Cam Sync HD VF0770 (041e:4095)
[   63.144561] uvcvideo: Forcing device quirks to 0x80 by module parameter for testing purpose.
[   63.152987] uvcvideo: Please report required quirks to the linux-uvc-devel mailing list.
[   63.172943] input: Live! Cam Sync HD VF0770 as /devices/platform/soc@01c00000/1c13000.usb/musb-hdrc.1.auto/usb5/5-1/5-1.2/5-1.2:1.0/input/input1
[   63.186367] usbcore: registered new interface driver uvcvideo
[   63.192113] USB Video Class driver (1.1.1)

# v4l2grab -d /dev/video0 -o image.jpg
[   78.631747] uvcvideo: Failed to submit URB 0 (-28).
libv4l2: error turning on stream: No space left on device
VIDIOC_STREAMON error 28, No space left on device

Maybe I should cc linux-uvc-devel as mention in log ?

[1] http://paste.ubuntu.com/22455180/

-- 
Best Regards,
Piotr Król
Embedded Systems Consultant
http://3mdeb.com | @3mdeb_com
