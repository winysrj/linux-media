Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.navvo.net ([74.208.67.6]:54215 "EHLO mail.navvo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756527AbZJ0SDF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Oct 2009 14:03:05 -0400
Message-ID: <4AE735D7.3040007@ridgerun.com>
Date: Tue, 27 Oct 2009 12:03:03 -0600
From: Santiago Nunez-Corrales <snunez@ridgerun.com>
Reply-To: santiago.nunez@ridgerun.com
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: "davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"Narnakaje, Snehaprabha" <nsnehaprabha@ti.com>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"Grosen, Mark" <mgrosen@ti.com>,
	Diego Dompe <diego.dompe@ridgerun.com>,
	"todd.fischer@ridgerun.com" <todd.fischer@ridgerun.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [PATCH 0/4 v5] Support for TVP7002 in DM365
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series of patches provide support for the TVP7002 decoder in DM365.

Support includes:

* Inclusion of the chip in v4l2 definitions
* Definition in board specific data structures
* Linking within the VPFE architecture
* Definition of TVP7002 specific data structures
* Kconfig and Makefile support

This series corrects many issued pointed out by Snehaprabha Narnakaje, 
Muralidharan Karicheri, Vaibhav Hiremath and Hans Verkuil and solves 
testing problems.  Tested on DM365 TI EVM with resolutions 720p, 
1080i@60, 576P and 480P with video capture application. Includes latest 
revisions from Hans. This driver depends upon board-dm365-evm.c and 
vpfe_capture.c to be ready for complete integration.

-- 
Santiago Nunez-Corrales, Eng.
RidgeRun Engineering, LLC

Guayabos, Curridabat
San Jose, Costa Rica
+(506) 2271 1487
+(506) 8313 0536
http://www.ridgerun.com


