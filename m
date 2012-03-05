Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:61836 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757496Ab2CEUmy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Mar 2012 15:42:54 -0500
Received: by lahj13 with SMTP id j13so5095451lah.19
        for <linux-media@vger.kernel.org>; Mon, 05 Mar 2012 12:42:53 -0800 (PST)
Message-ID: <4F552548.4000304@gmail.com>
Date: Mon, 05 Mar 2012 21:42:48 +0100
From: =?UTF-8?B?Um9nZXIgTcOlcnRlbnNzb24=?= <roger.martensson@gmail.com>
MIME-Version: 1.0
To: Jose Alberto Reguero <jareguero@telefonica.net>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Add CI support to az6007 driver
References: <1577059.kW45pXQ20M@jar7.dominio>
In-Reply-To: <1577059.kW45pXQ20M@jar7.dominio>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jose Alberto Reguero skrev 2012-03-05 00:22:
> This patch add CI support to az6007 driver.
>
> Signed-off-by: Jose Alberto Reguero<jareguero@telefonica.net>

Since I have this device and have access to a CAM-card and program card 
to access the encrypted channels(DVB-C) I thought I should try this 
patch and report my findings. First I have to say that I'm just a user 
and no developer.

After managing to include the patch in media_build I do get this in 
dmesg when inserting the CAM.

[  395.561886] dvb_ca adapter 2: DVB CAM detected and initialised 
successfully

When scanning I can find my channels.
I can watch unencrypted channels without problem even with the CAM inserted.

When trying a encrypted channel with gnutv I get this:

$ gnutv -adapter 2 -channels my-channels-v4.conf -out file t.mpg 
-timeout 30 TV3
Using frontend "DRXK DVB-C DVB-T", type DVB-C
status SCVYL | signal 02c7 | snr 00be | ber 00000000 | unc 00000704 | 
FE_HAS_LOCK
en50221_tl_handle_sb: Received T_SB for connection not in T_STATE_ACTIVE 
from module on slot 00

en50221_stdcam_llci_poll: Error reported by stack:-7

CAM Application type: 01
CAM Application manufacturer: cafe
CAM Manufacturer code: babe
CAM Menu string: Conax Conditional Access
CAM supports the following ca system ids:
   0x0b00
Received new PMT - sending to CAM...

And the resulting mpeg file is not watchable with mplayer.

Do you want me to test anything?
