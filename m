Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:62004 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab2ABIFm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jan 2012 03:05:42 -0500
Received: by wibhm6 with SMTP id hm6so8216579wib.19
        for <linux-media@vger.kernel.org>; Mon, 02 Jan 2012 00:05:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1112290934500.15735@axis700.grange>
References: <Pine.LNX.4.64.1112290934500.15735@axis700.grange>
Date: Mon, 2 Jan 2012 09:05:40 +0100
Message-ID: <CACKLOr2xNtmAXX66H3RxbJdw6_QD1hBMSuXy5AjtCPUU+_qKkg@mail.gmail.com>
Subject: Re: [PULL] soc-camera for 3.3
From: javier Martin <javier.martin@vista-silicon.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 29 December 2011 09:38, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> Hi Mauro
>
> Please pull a couple of soc-camera patches for 3.3. This is going to be a
> _much_ quieter pull, than the previous one:-) I didn't have time to
> continue the work on the soc-camera Media Controller conversion, so, that
> will have to wait at least until 3.4.
>
> Interestingly, Javier Martin has fixed field_count handling in mx2_camera,
> but, apparently, it also has to be fixed in other soc-camera drivers. So,
> a patch for that might follow later in the 3.3 cycle.
>
> The following changes since commit 1a5cd29631a6b75e49e6ad8a770ab9d69cda0fa2:
>
>  [media] tda10021: Add support for DVB-C Annex C (2011-12-20 14:01:08 -0200)
>
> are available in the git repository at:
>  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.3
>
> Guennadi Liakhovetski (4):
>      V4L: soc-camera: remove redundant parameter from the .set_bus_param() method
>      V4L: mt9m111: cleanly separate register contexts
>      V4L: mt9m111: power down most circuits when suspended
>      V4L: mt9m111: properly implement .s_crop and .s_fmt(), reset on STREAMON
>
> Javier Martin (2):
>      media i.MX27 camera: add support for YUV420 format.
>      media i.MX27 camera: Fix field_count handling.

So, you already applied my patch related to "field_count" handling. I
was preparing a v3 for that patch to fix the frame_count type issue
and to really provide frame loss detection but I can prepare it on top
of the old one if you want.

Regards.
