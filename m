Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBG82Abw004768
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 03:02:10 -0500
Received: from mail-bw0-f20.google.com (mail-bw0-f20.google.com
	[209.85.218.20])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBG81qWf016383
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 03:01:52 -0500
Received: by bwz13 with SMTP id 13so10167861bwz.3
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 00:01:52 -0800 (PST)
Message-ID: <d9def9db0812160001x49f2a8c7udb11f35f6e1a27c9@mail.gmail.com>
Date: Tue, 16 Dec 2008 09:01:51 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "=?ISO-8859-1?Q?N=E9meth_M=E1rton?=" <nm127@freemail.hu>
In-Reply-To: <49475516.3090504@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <49475516.3090504@freemail.hu>
Content-Transfer-Encoding: 8bit
Cc: em28xx@mcentral.de, video4linux-list@redhat.com,
	LKML <linux-kernel@vger.kernel.org>, mschimek@gmx.at
Subject: Re: [Em28xx] parameter of VIDIOC_G_INPUT and VIDIOC_S_INPUT?
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

Hi,

2008/12/16 Németh Márton <nm127@freemail.hu>:
> Hi,
>
> I have a question about the parameter of VIDIOC_G_INPUT and VIDIOC_S_INPUT
> parameters in v4l2 specification.
>
> The "Video for Linux Two API Specification" text says that the
> parameter of VIDIOC_G_INPUT and VIDIOC_S_INPUT is ...
>
>> [...] a pointer to an integer where the driver stores the number
>> of the input, as in the struct v4l2_input index field.
>>
>> http://v4l2spec.bytesex.org/spec/r11217.htm
>
> In the v4l2_input structure the index has the type of __u32.
>
> In contrast, in <linux/videodev2.h> (as of 2.6.27) the ioctls are defined
> as follows:
>
>> #define VIDIOC_G_INPUT                _IOR('V', 38, int)
>> #define VIDIOC_S_INPUT                _IOWR('V', 39, int)
>
> The problem is that '__u32' is unsigned and 'int' is signed. Furthermore
> one cannot be sure that sizeof(__u32) == sizeof(int) on all platforms.
>
> I guess that the parameter of VIDIOC_G_INPUT and VIDIOC_S_INPUT should be
> a pointer to __u32. What do you think?
>

seems to be sane yes. This ioctl is also handled in compat_ioctl32.c and might
also get some attention there.

Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
