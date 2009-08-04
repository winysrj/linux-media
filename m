Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n7408diO015364
	for <video4linux-list@redhat.com>; Mon, 3 Aug 2009 20:08:39 -0400
Received: from mail49.e.nsc.no (mail49.e.nsc.no [193.213.115.49])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n7408JdF030886
	for <video4linux-list@redhat.com>; Mon, 3 Aug 2009 20:08:20 -0400
To: Folkert van Heusden <folkert@vanheusden.com>
References: <20090717174101.GB15611@vanheusden.com>
From: Esben Stien <b0ef@esben-stien.name>
Date: Tue, 04 Aug 2009 03:08:00 +0200
In-Reply-To: <20090717174101.GB15611@vanheusden.com> (Folkert van Heusden's
	message of "Fri\, 17 Jul 2009 19\:41\:01 +0200")
Message-ID: <87skg84c9b.fsf@quasar.esben-stien.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com
Subject: Re: video4linux loopback device
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

Folkert van Heusden <folkert@vanheusden.com> writes:

> Any chance that the video4linux loopback device will be integrated in
> the main video4linux distribution and included in the kernel?

Why don't we focus on something like JACK[0], but for video, like
videojack[1]. This brings all this to userspace and we can pipe video
into and out of applications as easily as we're doing with audio with
JACK. 

This seems more like a final solution to me. 

[0]http://jackaudio.org/
[1]http://www.piksel.no/pwiki/VideoJack
[2]http://www.linuxmao.org/tikiwiki/img/wiki_up/patchage.png

-- 
Esben Stien is b0ef@e     s      a             
         http://www. s     t    n m
          irc://irc.  b  -  i  .   e/%23contact
           sip:b0ef@   e     e 
           jid:b0ef@    n     n

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
