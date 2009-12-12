Return-path: <linux-media-owner@vger.kernel.org>
Received: from cp-out9.libero.it ([212.52.84.109]:47777 "HELO
	cp-out9.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755230AbZLMDJq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Dec 2009 22:09:46 -0500
Received: from [151.82.188.131] (151.82.188.131) by cp-out9.libero.it (8.5.107)
        id 4B2251E0003D5479 for linux-media@vger.kernel.org; Sat, 12 Dec 2009 20:41:13 +0100
Subject: Adding support for Benq DC E300 camera
From: Francesco Lavra <francescolavra@interfree.it>
To: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Sat, 12 Dec 2009 20:41:24 +0100
Message-Id: <1260646884.23354.22.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I'm trying to get my Benq DC E300 camera to work under Linux.
It has an Atmel AT76C113 chip. I don't know how many Linux users would
benefit from a driver supporting this camera (and possibly other models,
too), so my question is: if/when such a driver will be written, is there
someone willing to review it and finally get it merged?
If the answer is yes, I will try to write something working.

This camera USB interface has 10 alternate settings, and altsetting 5 is
used to stream data; it uses two isochronous endpoints to transfer an
AVI-formatted video stream (320x240) to the USB host.
It would be great if someone could give me some information to make
writing the driver easier: so far, I have only USB sniffer capture logs
from the Windows driver.

Regards,
Francesco


