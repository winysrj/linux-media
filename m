Return-path: <linux-media-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:49983 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbZIGWaE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Sep 2009 18:30:04 -0400
Received: from cpe00142a336e11-cm001ac318e826.cpe.net.cable.rogers.com ([174.113.191.234] helo=crashcourse.ca)
	by astoria.ccjclearline.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <rpjday@crashcourse.ca>)
	id 1Mkmis-0005Vh-F8
	for linux-media@vger.kernel.org; Mon, 07 Sep 2009 18:30:06 -0400
Date: Mon, 7 Sep 2009 18:30:01 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
To: linux-media@vger.kernel.org
Subject: a couple odd Kconfig variables
Message-ID: <alpine.LFD.2.00.0909071828160.22514@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


  from my latest scanning script:

===== RADIO_TEA5764_XTAL
drivers/media/radio/radio-tea5764.c:132:#ifndef RADIO_TEA5764_XTAL
drivers/media/radio/radio-tea5764.c:133:#define RADIO_TEA5764_XTAL 1
drivers/media/radio/radio-tea5764.c:137:static int use_xtal =
RADIO_TEA5764_XTAL;
drivers/media/radio/Kconfig:401:config RADIO_TEA5764_XTAL
===== RADIO_TYPHOON_PROC_FS
drivers/media/radio/Kconfig:291:config RADIO_TYPHOON_PROC_FS

  note that that second Kconfig variable is defined but unused (i may
have reported this already), while the first seems redundant since
it's hard-coded in the source file anyway.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
