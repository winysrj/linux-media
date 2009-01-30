Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:58462 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbZA3Jrl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jan 2009 04:47:41 -0500
Received: by ewy14 with SMTP id 14so610321ewy.13
        for <linux-media@vger.kernel.org>; Fri, 30 Jan 2009 01:47:40 -0800 (PST)
Subject: [linux-dvb] saa716x: HC82 does not work
From: Martin Pauly <madmufflon@googlemail.com>
To: linux-media@vger.kernel.org
In-Reply-To: <497F9DFA.3000603@gmail.com>
References: <20090105170950.GA7131@dreamland.darkstar.lan>
	 <497F9DFA.3000603@gmail.com>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 10:47:36 +0100
Message-Id: <1233308856.6759.16.camel@martin>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hey,
i have a avermedia hc82. This one should be working with the saa716x
driver, but it isnt. Im trying to get it working on a 64bit Ubuntu
System. I installed the latest driver and loaded kernel moduls
saa716x_core and saa716x_hybrid, but there still is no /dev/dvb
directory. 
The output of  lsmod | grep saa716x is: 
saa716x_hybrid         19464  0 
tda1004x               26244  1 saa716x_hybrid
saa716x_core           67892  1 saa716x_hybrid
dvb_core              113324  2 saa716x_hybrid,saa716x_core
i2c_core               36128  2 tda1004x,saa716x_core
so the modules are loaded.
Any ideas? Anything I can do to make it work?

Thanks,
Martin


