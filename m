Return-path: <linux-media-owner@vger.kernel.org>
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:45710 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756950Ab2HUPg4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 11:36:56 -0400
From: "M. Fletcher" <mpf30@cam.ac.uk>
To: "'Antti Palosaari'" <crope@iki.fi>
Cc: <linux-media@vger.kernel.org>
References: <00f301cd7fb1$b596f2c0$20c4d840$@cam.ac.uk> <5033A9C3.7090501@iki.fi>
In-Reply-To: <5033A9C3.7090501@iki.fi>
Subject: RE: Unable to load dvb-usb-rtl2832u driver in Ubuntu 12.04
Date: Tue, 21 Aug 2012 16:37:10 +0100
Message-ID: <00f401cd7fb2$d402c530$7c084f90$@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>It should be inside drivers/media/usb/dvb-usb-v2/ modinfo dvb_usb_rtl28xxu
should list it. 

Correct, it was in drivers/media/usb/dvb-usb-v2/
modinfo gives the expected output

>Also it is highly possible your device usb id is not known >by driver, you
should add it, easiest is just replace some existing rtl2832u device id.

Can you please advise how I do this? lsusb gives my device ID as 185b:0680

Regards,
Marc



