Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m58D9sJo008819
	for <video4linux-list@redhat.com>; Sun, 8 Jun 2008 09:09:54 -0400
Received: from viefep11-int.chello.at (viefep11-int.chello.at [62.179.121.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m58D9gpD019437
	for <video4linux-list@redhat.com>; Sun, 8 Jun 2008 09:09:42 -0400
From: Michael Schimek <mschimek@gmx.at>
To: Andy Walls <awalls@radix.net>
In-Reply-To: <1212805718.3168.99.camel@palomino.walls.org>
References: <200805262326.30501.hverkuil@xs4all.nl>
	<1211850976.3188.83.camel@palomino.walls.org>
	<200805270853.31287.hverkuil@xs4all.nl>
	<200805270900.20790.hverkuil@xs4all.nl>
	<1212791383.17465.742.camel@localhost>
	<1212805718.3168.99.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1
Date: Sun, 08 Jun 2008 14:27:25 +0200
Message-Id: <1212928045.17465.1044.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: Need VIDIOC_CROPCAP clarification
Reply-To: mschimek@gmx.at
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

On Fri, 2008-06-06 at 22:28 -0400, Andy Walls wrote:
> On Sat, 2008-06-07 at 00:29 +0200, Michael Schimek wrote:
> 
> > As Daniel wrote, another way to view this is that the active portion of
> > the video is about 52 µs wide. At 12.27 MHz (for NTSC square pixels) one
> > would sample or "crop" 638 pixels over this period.
> 
> 
> Actually since the NTSC line frequency is
> 
> Fh = 4.5 MHz/286 ~= 15.73426 kHz

I know. Do I have to give three decimal places for every single video
standard to explain the basic idea? ;-)

Michael


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
