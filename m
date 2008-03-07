Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m27K5mAf013024
	for <video4linux-list@redhat.com>; Fri, 7 Mar 2008 15:05:48 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m27K5Fid024910
	for <video4linux-list@redhat.com>; Fri, 7 Mar 2008 15:05:16 -0500
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Keith Mok <ek9852@gmail.com>
Date: Fri, 7 Mar 2008 21:05:06 +0100
References: <47C14336.9030903@gmail.com> <20080304104706.38666b7d@gaivota>
	<47D11BC9.2060307@gmail.com>
In-Reply-To: <47D11BC9.2060307@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803072105.08054.tobias.lorenz@gmx.net>
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [v4l-dvb-maintainer] [PATCH] v4l2: add hardware frequency seek
	ioctl interface
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

Hi Keith,

I fully agree, that having something different then an ioctl to control the seek behavior is not the right way.

> For the usage of hardware frequency seek (struct v4l2_hw_freq_seek), it 
> is as follows:
> tuner, type and start_freq have the same meaning as the fields in 
> v4l2_frequency.
> wrap_around means the search will wrap around or stop if seek reach 
> maximum/minimum limit.
> seek_upward = 1 means seek frequency upward 0 means seek frequency downward.

That sounds, like there's already a proposal.
Can you provide me with the current patches and documentation?
They don't seem to be part of the V4L2 documentation, the mercurial V4L or the Linux git repository yet.

> Any suggestions or improvement recommendations ?

The answer to that question depends on what's already planned or probably already implemented.

As said, the SI470x has several options to change the seek behavior:
> RSSI Seek Threshold (range: 0..254, 254=highest threshold) -
> Signal-Noise-Ratio (range: 0..15, 15=highest SNR ratio) - FM-Impulse
> Noise Detection Counter (range: 0..15, 15=best audio quality)

I would implement these features as recommended by Mauro using VIDIOC_[G/S/ENUM]_CTRL.
Especially I need some additional V4L2_CID_* for it.
When named corresponding to the register names, they would look like this:
#define V4L2_CID_SEEKTH (V4L2_CID_BASE+24) /* RSSI Seek Threshold */
#define V4L2_CID_SKSNR (V4L2_CID_BASE+25) /* Seek SNR Threshold */
#define V4L2_CID_SKCNT (V4L2_CID_BASE+26) /* Seek FM Impulse Detection Threshold */

The implementation is then rather simple and will provide proper default settings for these registers.
I guess, the patch has less then 50 code lines.

More problematic is to patch one of the radio applications to test the new seek behavior.

Another question: If we implement a dedicated ioctl for seek operations,
will we also implement a compatibility function, that can be used for all devices,
that doesn't have hardware seek functionality?
I mean, a radio application should be able to just call the seek ioctl, independent of whether the hardware supports it or not.
If a specific version is available to support the device's hardware seek functionality, then that's fine and we use it.
If the hardware doesn't support seek operations, then we have the compatibility function,
that executes the usual "tune and check for signal strength" operation, as currently done in every application.
So we basically should move the functionality from the application to the kernel.

Bye,
  Toby

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
