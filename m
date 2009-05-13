Return-path: <linux-media-owner@vger.kernel.org>
Received: from deliverator11.gatech.edu ([130.207.165.83]:44972 "EHLO
	deliverator11.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbZEMFlU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 May 2009 01:41:20 -0400
Received: from deliverator3.ecc.gatech.edu (deliverator3.ecc.gatech.edu [130.207.185.173])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by deliverator11.gatech.edu (Postfix) with ESMTP id DEABB181009
	for <linux-media@vger.kernel.org>; Wed, 13 May 2009 01:10:43 -0400 (EDT)
Message-ID: <4A0A5613.3000204@gatech.edu>
Date: Wed, 13 May 2009 01:09:39 -0400
From: David Ward <david.ward@gatech.edu>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org
Subject: v4l-dvb rev 11757 broke building under Ubuntu Hardy
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am using v4l-dvb in order to add the cx18 driver under Ubuntu Hardy 
(8.04).

The build is currently broken under Hardy, which uses kernel 2.6.24.  I 
have traced the origin of the problem to revision 11757.  As seen in the 
latest cron job output, the build produces the error when trying to 
compile adv7343.c:

/usr/local/src/v4l-dvb/v4l/adv7343.c:506: error: array type has 
incomplete element type
/usr/local/src/v4l-dvb/v4l/adv7343.c:518: warning: initialization from 
incompatible pointer type
/usr/local/src/v4l-dvb/v4l/adv7343.c:520: error: unknown field 
'id_table' specified in initializer


Thanks for resolving this.

David Ward
