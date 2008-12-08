Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB8A6U5n012843
	for <video4linux-list@redhat.com>; Mon, 8 Dec 2008 05:06:30 -0500
Received: from si01.xit.com.hk (si01.xit.com.hk [202.67.236.24])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB8A6DN6012917
	for <video4linux-list@redhat.com>; Mon, 8 Dec 2008 05:06:14 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by si01.xit.com.hk (Postfix) with ESMTP id 65AF8C7068
	for <video4linux-list@redhat.com>; Mon,  8 Dec 2008 18:06:12 +0800 (HKT)
Received: from si01.xit.com.hk ([127.0.0.1])
	by localhost (si01.xit.com.hk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ec4SmA6qj5Ot for <video4linux-list@redhat.com>;
	Mon,  8 Dec 2008 18:06:11 +0800 (HKT)
Received: from [192.168.128.30] (pcd343119.netvigator.com [203.218.133.119])
	by si01.xit.com.hk (Postfix) with ESMTP id 63068C7066
	for <video4linux-list@redhat.com>; Mon,  8 Dec 2008 18:06:11 +0800 (HKT)
Message-ID: <493CF1AD.5040701@xit.com.hk>
Date: Mon, 08 Dec 2008 18:06:37 +0800
From: Chris Ruehl <v4l@xit.com.hk>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: HVR4000 can't tune
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi all,

I still stuck in the problem that I can't tune to the
AGILA2 KU-Band sat using the HVR4000 
- cx24116_load_firmware: FW version 1.22.82.0  .

I sure the Dish is working properly (have my Dreambox running on it and 
use the
Frequencies where I got a good signal)

Someone any successions?

Thanx
Chris

my scan file:
#AGILA2
S 12501000 H 30002000 3/4


cx24116 log:
Dec  8 17:34:26 vbox kernel: cx24116: cx24116_set_frontend: DVB-S 
delivery system selected
Dec  8 17:34:26 vbox kernel: cx24116: cx24116_set_inversion(0)
Dec  8 17:34:26 vbox kernel: cx24116: cx24116_set_fec(0x00,0x03)
Dec  8 17:34:26 vbox kernel: cx24116: cx24116_lookup_fecmod(0x00,0x03)
Dec  8 17:34:26 vbox kernel: cx24116: cx24116_set_fec() mask/val = 0x08/0x30
Dec  8 17:34:26 vbox kernel: cx24116: cx24116_set_symbolrate(30002000)
Dec  8 17:34:26 vbox kernel: cx24116: cx24116_set_symbolrate() 
symbol_rate = 30002000
Dec  8 17:34:26 vbox kernel: cx24116: cx24116_set_frontend:   
modulation  = 0
Dec  8 17:34:26 vbox kernel: cx24116: cx24116_set_frontend:   
frequency   = 1900000
Dec  8 17:34:26 vbox kernel: cx24116: cx24116_set_frontend:   
pilot       = 0 (val = 0x00)
Dec  8 17:34:26 vbox kernel: cx24116: cx24116_set_frontend:   
retune      = 1
Dec  8 17:34:26 vbox kernel: cx24116: cx24116_set_frontend:   
rolloff     = 0 (val = 0x02)
Dec  8 17:34:26 vbox kernel: cx24116: cx24116_set_frontend:   
symbol_rate = 30002000
Dec  8 17:34:26 vbox kernel: cx24116: cx24116_set_frontend:   
FEC         = 3 (mask/val = 0x08/0x30)
Dec  8 17:34:26 vbox kernel: cx24116: cx24116_set_frontend:   
Inversion   = 0 (val = 0x00)
Dec  8 17:34:26 vbox kernel: cx24116: cx24116_cmd_execute()

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
