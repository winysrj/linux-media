Return-path: <linux-media-owner@vger.kernel.org>
Received: from postman.rheinmetall.ca ([207.61.105.104]:43438 "EHLO
	postman.oerlikon.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753248AbZDUDPd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 23:15:33 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: need help for omap3 isp-camera interface
Date: Mon, 20 Apr 2009 23:01:51 -0400
Message-ID: <C01FCF206F5D8D4C89B210408D7DB39C29B6BA@mail2.oerlikon.ca>
From: "Weng, Wending" <WWeng@rheinmetall.ca>
To: <linux-media@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,
 
   I'm working on video image capture(omap3 isp) interface(PSP 1.0.2), and have met many difficulties. At the camera side, the 8 bits BT656 signal are connected to cam_d[0-7], which looks OK. The cam_fld, cam_hs and cam_vs are also connected, At the omap3 side, I use saMmapLoopback.c, it runs, however, it receives only HS_VS_IRQ, but no any image data. I checked FLDSTAT(CCDC_SYN_MODE), it's never changed.
Right now, I don't know what to check, if you can give some suggestions, your help will be greatly appreciated. Thanks in advance.
 
Wending Weng
