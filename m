Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36966 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab0EGNPF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 May 2010 09:15:05 -0400
Received: by fxm10 with SMTP id 10so766398fxm.19
        for <linux-media@vger.kernel.org>; Fri, 07 May 2010 06:15:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100507093916.2e2ef8e3@pedra>
References: <20100507093916.2e2ef8e3@pedra>
Date: Fri, 7 May 2010 17:15:03 +0400
Message-ID: <q2p1a297b361005070615i310a285al522475ec6405b53@mail.gmail.com>
Subject: Re: Status of the patches under review (85 patches) and some misc
	notes about the devel procedures
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 7, 2010 at 4:39 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Hi,
>

>
> This is the summary of the patches that are currently under review.
> Each patch is represented by its submission date, the subject (up to 70
> chars) and the patchwork link (if submitted via email).
>

>                == Port mantis IR to the new API - waiting for Manu Abraham <abraham.manu@gmail.com> ack or alternative patch ==
>
> Apr,15 2010: [5/8] ir-core: convert mantis from ir-functions.c


This needs to wait for an alternate patch, which depends on
linuxtv.org/hg/v4l-dvb proper build
