Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2477UCG016417
	for <video4linux-list@redhat.com>; Wed, 4 Mar 2009 02:07:30 -0500
Received: from smtp6-g21.free.fr (smtp6-g21.free.fr [212.27.42.6])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n2477Cgs011930
	for <video4linux-list@redhat.com>; Wed, 4 Mar 2009 02:07:13 -0500
Date: Wed, 4 Mar 2009 08:05:41 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: amol verule <amol.debian@gmail.com>
Message-ID: <20090304080541.0a12cf2c@free.fr>
In-Reply-To: <77ca8eab0903020539l6a5d015aucba5e222c5466088@mail.gmail.com>
References: <77ca8eab0903020539l6a5d015aucba5e222c5466088@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: application for microdia 0c45:6130
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

On Mon, 2 Mar 2009 19:09:36 +0530
amol verule <amol.debian@gmail.com> wrote:

> hi to all,
>             i am having device webcam of 0c45:6130 .with camorama it
> is showing blank screen as well not working with ekiga.so can please
> tell me which application should i use to use my webcam?
>              /dev/video0 is created means device is detected properly.

Hi Amol,

The images of your webcam are JPEG compressed. You must use the v4l
library wrapper for most applications but mplayer and vlc (0.9.x).

Otherwise, your webcam may be handled by two different drivers: sn9c102
and gspca. Which one are you using?

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
