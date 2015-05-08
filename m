Return-path: <linux-media-owner@vger.kernel.org>
Received: from bruce.bmat.com ([176.9.54.181]:48216 "EHLO bruce.bmat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733AbbEHLQU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 May 2015 07:16:20 -0400
Received: from localhost (localhost [127.0.0.1])
	by bruce.bmat.com (Postfix) with ESMTP id 9F2175E480F
	for <linux-media@vger.kernel.org>; Fri,  8 May 2015 13:16:19 +0200 (CEST)
Received: from bruce.bmat.com ([127.0.0.1])
	by localhost (bruce.bmat.srv [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gQxOZIePr4oB for <linux-media@vger.kernel.org>;
	Fri,  8 May 2015 13:16:17 +0200 (CEST)
Received: from jbrines.bmat.office (207.90.135.37.dynamic.jazztel.es [37.135.90.207])
	(Authenticated sender: jbrines@bmat.es)
	by bruce.bmat.com (Postfix) with ESMTPSA id 86FFE1254002
	for <linux-media@vger.kernel.org>; Fri,  8 May 2015 13:16:17 +0200 (CEST)
From: =?iso-8859-1?Q?Javier_Brines_Garcia_=7C=A0BMAT?= <jbrines@bmat.es>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: Fwd: Error with TBS6285
Date: Fri, 8 May 2015 13:16:16 +0200
References: <B13F8F10-6044-43B4-8006-D96690CC50B6@bmat.es>
To: linux-media@vger.kernel.org
Message-Id: <B137AE33-5722-4B67-BC43-D54902C5ADF2@bmat.es>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, 

I'm trying to use this card for DVB-C and when I use w_scan I get this error:

-_-_-_-_ Getting frontend capabilities-_-_-_-_ 
Using DVB API 5.3
frontend 'TurboSight TBS 62x1 DVBT/T2 frontend' supports
INVERSION_AUTO
QAM_AUTO
FEC_AUTO
FREQ (42.00MHz ... 1002.00MHz)
This dvb driver is *buggy*: the symbol rate limits are undefined - please report to linuxtv.org

Any ideas?

Many thanks,