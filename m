Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBC9Ujr4026860
	for <video4linux-list@redhat.com>; Fri, 12 Dec 2008 04:30:45 -0500
Received: from mail-gx0-f15.google.com (mail-gx0-f15.google.com
	[209.85.217.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBC9UWUJ025877
	for <video4linux-list@redhat.com>; Fri, 12 Dec 2008 04:30:32 -0500
Received: by gxk8 with SMTP id 8so1635558gxk.3
	for <video4linux-list@redhat.com>; Fri, 12 Dec 2008 01:30:32 -0800 (PST)
Message-ID: <aec7e5c30812120130j6c488450t9ba3f25a5c0b6c13@mail.gmail.com>
Date: Fri, 12 Dec 2008 18:30:31 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Kuninori Morimoto" <morimoto.kuninori@renesas.com>
In-Reply-To: <u3agtx39i.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <u3agtx39i.wl%morimoto.kuninori@renesas.com>
Cc: V4L-Linux <video4linux-list@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH re-send v2] Add interlace support to
	sh_mobile_ceu_camera.c
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

[CEU interlace patch v2]

On Fri, Dec 12, 2008 at 4:09 PM, Kuninori Morimoto
<morimoto.kuninori@renesas.com> wrote:
>
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> ---

I've tested this briefly on top of my nv1x/nvx1 patches with an
unpatched Migo-R board. The code compiles, ov772x works well. The
ov772x chip is however not using interlace mode and my board is
lacking the FLD signal to the video decoder so it's difficult to test
interlace mode. I do however know that Morimoto-san tested this patch
together with the TW9910 driver, so I'm confident that it works as
expected.

Signed-off-by: Magnus Damm <damm@igel.co.jp>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
