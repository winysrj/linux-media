Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1KLxlqm005358
	for <video4linux-list@redhat.com>; Wed, 20 Feb 2008 16:59:47 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m1KLxDj9026312
	for <video4linux-list@redhat.com>; Wed, 20 Feb 2008 16:59:14 -0500
Date: Wed, 20 Feb 2008 22:58:51 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Thomas Kaiser <linux-dvb@kaiser-linux.li>
Message-ID: <20080220215850.GA2391@daniel.bse>
References: <47BC7E91.6070303@kaiser-linux.li>
	<175f5a0f0802201208u4bca35afqc0291136fe2482b@mail.gmail.com>
	<47BC8BFC.2000602@kaiser-linux.li>
	<175f5a0f0802201232y6a1bfc53u4fe92fede3abcb34@mail.gmail.com>
	<47BC90CA.1000707@kaiser-linux.li>
	<175f5a0f0802201254q7dc96190k35caafe9ba7d3274@mail.gmail.com>
	<47BC9788.7070604@kaiser-linux.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BC9788.7070604@kaiser-linux.li>
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: V4L2_PIX_FMT_RAW
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

On Wed, Feb 20, 2008 at 10:11:36PM +0100, Thomas Kaiser wrote:
> H. Willstrand wrote:
> >Well, it can go ugly if one piece of hardware supports several "raw"
> >formats, they need to be distinct. And in the end of the day the V4L2
> >drivers might consist of several identical "raw" formats which then
> >aren't consolidated.
> 
> I don't really understand what you try to say here.

Think about an analog TV card.
In the future there might be one where RAW could mean either sampled
CVBS or sampled Y/C. The card may be able to provide the Y/C in planar
and packed format. It may be capable of 16 bit at 13.5Mhz and 8 bit at
27Mhz, ...

If we start defining raw formats, there needs to be a way to choose
between all those variants without defining lots of additional pixel
formats.

Maybe an ioctl VIDIOC_S_RAW where one passes a number to select the
variant. An application would then have to check the driver and version
field returned by VIDIOC_QUERYCAP to determine the number to pass. This
way drivers may freely assign numbers to their raw formats.

Application writers would need to look into all drivers' docs/sources to
find the possible values. They would need to do it anyway to see if they
can decode the raw format.

  Daniel

P.S.: If my mail doesn't reach the list, blame its spam filter

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
