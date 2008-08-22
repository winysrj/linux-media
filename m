Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7MKwDxf023257
	for <video4linux-list@redhat.com>; Fri, 22 Aug 2008 16:58:13 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7MKvxha004762
	for <video4linux-list@redhat.com>; Fri, 22 Aug 2008 16:57:59 -0400
From: Andy Walls <awalls@radix.net>
To: Daniel =?ISO-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
In-Reply-To: <20080822203247.GA928@daniel.bse>
References: <200808181918.05975.jdelvare@suse.de>
	<200808202334.20872.jdelvare@suse.de>
	<Pine.LNX.4.58.0808210107110.23833@shell4.speakeasy.net>
	<200808211114.27290.jdelvare@suse.de>
	<Pine.LNX.4.58.0808211445230.23833@shell4.speakeasy.net>
	<1219407994.2855.24.camel@morgan.walls.org>
	<20080822203247.GA928@daniel.bse>
Content-Type: text/plain; charset=utf8
Date: Fri, 22 Aug 2008 16:54:22 -0400
Message-Id: <1219438462.2897.43.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org,
	Jean Delvare <jdelvare@suse.de>
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

On Fri, 2008-08-22 at 22:32 +0200, Daniel Glöckner wrote:
> On Fri, Aug 22, 2008 at 08:26:34AM -0400, Andy Walls wrote:
> > What are the benefits of using the moving average filters before
> > decimation?
> 
> The benefit is that the upper spectrum is attenuated before it is
> mirrored into the lower spectrum by the decimation. After the decimation
> you have no way of removing those artifacts in a mathematically correct
> way.

Ah, of course. Thank you.  

I should have known that. :P  I didn't mentally connect decimation with
pulling the alias spectra in closer to overlap the main spectrum.


Regards,
Andy


> There are better FIR filters than 0.5 * x(0) + 0.5 * x(1), which will
> avoid aliasing even more and preserve more of the lower spectrum.
> This is just the simplest.
> 
> Btw., enabling the chroma comb filter in bttv will result in alternating
> 0.5*x(-2)+0.5*x(0) and 0.5*x(-1)+0.5*x(1) for frame captures and
> 0.5*x(-1)+0.5*x(0) for field captures. I have once tried to modify
> bttv_risc_planar to be closer to MPEG chroma subsampling when the comb
> filter is enabled, because I was annoyed by the gray first line.
> 
> On Thu, Aug 21, 2008 at 01:50:05AM -0700, Trent Piepho wrote:
> > A better question would be how does the bt878 do horizontal and vertical
> > scaling?  If you look at the description of ultralock and the number of
> > taps avaiable for the vertical scaling filters, the chip must have some
> > kind of multi-line buffer before the scaler.  But this buffer, and the
> > delay it must introduce, is never mentioned in the datasheet.
> 
> The buffer is "mentioned" in figure 2-4 of the Fusion 878A datasheet
> available on the Conexant website. Its size can be derived from the
> restrictions placed on the luma filters. It should be 768 luma samples.
> The decimation then has another full line buffer for luma and chroma
> to perform the linear luma interpolation and the chroma comb filter.
> 
>   Daniel
> 
> _______________________________________________
> v4l-dvb-maintainer mailing list
> v4l-dvb-maintainer@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/v4l-dvb-maintainer
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
