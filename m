Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m83JwQgt030994
	for <video4linux-list@redhat.com>; Wed, 3 Sep 2008 15:58:26 -0400
Received: from smtp-vbr17.xs4all.nl (smtp-vbr17.xs4all.nl [194.109.24.37])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m83JwC1T020253
	for <video4linux-list@redhat.com>; Wed, 3 Sep 2008 15:58:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
Date: Wed, 3 Sep 2008 21:58:10 +0200
References: <A24693684029E5489D1D202277BE894411A07DFA@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE894411A07DFA@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809032158.10633.hverkuil@xs4all.nl>
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Subject: Re: [PATCH 15/15] OMAP3 camera driver: OMAP34XXCAM: Add Sensors
	Support.
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

On Wednesday 03 September 2008 18:49:32 Aguirre Rodriguez, Sergio 
Alberto wrote:
> Hans,
>
> This file hasn't yet been merged into Linus tree, these patches are
> made for applying on top of linux-omap tree, that's why you don't
> find it there.
>
> We came up to the conclusion that  we will only send you all the
> needed (and reworked with all the comments, of course) v4l2 changes
> for omap3 camera operation, and send the remaining ones, which are
> omap-specific, to the linux-omap list.

OK, clear.

> We'll keep you updated on this between this week and next one.
>
> I appreciate your time. Thanks.

FYI: I'm on vacation from September 10-29, so I will not be able to do 
any reviewing during that time. During my vacation I'll also be at the 
Linux conference in Portland and I hope to discuss some extensions to 
the v4l API there that could well have an impact on the 
previewer/resizer devices that you created.

It would really help me to have a description of what and how those 
devices are currently used for so that I can decide whether that will 
fit well with my ideas.

See this link for the RFC I wrote:

http://lists-archives.org/video4linux/23652-rfc-add-support-to-query-and-change-connections-inside-a-media-device.html

I think that most of the driver internals are no doubt OK, it's the 
public API that I will pay close attention to when I review.

Regards,

	Hans

>
> Regards,
> Sergio
>
> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Tuesday, September 02, 2008 1:24 AM
> To: video4linux-list@redhat.com
> Cc: Aguirre Rodriguez, Sergio Alberto
> Subject: Re: [PATCH 15/15] OMAP3 camera driver: OMAP34XXCAM: Add
> Sensors Support.
>
> On Saturday 30 August 2008 01:44:27 Aguirre Rodriguez, Sergio Alberto
>
> wrote:
> > From: Sergio Aguirre <saaguirre@ti.com>
> >
> > OMAP34XX: CAM: Add Sensors Support
> >
> > This adds support in OMAP34xx SDP board file for Sensor and Lens
> > driver.
> >
> > Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> > ---
> >  arch/arm/mach-omap2/board-3430sdp.c |  228
>
> ++++++++++++++++++++++++++++++++++++
>
> >  1 file changed, 228 insertions(+)
>
> Can you mail the original board-3430sdp.c file? I cannot find this
> file in the linux kernel (looked in the latest git tree from Linus).
>
> Regards,
>
> 	Hans


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
