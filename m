Return-path: <linux-media-owner@vger.kernel.org>
Received: from deliverator2.ecc.gatech.edu ([130.207.185.172]:40315 "EHLO
	deliverator2.ecc.gatech.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750790AbZEMFVg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 May 2009 01:21:36 -0400
Received: from deliverator2.ecc.gatech.edu (localhost [127.0.0.1])
	by localhost (Postfix) with SMTP id 6DD08480228
	for <linux-media@vger.kernel.org>; Wed, 13 May 2009 01:21:35 -0400 (EDT)
Received: from mail5.gatech.edu (bigip.ecc.gatech.edu [130.207.185.140])
	by deliverator2.ecc.gatech.edu (Postfix) with ESMTP id 163314801B5
	for <linux-media@vger.kernel.org>; Wed, 13 May 2009 01:21:35 -0400 (EDT)
Received: from [192.168.2.131] (bigip.ecc.gatech.edu [130.207.185.140])
	(Authenticated sender: gtg131s)
	by mail5.gatech.edu (Postfix) with ESMTP id EA1311FFBC
	for <linux-media@vger.kernel.org>; Wed, 13 May 2009 01:21:34 -0400 (EDT)
Message-ID: <4A0A58DE.9070708@gatech.edu>
Date: Wed, 13 May 2009 01:21:34 -0400
From: David Ward <david.ward@gatech.edu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
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
