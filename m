Return-path: <linux-media-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:43003 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbZHLLmm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2009 07:42:42 -0400
Received: from cpe002129687b04-cm001225dbafb6.cpe.net.cable.rogers.com ([99.235.241.187] helo=crashcourse.ca)
	by astoria.ccjclearline.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <rpjday@crashcourse.ca>)
	id 1MbCE6-00008G-FO
	for linux-media@vger.kernel.org; Wed, 12 Aug 2009 07:42:42 -0400
Date: Wed, 12 Aug 2009 07:39:55 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
To: linux-media@vger.kernel.org
Subject: unused RADIO_TYPHOON_PROC_FS?
Message-ID: <alpine.LFD.2.00.0908120737580.20085@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


  my latest scan of the source tree shows the definition of the
Kconfig variable RADIO_TYPHOON_PROC_FS, but no usage of it anywhere.
just an observation.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
