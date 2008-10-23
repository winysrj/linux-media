Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9N3QOap003043
	for <video4linux-list@redhat.com>; Wed, 22 Oct 2008 23:26:24 -0400
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9N3QECk031001
	for <video4linux-list@redhat.com>; Wed, 22 Oct 2008 23:26:14 -0400
Received: by yw-out-2324.google.com with SMTP id 5so26849ywb.81
	for <video4linux-list@redhat.com>; Wed, 22 Oct 2008 20:26:14 -0700 (PDT)
Message-ID: <aec7e5c30810222026g4622aafcrf70cde31bcb0c602@mail.gmail.com>
Date: Thu, 23 Oct 2008 12:26:13 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Kuninori Morimoto" <morimoto.kuninori@renesas.com>
In-Reply-To: <uhc77mucm.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <uhc77mucm.wl%morimoto.kuninori@renesas.com>
Cc: khali@linux-fr.org, V4L <video4linux-list@redhat.com>, i2c@lm-sensors.org,
	mchehab@infradead.org
Subject: Re: [i2c] [PATCH v7] Add ov772x driver
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

On Mon, Oct 20, 2008 at 7:09 PM, Kuninori Morimoto
<morimoto.kuninori@renesas.com> wrote:
> This patch adds ov772x driver that use soc_camera framework.
> It was tested on SH Migo-r board.
>
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> ---
> PATCH v6 -> v7

This works just fine on my Migo-R board as well. Much better than my
old soc_camera_platform hack.

Acked-by: Magnus Damm <damm@igel.co.jp>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
