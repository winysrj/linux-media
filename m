Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:39828 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbZEYCsE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 May 2009 22:48:04 -0400
Received: by ewy24 with SMTP id 24so2843661ewy.37
        for <linux-media@vger.kernel.org>; Sun, 24 May 2009 19:48:05 -0700 (PDT)
Date: Sun, 24 May 2009 22:47:59 -0400
From: Manu <eallaud@gmail.com>
Subject: Re : cannot rmmod stb0899
To: linux-media@vger.kernel.org
References: <4A180C71.1080109@handshake.de>
In-Reply-To: <4A180C71.1080109@handshake.de> (from operator@handshake.de on
	Sat May 23 10:47:13 2009)
Message-Id: <1243219679.13752.1@manu-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le 23/05/2009 10:47:13, Andreas Besse a écrit :
> Hello,
> 
> I'm using a KNC One TV-Station DVB-S2 Plus and a WinTV-NOVA-CI PCI
> with
> the multiprotocol drivers from http://www.jusst.de/hg/multiproto/
> (changeset: 7218:2a911b8f9910, date: Wed Jul 09 23:07:29 2008 +0400)
> 
> The drivers run fine since 250 (!) days, but I have an issue with 
> high
> cpu load. So I decited to apply the patch "Fix High CPU load in 'top'
> due to budget_av slot polling" from Oliver Endriss or try the current
> v4l tree.
> 
> First i tried to remove the current drivers. If i call "rmmod 
> stb0899"
> the driver is not removed. Instead an Error "ERROR: Module stb0899 is
> in
> use" is shown (but no application is using the device)
> 
> I also tried "rmmod -w stb0899". This leads to an infinite loop and
> I'm
> not able to kill the process.
> 
> How can I rmmod the stb0899 driver without rebooting the system?
> 

Easiest way to rmmod stb0899 is to go to your v4l-dvb devel directory 
and do;
sudo make unload
indeed stb0899 is needed by other drivers (like budget_ci and others). 
So this command will remove them all.
Anyway you need to compile all drivers from the same tree else things 
will go wrong.
Bye
Emmanuel
