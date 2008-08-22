Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7MDjm5t012174
	for <video4linux-list@redhat.com>; Fri, 22 Aug 2008 09:45:49 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7MDjdos022611
	for <video4linux-list@redhat.com>; Fri, 22 Aug 2008 09:45:39 -0400
From: Andy Walls <awalls@radix.net>
To: Trent Piepho <xyzzy@speakeasy.org>
In-Reply-To: <1219407994.2855.24.camel@morgan.walls.org>
References: <200808181918.05975.jdelvare@suse.de>
	<200808202334.20872.jdelvare@suse.de>
	<Pine.LNX.4.58.0808210107110.23833@shell4.speakeasy.net>
	<200808211114.27290.jdelvare@suse.de>
	<Pine.LNX.4.58.0808211445230.23833@shell4.speakeasy.net>
	<1219407994.2855.24.camel@morgan.walls.org>
Content-Type: text/plain
Date: Fri, 22 Aug 2008 09:45:20 -0400
Message-Id: <1219412720.2695.1.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
	Jean Delvare <jdelvare@suse.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [v4l-dvb-maintainer] bttv driver errors
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

On Fri, 2008-08-22 at 08:26 -0400, Andy Walls wrote:
> On Thu, 2008-08-21 at 15:50 -0700, Trent Piepho wrote:
> > On Thu, 21 Aug 2008, Jean Delvare wrote:
> > > Le jeudi 21 aot 2008, Trent Piepho a crit:
> > > > On Wed, 20 Aug 2008, Jean Delvare wrote:
> 
> > > > 4:2:0 YUV is achieved by setting the chip to 4:2:2 mode and then dropping
> > > > "every other" chroma line with RISC DMA program.
> > >
> > > OK. So you agree with me that this is approximative and not "real"
> > > vertical subsampling. I'm curious if more recent video chips are
> 
> Strictly speaking subsampling happens at the A to D conversion.  Follow
> on processes are filtering and, in this case, decimation.

Correcting myself on this point: "undersampling" happens at the A to D
conversion.  Sorry for the misstatement.

Regards,
Andy

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
