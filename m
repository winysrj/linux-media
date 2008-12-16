Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBGFEaZt005539
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 10:14:36 -0500
Received: from mail-bw0-f20.google.com (mail-bw0-f20.google.com
	[209.85.218.20])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBGFDNrn030894
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 10:13:24 -0500
Received: by bwz13 with SMTP id 13so10718987bwz.3
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 07:13:23 -0800 (PST)
Message-ID: <d9def9db0812160713n58d8a78cw5139f94a7bfd6530@mail.gmail.com>
Date: Tue, 16 Dec 2008 16:13:14 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
In-Reply-To: <200812161450.56695.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200812161332.52475.hverkuil@xs4all.nl>
	<d9def9db0812160515h4c96a009w1226ca2fb3c64a9a@mail.gmail.com>
	<200812161450.56695.hverkuil@xs4all.nl>
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

On Tue, Dec 16, 2008 at 2:50 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Tuesday 16 December 2008 14:15:18 Markus Rechberger wrote:
>> On Tue, Dec 16, 2008 at 1:32 PM, Hans Verkuil <hverkuil@xs4all.nl>
> wrote:
>> > Hi,
>> >
>> > The v4l2 spec says this
>> > (http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec-sin
>> >gle/v4l2.html#PIXFMT-RGB):
>> >
>> > V4L2_PIX_FMT_BGR32  'BGR4'
>> >   b7b6b5b4b3b2b1b0 g7g6g5g4g3g2g1g0 r7r6r5r4r3r2r1r0
>> > a7a6a5a4a3a2a1a0 V4L2_PIX_FMT_RGB32  'RGB4'
>> >   r7r6r5r4r3r2r1r0 g7g6g5g4g3g2g1g0 b7b6b5b4b3b2b1b0
>> > a7a6a5a4a3a2a1a0
>> >
>> > But I'm pretty sure this should be:
>> >
>> > V4L2_PIX_FMT_BGR32  'BGR4'
>> >   a7a6a5a4a3a2a1a0 b7b6b5b4b3b2b1b0 g7g6g5g4g3g2g1g0
>> > r7r6r5r4r3r2r1r0 V4L2_PIX_FMT_RGB32  'RGB4'
>> >   r7r6r5r4r3r2r1r0 g7g6g5g4g3g2g1g0 b7b6b5b4b3b2b1b0
>> > a7a6a5a4a3a2a1a0
>> >
>> > since the only difference should be endianess.
>> >
>> > Or am I mistaken?
>>
>> The openGL specs have BGRA defined..
>> http://opengl.org/registry/specs/EXT/bgra.txt
>>
>> BGRA_EXT              Component       B, G, R, A              Color
>>
>> Markus
>
> Hmm, so the spec conforms to the openGL spec, but in practice it is used
> as a swapped version of RGB4. What a mess.

well they have also defined ABGR
http://www.opengl.org/registry/specs/EXT/abgr.txt

BGR32 seems to be confusing somehow it can easily be interpreted as
both, whereas
ABGR doesn't seem to be defined with v4l2 for real. Both pixelformats
should be supported
of course.

Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
