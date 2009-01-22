Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0MBaa81031487
	for <video4linux-list@redhat.com>; Thu, 22 Jan 2009 06:36:36 -0500
Received: from smtp2-g21.free.fr (smtp2-g21.free.fr [212.27.42.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0MBaIKO024859
	for <video4linux-list@redhat.com>; Thu, 22 Jan 2009 06:36:19 -0500
Date: Thu, 22 Jan 2009 12:30:09 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Brian Marete <bgmarete@gmail.com>
Message-ID: <20090122123009.5f981cf0@free.fr>
In-Reply-To: <6dd519ae0901211253t539c56dcm9656d0cae2b5f25c@mail.gmail.com>
References: <6dd519ae0901181629m4a79732ala0daa870cefa74cc@mail.gmail.com>
	<20090119092610.65a2a90a@free.fr>
	<6dd519ae0901201251wb924d39k468627b7c778e3bf@mail.gmail.com>
	<20090121192634.5fc27ccf@free.fr>
	<6dd519ae0901211253t539c56dcm9656d0cae2b5f25c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Video4linux-list <video4linux-list@redhat.com>
Subject: Re: Problem streaming from gspca_t613 Webcam
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

On Wed, 21 Jan 2009 23:53:46 +0300
Brian Marete <bgmarete@gmail.com> wrote:

> Hello,

Hello Brian,

> I have also taken the liberty to attach the USB traces that I sent
> yesterday but which were too big. This time, I have cut the output of
	[snip]

I already got these traces.

I added your unknown sensor to the t613 subdriver. May you try the new
version in my mercurial repository?

Regards.

-- 
Ken ar c'hentan	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
