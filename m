Return-path: <linux-media-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([203.16.214.141]:51452 "EHLO
	ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751014Ab0ACIVZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Jan 2010 03:21:25 -0500
Message-ID: <4B405381.9090407@internode.on.net>
Date: Sun, 03 Jan 2010 19:21:21 +1100
From: Raena Lea-Shannon <raen@internode.on.net>
MIME-Version: 1.0
To: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
CC: linux-media@vger.kernel.org
Subject: Re: DTV2000 H Plus issues
References: <4B3F6FE0.4040307@internode.on.net> <4B3F7B0D.4030601@mailbox.hu>
In-Reply-To: <4B3F7B0D.4030601@mailbox.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



istvan_v@mailbox.hu wrote:
> On 01/02/2010 05:10 PM, Raena Lea-Shannon wrote:
> 
>> I have 2 TV Cards. The DTV2000 H Plus and a Technisat. The Technisat
>> works very well. I am trying to get the DVT working for other video
>> input devices such as VCR to make copies of old Videos and an inteface
>> for my N95 video out.
>>
>> I do not seem to be able to get it to find a tuner. Seems to be problem
>> finding the card. Any suggestions wold be greatly appreciated.
> 
> This card uses an Xceive XC4000 tuner, which is not supported yet.
> However, a driver for the tuner chip is being developed at
> kernellabs.com, so the card may become supported in the future.
> --
[snip]

That seems odd. This patch on the LinuxTv site
http://www.linuxtv.org/pipermail/linux-dvb/2008-June/026379.html
seems to be using the cx88 drivers?
Has anyone tried this patch?

Ta
Raena

# HG changeset patch
# User plr.vincent at gmail.com
# Date 1212398724 -7200
# Node ID 78a011dfba127b593b6d01ea6a0010fcc29c94ad
# Parent  398b07fdfe79ff66a8c1bf2874de424ce29b9c78
WinFast DTV2000 H: add support for missing analog inputs

From: Vincent Pelletier <plr.vincent at gmail.com>

Add support for the following inputs:
  - radio tuner
  - composite 1 & 2 (only 1 is physicaly available, but composite 2 is also
    advertised by windows driver)
  - svideo

Signed-off-by: Vincent Pelletier <plr.vincent at gmail.com>

diff -r 398b07fdfe79 -r 78a011dfba12 
linux/drivers/media/video/cx88/cx88-cards.c
--- a/linux/drivers/media/video/cx88/cx88-cards.c       Wed May 28 
17:55:13 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-cards.c       Mon Jun 02 
11:25:24 2008 +0200
@@ -1297,7 +1297,35 @@
                         .gpio1  = 0x00008203,
                         .gpio2  = 0x00017304,
                         .gpio3  = 0x02000000,
+               },{
+                       .type   = CX88_VMUX_COMPOSITE1,
+                       .vmux   = 1,
+                       .gpio0  = 0x0001D701,
+                       .gpio1  = 0x0000B207,
+                       .gpio2  = 0x0001D701,
+                       .gpio3  = 0x02000000,
+               },{
+                       .type   = CX88_VMUX_COMPOSITE2,
+                       .vmux   = 2,
+                       .gpio0  = 0x0001D503,
+                       .gpio1  = 0x0000B207,
+                       .gpio2  = 0x0001D503,
+                       .gpio3  = 0x02000000,
+               },{
+                       .type   = CX88_VMUX_SVIDEO,
+                       .vmux   = 3,
+                       .gpio0  = 0x0001D701,
+                       .gpio1  = 0x0000B207,
+                       .gpio2  = 0x0001D701,
+                       .gpio3  = 0x02000000,
                 }},
+               .radio = {
+                        .type  = CX88_RADIO,
+                        .gpio0 = 0x00015702,
+                        .gpio1 = 0x0000F207,
+                        .gpio2 = 0x00015702,
+                        .gpio3 = 0x02000000,
+               },
                 .mpeg           = CX88_MPEG_DVB,
         },
         [CX88_BOARD_GENIATECH_DVBS] = {

> 
