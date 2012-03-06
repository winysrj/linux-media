Return-path: <linux-media-owner@vger.kernel.org>
Received: from dev.henes.no ([212.4.45.42]:48318 "EHLO dev.henes.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031036Ab2CFUkc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Mar 2012 15:40:32 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by dev.henes.no (Postfix) with ESMTP id 5D22EC9B57
	for <linux-media@vger.kernel.org>; Tue,  6 Mar 2012 21:36:55 +0100 (CET)
Received: from dev.henes.no ([127.0.0.1])
	by localhost (dev.henes.no [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IUP5UG03U0TZ for <linux-media@vger.kernel.org>;
	Tue,  6 Mar 2012 21:36:54 +0100 (CET)
Received: from [10.0.0.40] (cable-153-47.romerikebb.no [77.247.153.47])
	by dev.henes.no (Postfix) with ESMTPSA id C56EAC99F2
	for <linux-media@vger.kernel.org>; Tue,  6 Mar 2012 21:36:54 +0100 (CET)
Message-ID: <4F56763C.50806@henes.no>
Date: Tue, 06 Mar 2012 21:40:28 +0100
From: =?ISO-8859-1?Q?Johan_Hen=E6s?= <johan@henes.no>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Technotrend TT-Connect CT 3650 and dvb_ca
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Everyone !

I have three DVB-C devices of the type mentioned, connected to my 
mythtv-server which have been working great for a long time. As my cable 
provider now are planning to start encrypting all channels, I have 
bought a Xcrypt CAM module as needed. I soon realised that I needed to 
upgrade the kernel and are now running kernel /: 3.2.0-17-generic 
#27-Ubuntu SMP Fri Feb 24 22:03:50 UTC 2012 x86_64 x86_64 x86_64 
GNU/Linux/ .

When inserting the module everything looks well :

/dvb_ca adapter 0: DVB CAM detected and initialised successfully/

The problems start when trying to watch an encrypted channel. I do get a 
channel lock in myth, so far so good, but no picture...

In my syslog I see the following :

/dvb_ca adapter 0: CAM tried to send a buffer larger than the link 
buffer size (32896 > 255)!
dvb_ca adapter 0: CAM tried to send a buffer larger than the ecount size!
dvb_ca adapter 0: DVB CAM link initialisation failed :(/

Any ideas on what might be wrong ?

Best regards,

Johan

