Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3KDkdxm005046
	for <video4linux-list@redhat.com>; Mon, 20 Apr 2009 09:46:39 -0400
Received: from nlpi053.prodigy.net (nlpi053.sbcis.sbc.com [207.115.36.82])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n3KDkMZX014285
	for <video4linux-list@redhat.com>; Mon, 20 Apr 2009 09:46:23 -0400
Received: from [192.168.0.201] (adsl-99-144-165-243.dsl.emhril.sbcglobal.net
	[99.144.165.243]) (authenticated bits=0)
	by nlpi053.prodigy.net (8.13.8 smtpauth/dk/map_regex/8.13.8) with ESMTP
	id n3KDkLuw023101
	for <video4linux-list@redhat.com>; Mon, 20 Apr 2009 08:46:22 -0500
Message-ID: <49EC7CBF.2070109@xnet.com>
Date: Mon, 20 Apr 2009 08:46:39 -0500
From: stuart <stuart@xnet.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Where is the v4l remote howto?  (kworld 110)
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

Remote control for tuner cards appears dicey and a bit confusing.  My 
impression is that it's no were near as rock solid as the efforts here 
(@ v4l) to support the tuner portion of the cards.  So I've always been 
willing to put in some work.  When I used an analog happauge tuner card 
I went to some length to get lirc working.  Now as I switch to digital, 
I find my self wanting to use an old but well supported kworld 110 ATSC 
tuner.  I assume this means I will be using v4l keyboard events instead 
of the lirc kernel modules.  However, I've not found a good source of 
information as to how to go about this.  It's more likely I haven't 
googled properly.  Can anyone point me in the right direction?

...thanks


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
