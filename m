Return-path: <linux-media-owner@vger.kernel.org>
Received: from impaqm3.telefonica.net ([213.4.138.19]:59940 "EHLO
	telefonica.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757671Ab2CEXYY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Mar 2012 18:24:24 -0500
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: Roger =?ISO-8859-1?Q?M=E5rtensson?= <roger.martensson@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Add CI support to az6007 driver
Date: Tue, 06 Mar 2012 00:23:58 +0100
Message-ID: <1436129.Xg0ZNGxkxn@jar7.dominio>
In-Reply-To: <4F552548.4000304@gmail.com>
References: <1577059.kW45pXQ20M@jar7.dominio> <4F552548.4000304@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Lunes, 5 de marzo de 2012 21:42:48 Roger Mårtensson escribió:
> Jose Alberto Reguero skrev 2012-03-05 00:22:
> > This patch add CI support to az6007 driver.
> > 
> > Signed-off-by: Jose Alberto Reguero<jareguero@telefonica.net>
> 
> Since I have this device and have access to a CAM-card and program card
> to access the encrypted channels(DVB-C) I thought I should try this
> patch and report my findings. First I have to say that I'm just a user
> and no developer.
> 
> After managing to include the patch in media_build I do get this in
> dmesg when inserting the CAM.
> 
> [  395.561886] dvb_ca adapter 2: DVB CAM detected and initialised
> successfully
> 
> When scanning I can find my channels.
> I can watch unencrypted channels without problem even with the CAM inserted.
> 
> When trying a encrypted channel with gnutv I get this:
> 
> $ gnutv -adapter 2 -channels my-channels-v4.conf -out file t.mpg
> -timeout 30 TV3
> Using frontend "DRXK DVB-C DVB-T", type DVB-C
> status SCVYL | signal 02c7 | snr 00be | ber 00000000 | unc 00000704 |
> FE_HAS_LOCK
> en50221_tl_handle_sb: Received T_SB for connection not in T_STATE_ACTIVE
> from module on slot 00
> 
> en50221_stdcam_llci_poll: Error reported by stack:-7
> 
> CAM Application type: 01
> CAM Application manufacturer: cafe
> CAM Manufacturer code: babe
> CAM Menu string: Conax Conditional Access
> CAM supports the following ca system ids:
>    0x0b00
> Received new PMT - sending to CAM...
> 
> And the resulting mpeg file is not watchable with mplayer.
> 
> Do you want me to test anything?
> --

No. I tested the patch with DVB-T an watch encrypted channels with vdr without 
problems. I don't know why you can't. I don't know gnutv. Try with other 
software if you want.

Jose Alberto

