Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:51464 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbZEYUL7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2009 16:11:59 -0400
Received: from smtp2-g21.free.fr (localhost [127.0.0.1])
	by smtp2-g21.free.fr (Postfix) with ESMTP id 7734D4B01D7
	for <linux-media@vger.kernel.org>; Mon, 25 May 2009 22:11:54 +0200 (CEST)
Received: from gandalf.hd.free.fr (wmh38-1-82-225-140-65.fbx.proxad.net [82.225.140.65])
	by smtp2-g21.free.fr (Postfix) with ESMTP id 7E36E4B0113
	for <linux-media@vger.kernel.org>; Mon, 25 May 2009 22:11:52 +0200 (CEST)
Received: from localhost
	([127.0.0.1] helo=gandalf.localnet ident=domi)
	by gandalf.hd.free.fr with esmtp (Exim 4.69)
	(envelope-from <domi.dumont@free.fr>)
	id 1M8gWV-00037H-Ao
	for linux-media@vger.kernel.org; Mon, 25 May 2009 22:11:51 +0200
From: Dominique Dumont <domi.dumont@free.fr>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Mon, 25 May 2009 22:11:49 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905252211.50393.domi.dumont@free.fr>
Subject: dvb_usb_nova_t_usb2: firmware is loaded too late
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

I have some trouble with the initialisation of dvb_usb_nova_t_usb2: the 
firmware is loaded about 1 minute after the module is registered by usbcore:

May 25 11:42:30 gandalf kernel: [   79.511486] usbcore: registered new 
interface driver dvb_usb_nova_t_usb2
May 25 11:43:30 gandalf kernel: [  150.149787] usb 4-4: firmware: requesting 
dvb-usb-nova-t-usb2-02.fw
May 25 11:43:30 gandalf kernel: [  150.278343] dvb-usb: downloading firmware 
from file 'dvb-usb-nova-t-usb2-02.fw'

The problem I have is that vdr will start after the nova module is loaded but 
before the firmware is loaded. Unfortunately, vdr will not be able to detect 
the nova device so the dvb-t channels are not usable until vdr is restarted.

Where does this delay between module load and firmware upload comes from ?
Is there a way to reduce or supress this delay ?

All the best


