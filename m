Return-path: <linux-media-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:54252 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbZFNNIe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jun 2009 09:08:34 -0400
Message-ID: <4A34F652.2060400@web.de>
Date: Sun, 14 Jun 2009 15:08:34 +0200
From: =?ISO-8859-1?Q?Andr=E9_Weidemann?= <Andre.Weidemann@web.de>
MIME-Version: 1.0
To: "Christian Heidingsfelder [Heidingsfelder + Partner]"
	<christian@heidingsfelder-partner.de>
CC: linux-media@vger.kernel.org
Subject: Re: TT-Connect S2 -3650 CI and a Pinnacle PCTV Dual Sat Pro PCI 4000I
References: <200906132231.19962.christian@heidingsfelder-partner.de>
In-Reply-To: <200906132231.19962.christian@heidingsfelder-partner.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chris,

Christian Heidingsfelder [Heidingsfelder + Partner] wrote:
 > It seems i own the two not working DVB-S Devices on linux.
 > Its a TT-Connect S2 -3650 CI and a Pinnacle PCTV Dual Sat Pro PCI 4000I.
 > Is there any chance to get one of them working. I use Gentoo with the 
2.6.29-
 > gentoo-r5 kernel.


a driver for the "Pinnacle PCTV Sat HDTV Pro USB (452e)" was written by 
Dominik Kuhlen at the beginning of last year. This Pinnacle device is 
based on the same hardware as the TechnoTrend S2-3600. From what I know 
Michael H. Schimek has contributed the S2-3650 code and CI handling for 
the box(anyone, please correct me if I am wrong).
Some interim state of drivers for above mentioned devices is currently 
included in Igor M. Liplianin's repository at
http://mercurial.intuxication.org/hg/s2-liplianin/
The linuxtv.org wiki lists a patch under
http://www.linuxtv.org/wiki/index.php/TechnoTrend_TT-connect_S2-3650_CI#S2API 
to be applied, but it fails on some chunks...

I'd say your best chance is to start asking the people who wrote the 
drivers to create a diff against http://linuxtv.org/hg/v4l-dvb that will 
eventually go into the kernel.

As for the "Pinnacle PCTV Dual Sat Pro PCI 4000I"...
All I know is that the wiki at 
http://www.linuxtv.org/wiki/index.php/Pinnacle_PCTV_Dual_Sat_Pro_PCI_4000I 
lists this device as not supported.

Regards.
  André
