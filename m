Return-path: <linux-media-owner@vger.kernel.org>
Received: from imr-ma01.mx.aol.com ([64.12.206.39]:45519 "EHLO
	imr-ma01.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab2KHUYN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2012 15:24:13 -0500
Received: from mtaout-mb06.r1000.mx.aol.com (mtaout-mb06.r1000.mx.aol.com [172.29.41.70])
	by imr-ma01.mx.aol.com (Outbound Mail Relay) with ESMTP id 8CB17380001E4
	for <linux-media@vger.kernel.org>; Thu,  8 Nov 2012 15:24:12 -0500 (EST)
Received: from [192.168.1.35] (unknown [190.50.16.77])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mtaout-mb06.r1000.mx.aol.com (MUA/Third Party Client Interface) with ESMTPSA id 44A7AE0000DF
	for <linux-media@vger.kernel.org>; Thu,  8 Nov 2012 15:24:11 -0500 (EST)
Message-ID: <509C0B8A.2040600@netscape.net>
Date: Thu, 08 Nov 2012 16:44:10 -0300
From: =?ISO-8859-1?Q?Alfredo_Jes=FAs_Delaiti?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH 0/2] Add RC support for MyGica X8507
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All

This series add remote control support for MyGica X8507.
I test for 2 month under OpenSuse(X64) 11.4 and 12.2 with kernel 3.4, 3.5, 3.6 also 3.7-rc2 and rc3.

Signed-off-by: Alfredo J. Delaiti <alfredodelaiti@netscape.net>


Patch 1 add remote keytable definition

Patch 2 add support card


/drivers/media/pci/cx23885/cx23885-cards.c      	    |    3 +
/drivers/media/pci/cx23885/cx23885-input.c  	  	    |    9 ++
/drivers/media/rc/keymaps/Makefile             	   	    |    1 +
/drivers/media/rc/keymaps/rc-total-media-in-hand-02.c	    |   86 ++++++++++++++++++++
/include/media/rc-map.h			        	    |    1 +
5 files changed, 100 insertions(+)
create mode 100644 drivers/media/rc/keymaps/rc-total-media-in-hand-02.c


To do: 

	Radio FM {If apply the patch made for Miroslav Slugen work, with some objection; ([PATCH] Add support for radio tuners to cx23885 driver, and add example of radio support
 for Leadtek DVR3200 H tuners)}.
	ISDB {I am too far, I need more information and knowledge}
	

Thanks, Alfredo

-- 
Dona tu voz
http://www.voxforge.org/es
