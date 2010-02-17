Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:47011 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757925Ab0BQX7d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2010 18:59:33 -0500
Received: by fxm20 with SMTP id 20so8303118fxm.21
        for <linux-media@vger.kernel.org>; Wed, 17 Feb 2010 15:59:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B7C80F5.5060405@redhat.com>
References: <4B3F6FE0.4040307@internode.on.net> <4B3F7B0D.4030601@mailbox.hu>
	 <4B405381.9090407@internode.on.net> <4B421BCB.6050909@mailbox.hu>
	 <4B4294FE.8000309@internode.on.net> <4B463AC6.2000901@mailbox.hu>
	 <4B719CD0.6060804@mailbox.hu> <4B745781.2020408@mailbox.hu>
	 <4B7C303B.2040807@mailbox.hu> <4B7C80F5.5060405@redhat.com>
Date: Wed, 17 Feb 2010 18:59:30 -0500
Message-ID: <829197381002171559k10b692dcu99a3adc2f613437f@mail.gmail.com>
Subject: Re: [PATCH] DTV2000 H Plus issues
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 17, 2010 at 6:51 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Hi Istvan,
>
> istvan_v@mailbox.hu wrote:
>> The attached new patches contain all the previous changes merged, and
>> are against the latest v4l-dvb revision.
>
> Please provide your Signed-off-by. This is a basic requirement for your
> driver to be accepted. Please read:
>        http://linuxtv.org/hg/v4l-dvb/raw-file/tip/README.patches
>
> for instructions on how to submit a patch.

Hi Mauro,

I would hate to come across as a jerk here, but he cannot provide his
SOB for this patch, as I wrote about 95% of the code here.  It's
derived from a tree I have been working on for the PCTV 340e:

http://kernellabs.com/hg/~dheitmueller/pctv-340e-2/

I know that istvan wants to see the support merged, but he is going to
have to wait a bit longer since he is not the author or maintainer of
the driver in question.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
