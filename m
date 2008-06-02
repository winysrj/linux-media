Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m52KkxTc029267
	for <video4linux-list@redhat.com>; Mon, 2 Jun 2008 16:46:59 -0400
Received: from ch-smtp01.sth.basefarm.net (ch-smtp01.sth.basefarm.net
	[80.76.149.212])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m52Kkk3n025296
	for <video4linux-list@redhat.com>; Mon, 2 Jun 2008 16:46:46 -0400
Received: from c83-249-123-83.bredband.comhem.se ([83.249.123.83]:45017
	helo=mail.akerlind.nu)
	by ch-smtp01.sth.basefarm.net with esmtp (Exim 4.68)
	(envelope-from <jonatan@akerlind.nu>) id 1K3GvT-0003zo-57
	for video4linux-list@redhat.com; Mon, 02 Jun 2008 22:46:46 +0200
Received: from [172.22.0.6] (baloo.lan.akerlind.nu [172.22.0.6])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.akerlind.nu (Postfix) with ESMTP id C2FCA60B57
	for <video4linux-list@redhat.com>;
	Mon,  2 Jun 2008 22:46:41 +0200 (CEST)
From: Jonatan =?ISO-8859-1?Q?=C5kerlind?= <jonatan@akerlind.nu>
To: video4linux-list@redhat.com
In-Reply-To: <200806022158.54175.linux@janfrey.de>
References: <1212092787.7328.16.camel@skoll> <1212323843.4184.7.camel@skoll>
	<200806022158.54175.linux@janfrey.de>
Content-Type: text/plain; charset=ISO-8859-15
Date: Mon, 02 Jun 2008 22:46:41 +0200
Message-Id: <1212439601.18833.4.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
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

On mån, 2008-06-02 at 21:58 +0200, Jan Frey wrote:
> Hi Jonatan,
> 
> I'm quite successfully using this code here:
> http://linuxtv.org/hg/~rmcc/hvr-1300/
> 
> And additionally I have all the v4l modules unloaded and reloaded via 
> rc.local to get the tuner up reliably.
> 
> Regards,
> Jan

Ok, sounds nice. Right now I have the analog working but without the
MPEG encoder. This will have to do for now because I'm just about to
leave for a longer vacation trip, but when I get back I will definetely
have a look at this again. 

Thanks anyway

/Jonatan

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
