Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBM2TSuT014560
	for <video4linux-list@redhat.com>; Sun, 21 Dec 2008 21:29:28 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBM2TF1r012685
	for <video4linux-list@redhat.com>; Sun, 21 Dec 2008 21:29:15 -0500
Received: by wf-out-1314.google.com with SMTP id 25so1836171wfc.6
	for <video4linux-list@redhat.com>; Sun, 21 Dec 2008 18:29:15 -0800 (PST)
Message-ID: <aec7e5c30812211829t2b1b6dffvbc17f095ee24153b@mail.gmail.com>
Date: Mon, 22 Dec 2008 11:29:15 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0812191403540.4536@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0812171938460.8733@axis700.grange>
	<aec7e5c30812190426ja9252a6k95b626c2ce87a909@mail.gmail.com>
	<Pine.LNX.4.64.0812191403540.4536@axis700.grange>
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 3/4] soc-camera: add new bus width and signal polarity
	flags
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

Hi Guennadi,

[updated version, flags only]

On Fri, Dec 19, 2008 at 10:07 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> From 1d89b241f4553a5ceb5b6fd9870f02324cc281fe Mon Sep 17 00:00:00 2001
> From: Guennadi Liakhovetski <lg@denx.de>
> Date: Mon, 15 Dec 2008 00:49:41 +0100
> Subject: [PATCH] soc-camera: add new bus width and signal polarity flags
>
> In preparation for i.MX31 camera host driver add flags for 4 and 15 bit bus
> widths and for data lines polarity inversion.
>
> Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
> ---
>  include/media/soc_camera.h |   23 ++++++++++++++---------
>  1 files changed, 14 insertions(+), 9 deletions(-)

This version solves the problem. Thanks for your help!

Acked-by: Magnus Damm <damm@igel.co.jp>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
