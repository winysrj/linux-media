Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:65504 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbZGXHkh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2009 03:40:37 -0400
Received: by ewy26 with SMTP id 26so1556342ewy.37
        for <linux-media@vger.kernel.org>; Fri, 24 Jul 2009 00:40:35 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 24 Jul 2009 09:40:35 +0200
Message-ID: <6842a4030907240040k676997c9oe93b5b03548a6123@mail.gmail.com>
Subject: Technical Details on Abus Digiprotect TV8802 Capture Card
From: =?UTF-8?Q?Gregor_Glash=C3=BCttner?= <gregorprivat@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

I am trying to get a capture card working under linux. Ubuntu 8.09
loads bttv module but doesn´t recognize the type of the card - it is
not listed on cardlist.bttv . I tried several card=XX options (with
mediocre success, e.g. bad grey or green picture from only one input,
random change of input by changing between NTSC/PAL) but gave up since
the system often froze after closing xawtv.
The card is called ABUS Digiprotect TV8802. Windows-software
(including drivers and monitoring software) can be found at
abus-sc.com (http://www.abus-sc.co.uk/International/Service-Downloads/Software?q=tv8802&Send=Search).
The card features 4 composite inputs using BNC connectors and one
Cinch connector (for Video-Out i think). It has no tuner / radio /
remote. There is only one chip "Conexant Fusion 878A" on the card.
lspci identifies vendor=109E product 0878 and vendor=109E
product=036E. I installed the original drivers under WinXP and used
btspy which gave me the following output:

General information:
 Name:Abus Digiprotect TV8802
 Chip: Bt878 , Rev: 0x00
 Subsystem: 0x00000000
 Vendor: Gammagraphx, Inc.
 Values to MUTE audio:
  Mute_GPOE  : 0x3c7007
  Mute_GPDATA: 0x305000
 Has TV Tuner: No
 Number of Composite Ins: 4
  Composite in #1
   Composite1_Mux   : 2
   Composite1_GPOE  : 0x3c7007
   Composite1_GPDATA: 0x305002
  Composite in #2
   Composite2_Mux   : 2
   Composite2_GPOE  : 0x3c7007
   Composite2_GPDATA: 0x305001
  Composite in #3
   Composite3_Mux   : 2
   Composite3_GPOE  : 0x3c7007
   Composite3_GPDATA: 0x305003
  Composite in #4
   Composite4_Mux   : 2
   Composite4_GPOE  : 0x3c7007
   Composite4_GPDATA: 0x305002
 Has SVideo: No
 Has Radio: No

What confuses me, are the same values for GPDATA on Composite 1 and 4,
but maybe this is a problem with the software i used to select the
inputs (i used the software from abus-sc.com). I wasn´t able to use
the card using the drivers from btwincap.sf.net, but maybe this is
because the software from abus-sc.com needs the original drivers.

Maybe someone with more insight can add support for this card. I can
do some more testing / research, but need advice on what exactly to
do.

Best regards
Gregor

-- 
Partykeller
www.meineparty.at
