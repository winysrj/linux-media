Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:49597 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbZJXOfh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Oct 2009 10:35:37 -0400
Received: from miniserver.lan (localhost.localdomain [127.0.0.1])
	by miniserver.lan (8.13.8/8.13.8/SuSE Linux 0.8) with ESMTP id n9OEZRdO010682
	for <linux-media@vger.kernel.org>; Sat, 24 Oct 2009 16:35:28 +0200
Date: Sat, 24 Oct 2009 16:35:10 +0200
From: Jens Nixdorf <jens.nixdorf@gmx.de>
To: linux-media@vger.kernel.org
Message-ID: <200910241635.10659.jens.nixdorf@gmx.de>
Subject: stb6100 is a motormouth
MIME-Version: 1.0
Content-Type: Text/Plain;
	charset="US-ASCII"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

in my vdr works a technotrend 3650 USB-Box, which uses a stb6100.ko. This 
module is flooding my logfiles with bandwidth-messages all the time. I have a 
file dvb.conf in /etc/modprobe.d (ubuntu 9.04), in which i wrote:

options stb6100 verbode=0

What is wrong? The module is still chatting all the time?

regards, Jens
