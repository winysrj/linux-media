Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBGDpGGG014627
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 08:51:16 -0500
Received: from smtp-vbr10.xs4all.nl (smtp-vbr10.xs4all.nl [194.109.24.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBGDoxOk002513
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 08:51:00 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Markus Rechberger" <mrechberger@gmail.com>
Date: Tue, 16 Dec 2008 14:50:56 +0100
References: <200812161332.52475.hverkuil@xs4all.nl>
	<d9def9db0812160515h4c96a009w1226ca2fb3c64a9a@mail.gmail.com>
In-Reply-To: <d9def9db0812160515h4c96a009w1226ca2fb3c64a9a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812161450.56695.hverkuil@xs4all.nl>
Cc: v4l <video4linux-list@redhat.com>, Michael Schimek <mschimek@gmx.at>
Subject: Re: V4L2 spec typo for V4L2_PIX_FMT_BGR32 format?
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

On Tuesday 16 December 2008 14:15:18 Markus Rechberger wrote:
> On Tue, Dec 16, 2008 at 1:32 PM, Hans Verkuil <hverkuil@xs4all.nl> 
wrote:
> > Hi,
> >
> > The v4l2 spec says this
> > (http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec-sin
> >gle/v4l2.html#PIXFMT-RGB):
> >
> > V4L2_PIX_FMT_BGR32  'BGR4'
> >   b7b6b5b4b3b2b1b0 g7g6g5g4g3g2g1g0 r7r6r5r4r3r2r1r0
> > a7a6a5a4a3a2a1a0 V4L2_PIX_FMT_RGB32  'RGB4'
> >   r7r6r5r4r3r2r1r0 g7g6g5g4g3g2g1g0 b7b6b5b4b3b2b1b0
> > a7a6a5a4a3a2a1a0
> >
> > But I'm pretty sure this should be:
> >
> > V4L2_PIX_FMT_BGR32  'BGR4'
> >   a7a6a5a4a3a2a1a0 b7b6b5b4b3b2b1b0 g7g6g5g4g3g2g1g0
> > r7r6r5r4r3r2r1r0 V4L2_PIX_FMT_RGB32  'RGB4'
> >   r7r6r5r4r3r2r1r0 g7g6g5g4g3g2g1g0 b7b6b5b4b3b2b1b0
> > a7a6a5a4a3a2a1a0
> >
> > since the only difference should be endianess.
> >
> > Or am I mistaken?
>
> The openGL specs have BGRA defined..
> http://opengl.org/registry/specs/EXT/bgra.txt
>
> BGRA_EXT		Component	B, G, R, A		Color
>
> Markus

Hmm, so the spec conforms to the openGL spec, but in practice it is used 
as a swapped version of RGB4. What a mess.

Thanks,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
