Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:44908 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbZLTIVm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Dec 2009 03:21:42 -0500
Received: from smtp5-g21.free.fr (localhost [127.0.0.1])
	by smtp5-g21.free.fr (Postfix) with ESMTP id D1B92D48049
	for <linux-media@vger.kernel.org>; Sun, 20 Dec 2009 09:21:37 +0100 (CET)
Received: from [192.168.5.201] (lim91-1-88-178-105-125.fbx.proxad.net [88.178.105.125])
	by smtp5-g21.free.fr (Postfix) with ESMTP id EC36AD480D9
	for <linux-media@vger.kernel.org>; Sun, 20 Dec 2009 09:21:34 +0100 (CET)
Message-ID: <4B2DDE8E.4090708@free.fr>
Date: Sun, 20 Dec 2009 09:21:34 +0100
From: Yves <ydebx6@free.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Nova-T 500 Dual DVB-T
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have a Nova-T 500 Dual DVB-T card that used to work very well under 
Mandriva 2008.1 (kernel 2.6.24.7).

I moved to Mandriva 2009.1, then 2010.0 (kernel 2.6.31.6) and it doesn't 
work well any more. Scan can't find channels. I tried hading "options 
dvb-usb-dib0700 force_lna_activation=1" in /etc/modprobe.conf. It 
improve just a bit. Scan find only a few channels. If I revert to 
Mandriva 2008.1 (in another partition), all things are good (without 
adding anything in modprobe.conf).

Is there a new version of the driver (dvb_usb_dib0700) that correct this 
behavior.
If not, how to install the driver from kernel 2.6.24.7 in kernel 2.6.31.6 ?

regards

Yves


