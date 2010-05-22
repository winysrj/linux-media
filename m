Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f183.google.com ([209.85.221.183]:50172 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819Ab0EVQuX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 May 2010 12:50:23 -0400
Received: by qyk13 with SMTP id 13so3300372qyk.1
        for <linux-media@vger.kernel.org>; Sat, 22 May 2010 09:50:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimUOp1_CA24HQokWkrf4pqFdubzcZLEQdnF4jBA@mail.gmail.com>
References: <AANLkTimUOp1_CA24HQokWkrf4pqFdubzcZLEQdnF4jBA@mail.gmail.com>
Date: Sat, 22 May 2010 12:50:22 -0400
Message-ID: <AANLkTilluns_macQBykIKu6aiAo1TOBhgHbV1aXnztSq@mail.gmail.com>
Subject: Fwd: cx18 module not loading
From: J McBride <mcbride747@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It was suggested at ivtv-users that this be reported to this list.

Please let me know if I can provide some more information, or if there
is something that will help my problem.

Thanks,

Jeff


---------- Forwarded message ----------
From: J McBride <mcbride747@gmail.com>
Date: Sat, May 22, 2010 at 11:17 AM
Subject: cx18 module not loading
To: ivtv-users@ivtvdriver.org


I have attempted to get a Hauppauge HTV-1600 card working in
SimpyMepis.  I have generally followed the steps in the following
how-to guides:
http://www.linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers
and
http://ivtvdriver.org/index.php/Howto:Debian

I had to run "make config" and not configure the FireTV due to a
compilation error, then all seemed to work well until the command:
#modprobe cx18
which resulted in the error:
FATAL: Error inserting cx18
(/lib/modules/2.6.32-1-mepis64-smp/kernel/drivers/media/video/cx18/cx18.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
Then I did:
dmesg |grep cx18
cx18: Unknown symbol ir_codes_hauppauge_new_table
So, I am at my limit here.  I cannot find any similar errors through
google. Any suggestions on how I get this to work?
Thanks,
Jeff
