Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8S5oC7O014386
	for <video4linux-list@redhat.com>; Sun, 28 Sep 2008 01:50:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8S5nvDe029640
	for <video4linux-list@redhat.com>; Sun, 28 Sep 2008 01:49:57 -0400
Date: Sun, 28 Sep 2008 02:49:44 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: larrykathy3@verizon.net, Linux and Kernel Video
	<video4linux-list@redhat.com>
Message-ID: <20080928024944.7c5745b6@mchehab.chehab.org>
In-Reply-To: <230791.95357.qm@web84107.mail.mud.yahoo.com>
References: <230791.95357.qm@web84107.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: 
Subject: Re: new v4l-dvb
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

On Sun, 14 Sep 2008 10:52:57 -0700 (PDT)
Ruth Fernandez <larrykathy3@verizon.net> wrote:

> Hi again, Well I got the cx88-dvb.c file to list my card but the
> manager doesn't list the last few cards including mine and yours. this
> is the end of file(yellow).
> I've been googleing and Ifound a discussion (maybe yours)  about the a line in s5h1409 
> warn_printk(core, "Closing s5h1409 i2c gate to allow xc3028 detection\n") ;

This device doesn't work very well yet, due to this gate. 

The state of this gate can't be controlled well with the current approach. A
major redesign of cx88 is needed (replacing i2c methods). This will likely
happen soon.

> I'm
> running suse11 with the latest kernel my manager doesn't show these
> cards. 

So, you'll need to compile it by yourself.

It is available at:
	http://linuxtv.org/hg

If you have further questions, the better is to email to V4L mailing list:
	video4linux-list@redhat.com

It is better to subscribe there. I don't have this card, but there are some
people there who have any may help you.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
