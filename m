Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n129Ykbp021654
	for <video4linux-list@redhat.com>; Mon, 2 Feb 2009 04:34:46 -0500
Received: from mail.constalant.com (mail.constalant.com [195.138.135.178])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n129YTWp030287
	for <video4linux-list@redhat.com>; Mon, 2 Feb 2009 04:34:29 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.constalant.com (Postfix) with ESMTP id F1CC711E8037
	for <video4linux-list@redhat.com>; Mon,  2 Feb 2009 11:34:18 +0200 (EET)
Received: from mail.constalant.com ([127.0.0.1])
	by localhost (constalant.com [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id ifbSgat7zJqC for <video4linux-list@redhat.com>;
	Mon,  2 Feb 2009 11:34:17 +0200 (EET)
Received: from 73.221.191-91.rev.maxtelecom.bg
	(73.221.191-91.rev.maxtelecom.bg [91.191.221.73])
	(using TLSv1 with cipher AES128-SHA (128/128 bits))
	(No client certificate requested)
	by mail.constalant.com (Postfix) with ESMTP id 416DD11E8036
	for <video4linux-list@redhat.com>; Mon,  2 Feb 2009 11:34:17 +0200 (EET)
Message-Id: <C528BDC8-8F63-4ED6-AED9-56F0F27C702F@constalant.com>
From: Getcho Getchev <ggetchev@constalant.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Date: Mon, 2 Feb 2009 11:34:20 +0200
Subject: PV143N watchdog
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

Greetings,
I am trying to control the PV143N watchdog via bttv driver under linux  
kernel 2.6.24.3.
According to the specification the watchdog is located at address  
0x56, subaddress 0x01.
However when I try to write something (a value of 0, 1 or 2) on that  
address I get NACK result.
I am using i2c_master_send() function and software bitbanging  
algorithm, implemented in bttv-i2c.c
At the beginning I suspected the SCL line (the clock for the  
communication must be set at 100 KHz) but when I saw the delay time is  
5 microseconds I realized the period is 10 microseconds which makes  
100 KHz. I tried to write the same data on address 0x2B and I  
succeeded (although I do not know what is there on that address) so it  
seems the bitbanging algorithm works fine along with the  
i2c_master_send() function. I suspect there must be some pre- 
conditions which I miss. Maybe some initialization on some other  
address or something else?
Did anyone face that problem?

Thanks in advance.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
