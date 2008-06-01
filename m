Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m51CcXoK015517
	for <video4linux-list@redhat.com>; Sun, 1 Jun 2008 08:38:33 -0400
Received: from ch-smtp02.sth.basefarm.net (ch-smtp02.sth.basefarm.net
	[80.76.149.213])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m51CbeiE003190
	for <video4linux-list@redhat.com>; Sun, 1 Jun 2008 08:37:55 -0400
Received: from c83-249-123-83.bredband.comhem.se ([83.249.123.83]:55802
	helo=mail.akerlind.nu)
	by ch-smtp02.sth.basefarm.net with esmtp (Exim 4.68)
	(envelope-from <jonatan@akerlind.nu>) id 1K2moY-0000FH-8I
	for video4linux-list@redhat.com; Sun, 01 Jun 2008 14:37:34 +0200
Received: from [172.22.0.130] (unknown [172.22.0.130])
	by mail.akerlind.nu (Postfix) with ESMTP id 8E69A60B57
	for <video4linux-list@redhat.com>;
	Sun,  1 Jun 2008 14:37:23 +0200 (CEST)
From: Jonatan =?ISO-8859-1?Q?=C5kerlind?= <jonatan@akerlind.nu>
To: video4linux-list@redhat.com
In-Reply-To: <1212092787.7328.16.camel@skoll>
References: <1212092787.7328.16.camel@skoll>
Content-Type: text/plain
Date: Sun, 01 Jun 2008 14:37:23 +0200
Message-Id: <1212323843.4184.7.camel@skoll>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: Hauppauge HVR-1300 analog troubles
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

An update:

I booted the system up today and modprobed tuner with debug=1 and cx88xx
with audio_debug=1 ir_debug=1 and tried to scan for channels and this
time everything worked just fine. Tried unloading the modules and
reloading everything without debugging and it still works. I cannot
really tell what is different this time from all my other attempts at
this but anyway it seems to be working.

Now, is there any possibility to get the mpeg2-encoder working? I'm
using the cx88-blackbird module but i'm not really sure if or what
firmware I should be downloading to the card. 

/Jonatan

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
