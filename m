Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6QE9kax029506
	for <video4linux-list@redhat.com>; Sat, 26 Jul 2008 10:09:46 -0400
Received: from nlpi053.prodigy.net (nlpi053.sbcis.sbc.com [207.115.36.82])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6QE9Yoa026099
	for <video4linux-list@redhat.com>; Sat, 26 Jul 2008 10:09:34 -0400
Received: from [192.168.0.201] (adsl-75-4-155-229.dsl.emhril.sbcglobal.net
	[75.4.155.229]) (authenticated bits=0)
	by nlpi053.prodigy.net (8.13.8 smtpauth/dk/8.13.8) with ESMTP id
	m6QE9NLp002613
	for <video4linux-list@redhat.com>; Sat, 26 Jul 2008 09:09:28 -0500
Message-ID: <488B3012.3080004@xnet.com>
Date: Sat, 26 Jul 2008 09:09:22 -0500
From: stuart <stuart@xnet.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: IR remote control support for kworld 120???
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

Hi...

I understand the new kworld 120 (replacement for the kworld 115 and 110) 
is not supported w.r.t. IR remote control.

So...

Was digging through the v4l code (staging from last week) and happened 
upon a "fixme note" w.r.t. the cx23885 chip.  At about line 550 in 
cx23885-cards.c there appears to be an unimplemented IR method for 
initializing the cx23885.  Does that mean there is no IR remote control 
support for any cx2388 based board?  I was hoping to find that all that 
was needed to get the kworld 120's IR remote working was the right 
connections into such IR methods.  (Yeah, I know, if it was that easy 
then the original kworld 120 author (thank you to him) would have done it.)

...thanks

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
