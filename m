Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay05.ispgateway.de ([80.67.31.94]:36652 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab2AXTp6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jan 2012 14:45:58 -0500
Received: from [80.67.16.116] (helo=webmailfront01.ispgateway.de)
	by smtprelay05.ispgateway.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68)
	(envelope-from <mythtv@x-defense.de>)
	id 1Rpm9w-00048L-FK
	for linux-media@vger.kernel.org; Tue, 24 Jan 2012 20:36:00 +0100
Date: Tue, 24 Jan 2012 20:36:00 +0100
Message-ID: <20120124203600.Horde.EdlOc7uWis5PHwggbBnSPKA@www.domaingo-webmail.de>
From: Thor <mythtv@x-defense.de>
To: linux-media@vger.kernel.org
Subject: recurring Problem with CAM on Technotrend TT-connect CT-3650
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


hi all,


checked out git on january 8th.

have the cam working,but it stops working every two or 3 days (system
is running 24 hours)
sometimes it recovers on its own:

Jan 21 20:59:45 zotac kernel: [81316.229519] dvb_ca adapter 0: CAM
tried to send a buffer larger than the ecount size!
Jan 21 20:59:45 zotac kernel: [81316.229752] dvb_ca adapter 0: DVB CAM
link initialisation failed :(
Jan 21 20:59:52 zotac kernel: [81323.339595] dvb_ca adapter 0: DVB CAM
detected and initialised successfully

sometimes it doesn't :

Jan 24 04:35:54 zotac kernel: [281485.531723] dvb_ca adapter 0: CAM
tried to send a buffer larger than the link buffer size (32896 > 255)!
Jan 24 04:35:55 zotac kernel: [281485.629455] dvb_ca adapter 0: CAM
tried to send a buffer larger than the ecount size!
Jan 24 04:35:55 zotac kernel: [281485.629702] dvb_ca adapter 0: DVB
CAM link initialisation failed :(

rmmod -f dvb_usb_ttusb2 && modprobe dvb_usb_ttusb2 does bring it back to live.

I am running on 3.0.0-14-generic-pae #23-Ubuntu SMP Mon Nov 21
22:07:10 UTC 2011 i686 i686 i386 GNU/Linux from mythbuntu.

is there any more info you would need ?
any advise available ?

tia
thorsten


