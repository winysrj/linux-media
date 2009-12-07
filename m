Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout5.freenet.de ([195.4.92.95]:34850 "EHLO mout5.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932394AbZLGUMA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Dec 2009 15:12:00 -0500
Message-ID: <4B1D6194.4090308@freenet.de>
Date: Mon, 07 Dec 2009 21:12:04 +0100
From: Ruediger Dohmhardt <ruediger.dohmhardt@freenet.de>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>, linux-media@vger.kernel.org
Subject: Which modules for the VP-2033? Where is the module "mantis.ko"?
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Manu,

the driver from http://jusst.de/hg/v4l-dvb/ compiles fine on Suse-11.1
(2.6.27.39-0.2-default).

However, it does not build the module "mantis.ko", as it used to be.
Where is it?
A search for mantis like

    cd v4l-dvb-ccd0c555c680
    find . -name "mantis*.ko"

    -> ./v4l/mantis_core.ko

shows up just the mantis_core.ko.

Which modules I'm supposed to load for the VP-2033?

Ciao Ruediger



