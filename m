Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:33940 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752243Ab2GIVcJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Jul 2012 17:32:09 -0400
References: <CAOkj57_x0CoUTce5t7U-=2YdkjOQV-_tBFKRJj41rZNQrPU+Uw@mail.gmail.com>
In-Reply-To: <CAOkj57_x0CoUTce5t7U-=2YdkjOQV-_tBFKRJj41rZNQrPU+Uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: Linux equivalent of Windows VBIScope?
From: Andy Walls <awalls@md.metrocast.net>
Date: Mon, 09 Jul 2012 17:32:19 -0400
To: Tim Stowell <stowellt@gmail.com>, linux-media@vger.kernel.org
Message-ID: <9c03d233-e0dd-4754-a9c7-53be71ac959a@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tim Stowell <stowellt@gmail.com> wrote:

>Hi all,
>
>I am using the em28xx driver and have been able to extract captions
>using zvbi. I would like to visualize the waveform like the DirectShow
>VBIScope filter on windows (unfortunately the Windows driver doesn't
>expose any VBI pins). Does anyone know of anythings similar on Linux?
>Thanks
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

'osc' is a test utility that is part of the zvbi source distribution.  It probably does what you need.

Regards,
Andy
