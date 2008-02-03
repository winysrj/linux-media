Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m13EOX1M016869
	for <video4linux-list@redhat.com>; Sun, 3 Feb 2008 09:24:33 -0500
Received: from tonymontana.websupport.sk (postfix@tonymontana.websupport.sk
	[81.89.48.226])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m13EOCrh017336
	for <video4linux-list@redhat.com>; Sun, 3 Feb 2008 09:24:12 -0500
Received: from tonymontana.websupport.sk (localhost [127.0.0.1])
	by clamsmtp.websupport.sk (Postfix) with ESMTP id AACA9568398
	for <video4linux-list@redhat.com>; Sun,  3 Feb 2008 15:23:37 +0100 (CET)
Received: from [192.168.1.10] (adsl-dyn159.91-127-255.t-com.sk
	[91.127.255.159])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: peter.v@datagate.sk)
	by tonymontana.websupport.sk (Postfix) with ESMTP id 7CAFB568397
	for <video4linux-list@redhat.com>; Sun,  3 Feb 2008 15:23:37 +0100 (CET)
From: Peter =?ISO-8859-1?Q?V=E1gner?= <peter.v@datagate.sk>
To: video4linux-list@redhat.com
Content-Type: text/plain
Date: Sun, 03 Feb 2008 15:24:09 +0100
Message-Id: <1202048649.12975.9.camel@vb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: can't switch audio mode to stereo with avertv studio 303
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

Hello all,
I am unable to switch audio mode to stereo with my avertv studio 303.
This is a cx88xx device.
I am using mplayer for watching. Sound is transmitted to the pc via
audio cable connected to the soundcard.
When playing radio channels I can hear stereo sound but after playing
radio channels I am unable to switch audio mode to mono and I am getting
no sound when trying to play a tv channel.
I have just pulled v4l-dvb from the mercurial repository. I have built
it with the help from some guys at #v4l irc channel sucesfully. I am
runing ubuntu 7.10 with kernel 2.6.14-22-generic


I would be extremelly happy to have stereo sound. can anybody please let
me know if this is possible?

thanks

Peter

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
