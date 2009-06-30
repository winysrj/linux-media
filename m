Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp27.orange.fr ([80.12.242.95]:64429 "EHLO smtp27.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbZF3TZu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jun 2009 15:25:50 -0400
Message-Id: <200906301927.n5UJRQ704365@neptune.localwarp.net>
Date: Tue, 30 Jun 2009 21:27:05 +0200 (CEST)
From: eric.paturage@orange.fr
Reply-To: eric.paturage@orange.fr
Subject: Re: (very) wrong picture with sonixj driver and  0c45:6128
To: moinejf@free.fr
cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 30 Jun, Jean-Francois Moine wrote:
> 
> On Mon, 29 Jun 2009 20:43:29 +0200 (CEST)
> eric.paturage@orange.fr wrote:
>> i am trying to use an "ngs skull" webcam with the gspca sonixj
>> driver . i enclose a screen copy , so one can see what what i mean :
>> the image is flatten vertically , there is 25% missing on the left .
>> and the color is all wrong , over-bright  . (no matter how much i try
>> to correct with v4l_ctl) the tests have been done with the latest
>> mercurial version of the v4l drivers (from sunday evening) on
>> 2.6.29.4 . I also tried it on 2 other computers (2.6.28.2 ) and
>> 2.6.27.4 . with sames results .
> 	[snip]

> Hello Eric,
> 
> Looking at the ms-win driver, it seems that the bridge is not the right
> one. May you try to change it? This is done in the mercurial tree
> editing the file:
> 
> 	linux/drivers/media/video/gspca/sonixj.c
> 
> and replacing the line 2379 from:
> 
> {USB_DEVICE(0x0c45, 0x6128), BSI(SN9C110, OM6802, 0x21)}, /*sn9c325?*/
> 
> to
> 
> {USB_DEVICE(0x0c45, 0x6128), BSI(SN9C120, OM6802, 0x21)}, /*sn9c325*/
> 

Hi JF
thanks for your suggestion , I modified  sonixj.c compiled and reloaded the driver 
but unfortunately   I get the same (wrong) picture as before  .
I put some mild debug in /etc/modprobe.conf 
  options gspca_main debug=0x000f

here is the result in dmesg : 

----------------------------------------------------
   gspca: main v2.6.0 registered
gspca: probing 0c45:6128
sonixj: Sonix chip id: 12
gspca: probe ok
usbcore: registered new interface driver sonixj
sonixj: registered
gspca: svv open
gspca: open done
width = 160, height=120
width = 320, height=240
width = 640, height=480
- Unknown type!
gspca: try fmt cap JPEG 640x480
gspca: try fmt cap JPEG 640x480
gspca: frame alloc frsz: 230990
gspca: reqbufs st:0 c:4
gspca: mmap start:b74ab000 size:233472
gspca: mmap start:b7472000 size:233472
gspca: mmap start:b7439000 size:233472
gspca: mmap start:b7400000 size:233472
gspca: use alt 8 ep 0x81
gspca: isoc 24 pkts size 1023 = bsize:24552
gspca: kill transfer
gspca: isoc 24 pkts size 1023 = bsize:24552
gspca: stream on OK JPEG 640x480
gspca: frame overflow 233714 > 233472
gspca: frame overflow 233606 > 233472
gspca: frame overflow 233901 > 233472
gspca: kill transfer
gspca: stream off OK
gspca: svv close
gspca: frame free
gspca: close done  


Regards                          


