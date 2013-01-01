Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:51412 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467Ab3AAVkl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Jan 2013 16:40:41 -0500
Received: from mailout-eu.gmx.com ([10.1.101.214]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0MgJFg-1TdPZg3XC2-00Nglu for
 <linux-media@vger.kernel.org>; Tue, 01 Jan 2013 22:40:38 +0100
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Tue, 01 Jan 2013 22:40:35 +0100
To: linux-media@vger.kernel.org
Subject: AverTV_A918R (af9035-af9033-tda18218) / patch proposal
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: Diorser <diorser@gmx.fr>
Message-ID: <op.wp845xcf4bfdfw@quantal>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

After struggling some days trying to wake up a AVerTV_HD_Express_A918R  
DVB-T card, I am stuck with a DMX_SET_PES_FILTER error reported by  
dvbsnoop, I cannot solve (beyond my skills).
This card is based on Afatech AF9035 +  AF9033 + NXP TDA18218HN, and then  
very similar to AVerTV_Volar_HD_PRO_A835 (in term of components used).

You will find all details and current state at:
http://www.linuxtv.org/wiki/index.php/AVerMedia_AVerTV_HD_Express_A918R

In the meantime, I propose following patches to get dvb_usb_af9035  
compatible with A918R.
--------------------------------------------------------------------------------------
--- /drivers/media/dvb-core/dvb-usb-ids.h
+++ /drivers/media/dvb-core/dvb-usb-ids.h
   @@ -233,6 +233,7 @@
   #define USB_PID_AVERMEDIA_A835                         0xa835
   #define USB_PID_AVERMEDIA_B835                         0xb835
  +#define USB_PID_AVERMEDIA_A918R                      0x0918
   #define USB_PID_AVERMEDIA_1867                         0x1867
   #define USB_PID_AVERMEDIA_A867                         0xa867
--------------------------------------------------------------------------------------
  --- /drivers/media/usb/dvb-usb-v2/af9035.c
  +++ /drivers/media/usb/dvb-usb-v2/af9035.c
  @@ -1125,6 +1125,8 @@
          { DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_B835,
                &af9035_props, "AVerMedia AVerTV Volar HD/PRO (A835)",  
NULL) },
  +       { DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A918R,
  +             &af9035_props, "AVerMedia AverTV (A918R)", NULL) },
          { DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_1867,
                &af9035_props, "AVerMedia HD Volar (A867)", NULL) },
--------------------------------------------------------------------------------------
If someone has some ideas to solve/understand the DMX_SET_PES_FILTER  
issue, please feel free to advise what should be tested or modified.
Thanks, and ... Happy New Year !
Diorser.
