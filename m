Return-path: <mchehab@pedra>
Received: from c2bthomr09.btconnect.com ([213.123.20.127]:40215 "EHLO
	mail.btconnect.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751573Ab0JDAWq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Oct 2010 20:22:46 -0400
From: sibu xolo <sibxol@btconnect.com>
To: linux-media@vger.kernel.org
Subject: udev-161 dvbT kernel-2.6.35.5
Date: Mon, 4 Oct 2010 01:16:35 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201010040116.35961.sibxol@btconnect.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Greetings,  

I am attempting to set up DVBT on a computer with these:

--------cpu:  amd64 2 cores, gpu nvidia gforce  nouveau drm
--------o/s cblfslinux 64-bit kernel-2.6.35.5 udev-161  kde-4.4.5 
--------dvb device  Hauppauge wintvNovaT DVBT usb2

I have  the foollowing in /lib/firmware


dvb-usb-dib0700-01.fw       
dvb-usb-dib0700-1.20.fw 


#############  my udev rule looks like so:-

KERNEL="dvb*",
PROGRAM="/etc/udev/scripts/dvb.sh %k",  
ATTRS{serial}=="123456789a",
ATTRS{product}=="Nova-T Stick",
GROUP="video", 
MODE="0660",
SYMLINK+="Nova-T-usb2"

###### the machine dwells a litle   on booting
###### lsmod yoelds:-

root [ ~teeveey ]# lsmod
Module                  Size  Used by
snd_hda_codec_realtek   294785  1 
dvb_usb_dib0700        77625  0 
dib7000p               15705  1 dvb_usb_dib0700
dib0090                12297  1 dvb_usb_dib0700
dib7000m               12868  1 dvb_usb_dib0700
dib0070                 7510  1 dvb_usb_dib0700
dvb_usb                16683  1 dvb_usb_dib0700
dib8000                23992  1 dvb_usb_dib0700
dvb_core               87312  3 dib7000p,dvb_usb,dib8000
dib3000mc              11061  1 dvb_usb_dib0700
dibx000_common          3213  4 dib7000p,dib7000m,dib8000,dib3000mc
nouveau               387642  2 
ttm                    53985  1 nouveau
drm_kms_helper         25234  1 nouveau
snd_hda_intel          24006  3 
snd_hda_codec          82672  2 snd_hda_codec_realtek,snd_hda_intel
pcspkr                  1854  0 
ohci_hcd               33354  0 
cfbcopyarea             3037  1 nouveau
cfbimgblt               2205  1 nouveau
cfbfillrect             3113  1 nouveau
snd_hwdep               6048  1 snd_hda_codec
root [ ~teeveey ]# 



#############  but ls   for /dev/dvb*  yields nought like so:-

root [ ~teeveey ]# ls -l  /dev/dvb*
ls: cannot access /dev/dvb*: No such file or directory
root [ ~teeveey ]# 

I used the said device successfully  in a build wih 2,6.28.8/udev-113 last 
year  but it appears   the setup for DVB on linux has changed recently.  
Accordingly guidance on where I am gping wrong would be much appreciated.

Yours sincerely

sibuXolo
