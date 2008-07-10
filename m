Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6AJ6QOP022327
	for <video4linux-list@redhat.com>; Thu, 10 Jul 2008 15:06:26 -0400
Received: from smtp4-g19.free.fr (smtp4-g19.free.fr [212.27.42.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6AJ6CQf005997
	for <video4linux-list@redhat.com>; Thu, 10 Jul 2008 15:06:12 -0400
Message-ID: <48765E1E.9000606@free.fr>
Date: Thu, 10 Jul 2008 21:08:14 +0200
From: Thierry Merle <thierry.merle@free.fr>
MIME-Version: 1.0
To: David Ellingsworth <david@identd.dyndns.org>
References: <694825.25098.qm@web28404.mail.ukl.yahoo.com>
	<30353c3d0807101149t3166eeafn7011417ea173aaf1@mail.gmail.com>
In-Reply-To: <30353c3d0807101149t3166eeafn7011417ea173aaf1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: Own software to use a camera
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

David Ellingsworth a écrit :
> James,
>
> I suspect you may benefit from using the new v4l-library. It should
> help simplify the conversion of whatever format the camera supports
> into whichever format your application desires. The current
> development branch of the library is located here:
> http://linuxtv.org/hg/~tmerle/v4l2-library/
>
> Regards,
>
> David Ellingsworth
>   
And now this library is integrated in the current v4l-dvb branch
http://linuxtv.org/hg/v4l-dvb
You will find the lib in v4l2-apps/lib/libv4l.
All this work was made by Hans de Goede.

Cheers,
Thierry

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
