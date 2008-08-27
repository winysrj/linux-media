Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7R5rfSa011316
	for <video4linux-list@redhat.com>; Wed, 27 Aug 2008 01:53:41 -0400
Received: from smtp-vbr14.xs4all.nl (smtp-vbr14.xs4all.nl [194.109.24.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7R5rdTd031340
	for <video4linux-list@redhat.com>; Wed, 27 Aug 2008 01:53:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Gordon Smith" <spiderkarma@gmail.com>
Date: Wed, 27 Aug 2008 07:53:35 +0200
References: <2df568dc0808261327w4fadadebm37b9516a5c4975b6@mail.gmail.com>
	<2df568dc0808261646t37eeb2e2o19646c4a9c939b7@mail.gmail.com>
	<2df568dc0808261752y777a98e1pa6e4bc4a2c53d3d7@mail.gmail.com>
In-Reply-To: <2df568dc0808261752y777a98e1pa6e4bc4a2c53d3d7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808270753.35928.hverkuil@xs4all.nl>
Cc: v4l <video4linux-list@redhat.com>
Subject: Re: Fwd: saa7134_empress streaming via v4l2
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

Hi Gordon,

Please go to the v4l2-apps directory and do a make there and then use 
the v4l2-ctl that is in the v4l2-apps/util directory. There was also a 
bug in v4l2-ctl, so hopefully this will fix it for you.

Did you also make sure that you are using the updated saa6752hs.ko 
module? That too has fixes for control handling.

Regards,

	Hans

On Wednesday 27 August 2008 02:52:43 Gordon Smith wrote:
> FYI, I changed saa7134 version and verified modules from your tree are 
loading.
> 
> 
> I added a print to saa7134-empress.c
> 
> dprintk("to call v4l2_ctrl_next: c->id=%x\n", c->id);
> 
>        c->id = v4l2_ctrl_next(ctrl_classes, c->id);
> 
> 
> When I run
> 
> gsmith@gsmith-pc104 ~ $ v4l2-ctl --list-ctrls --device=/dev/video2
> 
> 
> dmesg has
> 
> saa7133[0]/empress: open minor=2
> saa7133[0]/empress: to call v4l2_ctrl_next: c->id=80000000
> saa7133[0]/empress: to call v4l2_ctrl_next: c->id=80980001
> saa7133[0]/empress: to call v4l2_ctrl_next: c->id=80980900
> saa7133[0]/empress: to call v4l2_ctrl_next: c->id=80980901
> saa7133[0]/empress: to call v4l2_ctrl_next: c->id=80980902
> saa7133[0]/empress: to call v4l2_ctrl_next: c->id=80980903
> saa7133[0]/empress: to call v4l2_ctrl_next: c->id=80980905
> saa7133[0]/empress: to call v4l2_ctrl_next: c->id=80980909
> saa7133[0]/empress: to call v4l2_ctrl_next: c->id=80980914
> saa7133[0]/empress: to call v4l2_ctrl_next: c->id=80990001
> saa7133[0]/empress: to call v4l2_ctrl_next: c->id=80000000
> saa7133[0]/empress: to call v4l2_ctrl_next: c->id=80980001
> saa7133[0]/empress: to call v4l2_ctrl_next: c->id=80980900
> saa7133[0]/empress: to call v4l2_ctrl_next: c->id=80980901
> saa7133[0]/empress: to call v4l2_ctrl_next: c->id=80980902
> saa7133[0]/empress: to call v4l2_ctrl_next: c->id=80980903
> saa7133[0]/empress: to call v4l2_ctrl_next: c->id=80980905
> saa7133[0]/empress: to call v4l2_ctrl_next: c->id=80980909
> saa7133[0]/empress: to call v4l2_ctrl_next: c->id=80980914
> saa7133[0]/empress: to call v4l2_ctrl_next: c->id=80990001
> 
> 
> The control query stops with the MPEG queries (at 
V4L2_CID_MPEG_STREAM_PID_PMT).
> 


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
