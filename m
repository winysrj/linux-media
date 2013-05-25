Return-path: <linux-media-owner@vger.kernel.org>
Received: from cm-84.215.157.11.getinternet.no ([84.215.157.11]:55288 "EHLO
	server.arpanet.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751716Ab3EYG5a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 May 2013 02:57:30 -0400
Date: Sat, 25 May 2013 09:00:20 +0200
From: Jon Arne =?utf-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>
To: =?utf-8?Q?=22Alejandro_A=2E_Vald=C3=A9s=22?= <av2406@gmail.com>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: Audio: no sound
Message-ID: <20130525070020.GA2122@dell.arpanet.local>
References: <519D6CFA.2000506@gmail.com>
 <CALF0-+UqJaNc7v86qakVTNEJx5npMFPqFp-=9rAByFV_+FEaww@mail.gmail.com>
 <519E41AC.3040707@gmail.com>
 <CALF0-+U5dFktwHwO5-h_7RJ1xyjc3JbHUWqG3g=WSPA=HcHnnw@mail.gmail.com>
 <519E6046.8050509@gmail.com>
 <CALF0-+UZnt9rfmQFSecqaf_9L29mwKeNV22w1XmMQQG0AE=jJw@mail.gmail.com>
 <519E76F3.4070006@gmail.com>
 <519EB8E6.5000503@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <519EB8E6.5000503@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 23, 2013 at 09:48:38PM -0300, "Alejandro A. Valdés" wrote:
Hi,

> On 05/23/2013 05:07 PM, "Alejandro A. Valdés" wrote:
> >On 05/23/2013 04:12 PM, Ezequiel Garcia wrote:
> >>Alejandro,
> >>
> >>You dropped the linux-media list from Cc. I'm adding it back.
> >>
> >>On Thu, May 23, 2013 at 3:30 PM, "Alejandro A. Valdés"
> >><av2406@gmail.com> wrote:
> >>># lsmod
> >>>Module                  Size  Used by
> >>>snd_usb_audio         106622  0
> >>>snd_usbmidi_lib        24590  1 snd_usb_audio
> >>>easycap              1213861  1
> >>Okey. This is all I need. You're using the "easycap" driver which is
> >>an old, deprecated and staging (i.e. experimental) driver for easycap
> >>devices.
> >>
> >>The new driver, which is fully supported, is called "stk1160". It's
> >>been completely written from scratch, so it's not related to the old
> >>one.
> >>
> >>Upgrade your kernel and/or your distribution to get a kernel >= v3.6
> >>which includes the new driver, try again and let me know what happens.
> >>
> >>-- 
> >>     Ezequiel
> > Thanks for the tip. Will do so as son as I get another box to
> >play with for a while. Not in shape to risk this environment. Will
> >let you know the results. Regards,
> >Alejandro
> Good evening,
> 
> I upgraded the kernel as recommend, but it still doesn't seem to be
> working. Still no sound. I attached some files with the output of
> the same set of commands, we have been working with this afternoon.
> 
> I'll be grateful if you can provide further guidelines on this.
> 
> Thanks a lot,
> Alejandro,

>  0 [Intel          ]: HDA-Intel - HDA Intel
>                       HDA Intel at 0xf7cf8000 irq 45

> [  183.776116] usb 1-1: new high-speed USB device number 5 using ehci_hcd
> [  183.908837] usb 1-1: New USB device found, idVendor=05e1, idProduct=0408
> [  183.908852] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [  183.908862] usb 1-1: Product: USB 2.0 Video Capture Controller
> [  183.908871] usb 1-1: Manufacturer: Syntek Semiconductor
> [  187.113354] easycap::0adjust_standard: selected standard: PAL_BGHIN
> [  187.424338] easycap::0adjust_format: sought:    640x480,UYVY(0x59565955),1=field,0x00=std mask
> [  187.424352] easycap::0adjust_format: sought:    V4L2_FIELD_NONE
> [  187.424367] easycap::0adjust_format: actioning: 640x480 PAL_BGHIN_AT_640x480_FMT_UYVY-n
> [  187.448211] easycap::0adjust_brightness: adjusting brightness to  0x7F
> [  187.472216] easycap::0adjust_contrast: adjusting contrast to  0x3F
> [  187.496207] easycap::0adjust_saturation: adjusting saturation to  0x2F
> [  187.520220] easycap::0adjust_hue: adjusting hue to  0x00
> [  187.521800] easycap::0easycap_register_video: registered with videodev: 1=minor
> [  187.521812] easycap::0easycap_usb_probe: ends successfully for interface 0
> [  187.522249] easycap::0easycap_usb_probe: ends successfully for interface 1
> [  187.522604] easycap::0easycap_usb_probe: audio hardware is AC'97
> [  187.522662] easycap: probe of 1-1:1.2 failed with error -146692016
> [  187.525726] easycap:: easycap_open: ==========OPEN=========
> [  190.581347] easycap::0adjust_standard: selected standard: PAL_BGHIN
> [  190.892343] easycap::0adjust_format: sought:    640x480,UYVY(0x59565955),1=field,0x00=std mask
> [  190.892356] easycap::0adjust_format: sought:    V4L2_FIELD_NONE
> [  190.892371] easycap::0adjust_format: actioning: 640x480 PAL_BGHIN_AT_640x480_FMT_UYVY-n
> [  190.916222] easycap::0adjust_brightness: adjusting brightness to  0x7F
> [  190.940224] easycap::0adjust_contrast: adjusting contrast to  0x3F
> [  190.964224] easycap::0adjust_saturation: adjusting saturation to  0x2F
> [  190.988221] easycap::0adjust_hue: adjusting hue to  0x00

It seems you are still using the easycap driver.

[...]

> Module                  Size  Used by
> snd_hda_intel          33051  5 
> snd_hda_codec         116694  2 snd_hda_codec_realtek,snd_hda_intel
> bluetooth             191657  10 rfcomm,bnep
> uvcvideo               72248  0 
> easycap              1213860  1 

This should say stk1160 if you were using the new driver.
I'm not sure what about what kernel first included the stk1160, but it
doesn't seem to be included in the kernel you built.

Best regards
Jon Arne Jørgensen

