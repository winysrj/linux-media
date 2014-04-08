Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.219]:44300 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756894AbaDHSNw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Apr 2014 14:13:52 -0400
Received: from [192.168.178.52] (p4FFB77C3.dip0.t-ipconnect.de [79.251.119.195])
	by smtp.strato.de (RZmta 32.32 DYNA|AUTH)
	with ESMTPSA id 60157fq38IDn7fS
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	for <linux-media@vger.kernel.org>;
	Tue, 8 Apr 2014 20:13:49 +0200 (CEST)
Message-ID: <53443C5D.9000607@xxor.de>
Date: Tue, 08 Apr 2014 20:13:49 +0200
From: Alexander Sosna <alexander@xxor.de>
Reply-To: alexander@xxor.de
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: gspca second isoc endpoint / kinect depth
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I took drivers/media/usb/gspca/kinect.c as skeleton to build a depth
driver for the kinect camera.

I needed to implement this feature because libfreenect performs so badly
on the raspberry pi that you can't get a single frame.

The kinecet has two isoc endpoints but gspca only uses the first.
To get it running I made a dirty hack to drivers/media/usb/gspca/gspca.c
I changed usb_host_endpoint *alt_xfer(...) so that it always returns the
second endpoint, which is not really good for everyone.


My driver is not ready for upstream now, it can not coexist with the
current gspca_kinect so you have to decide if you want to load the video
or the depth driver. Would be better to have one driver to do it all.

But in the meantime I would like to ask for ideas about a more clean
solution to get other isoc endpoints.

There was already a little discussion about this when kinect.c was
written by Antonio Ospite:
http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/26194

http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/26213

Has something changed?
Is there a point against making multiple endpoints available?
Better solution?

I am new to device drivers so I hope you can help me with this.




Regards,

Alexander


btw: Thanks for the gspca framework, I started writing a standalone
driver from scratch but the isoc handling f***** me up a bit.
Sorry for my poor English!
