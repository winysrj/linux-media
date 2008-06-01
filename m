Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m51IsOFM030461
	for <video4linux-list@redhat.com>; Sun, 1 Jun 2008 14:54:24 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m51Is9W8010685
	for <video4linux-list@redhat.com>; Sun, 1 Jun 2008 14:54:10 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1K2sgz-0002I3-L3
	for video4linux-list@redhat.com; Sun, 01 Jun 2008 18:54:09 +0000
Received: from 189.100.52.37 ([189.100.52.37])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Sun, 01 Jun 2008 18:54:09 +0000
Received: from fragabr by 189.100.52.37 with local (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Sun, 01 Jun 2008 18:54:09 +0000
To: video4linux-list@redhat.com
From: =?ISO-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
Date: Sun, 1 Jun 2008 03:22:02 -0300
Message-ID: <bpr9h5-2m3.ln1@tux.abusar.org.br>
References: <c5bea28d26aa1caa1e85da.20080531171359.qnavryt4@webmail.dslextreme.com>
	<20080531231049.725bf4d2@tux>
	<loom.20080601T023335-56@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
In-Reply-To: <loom.20080601T023335-56@post.gmane.org>
Subject: Re: [PATCH] PowerColor RA330 (Real Angel 330) fixes
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

On Sun, 1 Jun 2008 02:45:22 +0000 (UTC)
Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us> wrote:

	Everything is fine now ;)

> Are you sure you applied it against the current Mercurial tip? I also had no TV
> sound when the MTS bit was 1, but I leave it 0, and have sound. FM worked,
> regardless.

	Yes, I applied to the latest v4l-dvb tree. But I did a stupid
thing: I wasn't using the "audio" cable... no problem. This board
really sucks. It doesn't even have dma audio :D.

> I used this line to test TV:
> mplayer tv://54 -tv
> chanlist=us-cable:normid=7:input=1:amode=1:immediatemode=0:alsa -vo xv -ao alsa
> 
> To test S-Video, I simply replaced "input=1" with "input=3" in the same line.

	Thanks, with input=3 it worked. The number changed because you
added the DEBUG entry right? I didn't know that the order would change
(I thought that it will respect the vmux value, but no problem, it
worked perfectly).

> It's from the download now referenced in the current extraction script.

	Ok, I used it and I can confirm that everything is working
perfectly. So Mauro Chehab, feel free to apply this patch from
Daniel (tested and approved ;). Now we can use v27 firmware. 

	Is it possible to send this little patch to Linus before he
releases 2.6.26 kernel? Thanks! :)

-- 
Linux 2.6.25: Funky Weasel is Jiggy wit it
http://u-br.net


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
