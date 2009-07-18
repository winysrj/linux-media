Return-path: <linux-media-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:34802 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbZGRQvE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jul 2009 12:51:04 -0400
Received: from smtp06.web.de (fmsmtp06.dlan.cinetic.de [172.20.5.172])
	by fmmailgate01.web.de (Postfix) with ESMTP id 525DA10C51DB6
	for <linux-media@vger.kernel.org>; Sat, 18 Jul 2009 18:51:03 +0200 (CEST)
Received: from [217.228.192.251] (helo=[172.16.99.2])
	by smtp06.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.110 #277)
	id 1MSD7n-0002OE-00
	for linux-media@vger.kernel.org; Sat, 18 Jul 2009 18:51:03 +0200
Message-ID: <4A61FD76.8010409@magic.ms>
Date: Sat, 18 Jul 2009 18:51:02 +0200
From: emagick@magic.ms
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Cinergy T2 stopped working with kernel 2.6.30
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

My Cinergy T2 (T²) doesn't work with kernels 2.6.30, 2.6.30.1, and 2.6.31-rc3,
but it works with kernel 2.6.29. The kernel logs

    dvb-usb: recv bulk message failed: -110

and the application (I've tried mythtv and mplayer) trying to access the DVB receiver
times out when trying to tune to a channel.

Is there anyone for whom dvb_usb_cinergyT2 of kernel 2.6.30 or later does work?


