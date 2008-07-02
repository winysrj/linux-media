Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m62AUd1U020971
	for <video4linux-list@redhat.com>; Wed, 2 Jul 2008 06:30:39 -0400
Received: from mailrelay005.isp.belgacom.be (mailrelay005.isp.belgacom.be
	[195.238.6.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m62AUIY7021450
	for <video4linux-list@redhat.com>; Wed, 2 Jul 2008 06:30:19 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Date: Wed, 2 Jul 2008 12:30:11 +0200
References: <14440.62.70.2.252.1214993763.squirrel@webmail.xs4all.nl>
In-Reply-To: <14440.62.70.2.252.1214993763.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807021230.12171.laurent.pinchart@skynet.be>
Cc: v4l <video4linux-list@redhat.com>
Subject: Re: uvc_driver.c compile error on 2.6.18
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

On Wednesday 02 July 2008, Hans Verkuil wrote:
> > Hi Hans,
> >
> > On Wednesday 02 July 2008, Hans Verkuil wrote:
> >> Hi all,
> >>
> >> The current v4l-dvb doesn't build anymore on 2.6.18:
> >>
> >>   CC [M]  /home/hans/work/src/v4l/v4l-dvb/v4l/uvc_driver.o
> >> /home/hans/work/src/v4l/v4l-dvb/v4l/uvc_driver.c: In
> >> function 'uvc_parse_control':
> >> /home/hans/work/src/v4l/v4l-dvb/v4l/uvc_driver.c:1135: warning: implicit
> >> declaration of function 'usb_endpoint_is_int_in'
> >> /home/hans/work/src/v4l/v4l-dvb/v4l/uvc_driver.c: At top level:
> >> /home/hans/work/src/v4l/v4l-dvb/v4l/uvc_driver.c:1918: error: unknown
> >> field 'supports_autosuspend' specified in initializer
> >> /home/hans/work/src/v4l/v4l-dvb/v4l/uvc_driver.c:1918: warning: missing
> >> braces around initializer
> >> /home/hans/work/src/v4l/v4l-dvb/v4l/uvc_driver.c:1918: warning: (near
> >> initialization for 'uvc_driver.driver.dynids')
> >> make[3]: *** [/home/hans/work/src/v4l/v4l-dvb/v4l/uvc_driver.o] Error 1
> >> make[2]: *** [_module_/home/hans/work/src/v4l/v4l-dvb/v4l] Error 2
> >> make[2]: Leaving directory `/home/hans/work/src/kernels/linux-2.6.18.8'
> >> make[1]: *** [default] Error 2
> >> make[1]: Leaving directory `/home/hans/work/src/v4l/v4l-dvb/v4l'
> >> make: *** [all] Error 2
> >
> > Mauro committed the uvcvideo driver to the v4l-dvb tree two days ago. The
> > patch he based his commit on was intended for submission to the main Linux
> > tree, and as such didn't contain any support for older kernels.
> >
> > The uvcvideo driver supports kernels 2.6.15 upwards. The code can be found
> > in the SVN repository at svn://svn.berlios.de/linux-uvc/linux-uvc/trunk
> >
> > Fixing the driver in the hg tree to build with 2.6.18 would be duplicating
> > work. As I explained in a mail to Mauro, I don't want to drop the SVN
> > repository before the driver hits the main kernel tree, as it would
> > confuse users.
> >
> > What would be the best way to solve this issue ?
> 
> I think the easiest short term solution is to figure out what the first
> kernel is that allows uvcvideo to build and then adjust v4l/versions.txt
> accordingly.

If compiled in the v4l-dvb tree, the driver requires 2.6.22. Otherwise it will need 2.6.26, as it depends on the latest V4L2 API enhancements.

> When the compat stuff is merged with v4l-dvb later, then v4l/versions.txt
> can be adjusted again.


Regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
