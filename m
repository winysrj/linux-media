Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5J6ibCT000305
	for <video4linux-list@redhat.com>; Thu, 19 Jun 2008 02:44:37 -0400
Received: from smtp-vbr9.xs4all.nl (smtp-vbr9.xs4all.nl [194.109.24.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5J6iPVI010079
	for <video4linux-list@redhat.com>; Thu, 19 Jun 2008 02:44:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Thu, 19 Jun 2008 08:44:16 +0200
References: <20080414114746.3955c089@glory.loctelecom.ru>
	<20080619153139.3ee379b4@glory.loctelecom.ru>
	<200806190824.15270.hverkuil@xs4all.nl>
In-Reply-To: <200806190824.15270.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806190844.16127.hverkuil@xs4all.nl>
Cc: gert.vervoort@hccnet.nl, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Beholder card M6 with MPEG2 coder
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

Does anyone know where I can buy one of these cards?

Regards,

	Hans

On Thursday 19 June 2008 08:24:15 Hans Verkuil wrote:
> On Thursday 19 June 2008 07:31:39 Dmitri Belimov wrote:
> > Hi Hermann
> >
> > > > I found next problems with empress :)))
> > > >
> > > > I can`t get via v4l2-ctl list of external control for control
> > > > MPEG settings via this tool. --list-ctrls and
> > > > --list-ctrls-menus In debug log I can see only one call
> > > > empress_querycap nothink vidioc_g_ext_ctrls/empress_g_ext_ctrls
> > > > calls. Didn`t work v4l2-ctl --log-status
> > >
> > > just a late/early note on this, I'm still without a working
> > > empress device.
> > >
> > > After you have fixed several bugs on the empress ioctl2
> > > conversion, you are still the first user after years and now hit
> > > mpeg extended controls, Hans from the ivtv project kindly
> > > introduced, but he is also without any such device and the stuff
> > > is completely untested.
> > >
> > > As far I know, there are no handlers yet to modify the
> > > parameters.
> >
> > Does this command work for ivtv cards?? Can somebody show me a
> > sample command line and output from ivtv (or from another card with
> > its own MPEG encoder)? I need to get control settings of MPEG.
> > I don't see how I can test this thing in Beholder.
>
> Hmm, the empress is broken: the required queryctrl ioctls are
> completely missing.
>
> The only way to change MPEG settings is to hardcode it in a program,
> calling VIDIOC_S_EXT_CTRLS directly with the controls that
> handle_ctrl() in saa6752.c understands.
>
> Regards,
>
> 	Hans
>
> > With my best regards, Dmitry.
> >
> > --
> > video4linux-list mailing list
> > Unsubscribe
> > mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> > https://www.redhat.com/mailman/listinfo/video4linux-list
>
> --
> video4linux-list mailing list
> Unsubscribe
> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
