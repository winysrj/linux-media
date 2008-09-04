Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m84M6B2L002236
	for <video4linux-list@redhat.com>; Thu, 4 Sep 2008 18:06:12 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.228])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m84M61V5028655
	for <video4linux-list@redhat.com>; Thu, 4 Sep 2008 18:06:01 -0400
Received: by rv-out-0506.google.com with SMTP id f6so136898rvb.51
	for <video4linux-list@redhat.com>; Thu, 04 Sep 2008 15:06:00 -0700 (PDT)
Message-ID: <2df568dc0809041506w2c300f56r7b8cae3f2726c70@mail.gmail.com>
Date: Thu, 4 Sep 2008 16:06:00 -0600
From: "Gordon Smith" <spider.karma+video4linux-list@gmail.com>
To: video4linux-list@redhat.com
In-Reply-To: <200809040822.09653.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2df568dc0809031448y3e70715codb5f3a0be505f6cf@mail.gmail.com>
	<200809040822.09653.hverkuil@xs4all.nl>
Subject: Re: saa7134_empress standard vs input
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

On Thu, Sep 4, 2008 at 12:22 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On Wednesday 03 September 2008 23:48:39 Gordon Smith wrote:
> > Greetings -
> >
> > I have a RTD Technologies VFG7350 (saa7134 based, two channel,
> > hardware encoder per channel, no tuner) running current v4l-dvb in
> > 2.6.25-gentoo-r7.
> >
> > Short form question: Is it necessary to do something to connect an
> > input standard to an MPEG encoder?
> >
> > I seem to have a disconnect between input signal and the MPEG
> > encoder. In this case, there is a NTSC camera signal on the input.
> > Raw data and input selection are on video0. Raw data can be read from
> > and input selected on video0. MPEG encoder output is on video2. MPEG
> > data can be read from video2, but it looks like PAL aspect with NTSC
> > data (extra lines at bottom of image repeat uppermost lines).
> >
> >
> > $ v4l2-ctl --get-standard --device /dev/video0
> > Video Standard = 0x0000b000
> >         NTSC-M/M-JP/M-KR
> > $ v4l2-ctl --get-standard --device /dev/video2
> > Video Standard = 0x000000ff
> >         PAL-B/B1/G/H/I/D/D1/K
> >
> >
> > The input standard is automatically selected by the hardware.
> > Is there something that needs to be set to match the standard between
> > input and encoder?
>
> I suspect I know what is wrong. After loading the driver
> run 'v4l2-ctl -s ntsc-m' and see if the capture now works. Ignore the
> standard as reported by video2: it's bogus and is unused.
>
> What I believe is happening is that the saa6752 is never told that the
> standard is NTSC when it is loaded the first time. But if you set it
> explicitly afterwards, then it probably works.
>
> Let me know what happens. If it is indeed a bug then I'll fix it.

I set the standard as above as well as just "ntsc" on another attempt,
but the the capture is still PAL size.

{{{
$ v4l2-ctl -s ntsc-m --device /dev/video0
Standard set to 00001000
}}}

>
> Regards,
>
>        Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
