Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4RNF3vY016590
	for <video4linux-list@redhat.com>; Tue, 27 May 2008 19:15:03 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4RNElUM003658
	for <video4linux-list@redhat.com>; Tue, 27 May 2008 19:14:47 -0400
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <200805270900.20790.hverkuil@xs4all.nl>
References: <200805262326.30501.hverkuil@xs4all.nl>
	<1211850976.3188.83.camel@palomino.walls.org>
	<200805270853.31287.hverkuil@xs4all.nl>
	<200805270900.20790.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Tue, 27 May 2008 19:14:56 -0400
Message-Id: <1211930096.3197.10.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Michael Schimek <mschimek@gmx.at>
Subject: Re: Need VIDIOC_CROPCAP clarification
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

On Tue, 2008-05-27 at 09:00 +0200, Hans Verkuil wrote:
> Here's an old article I found detailing the design of pixelaspect, it 
> makes me wonder if what bttv does isn't wrong and pixelaspect is really 
> a pixel aspect.
> 
> http://www.spinics.net/lists/vfl/msg02653.html
> 
> Regards,
> 
> 	Hans
> 


Yet another good reference on pixel aspect conversions from one digital
video scheme to another:

http://lipas.uwasa.fi/~f76998/video/conversion/


Also,  I think I've determined the rationale for defining 12 3/11 MHz as
the sampling rate of NTSC for NTSC square pixel displays, since this
page challenges one to mail in a guess at the rationale:

http://lurkertech.com/lg/video-systems/#sqnonsq

I'll email the author, but once one realizes that 12 3/11 MHz is 1080/88
MHz and that it's related to the fc = 63/88 * 5 MHz FCC rule for the
NTSC chroma subcarrier, things begin to unwind from there.

-Andy


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
