Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41254 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230AbZC0QRh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 12:17:37 -0400
Date: Fri, 27 Mar 2009 13:17:29 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: =?ISO-8859-1?B?TultZXRoIE3hcnRvbg==?= <nm127@freemail.hu>
Cc: linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] v4l2: fill reserved fields of VIDIOC_ENUMAUDIO also
Message-ID: <20090327131729.0842bdec@pedra.chehab.org>
In-Reply-To: <49CA611B.5050902@freemail.hu>
References: <49CA611B.5050902@freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 25 Mar 2009 17:51:39 +0100
Németh Márton <nm127@freemail.hu> wrote:

> From: Márton Németh <nm127@freemail.hu>
> 
> When enumerating audio inputs with VIDIOC_ENUMAUDIO the gspca_sunplus driver
> does not fill the reserved fields of the struct v4l2_audio with zeros as
> required by V4L2 API revision 0.24 [1]. Add the missing initializations to
> the V4L2 framework.
> 
> The patch was tested with v4l-test 0.10 [2] with gspca_sunplus driver and
> with Trust 610 LCD POWERC@M ZOOM webcam.

It didn't apply against the development tree. Anyway, a recent patch removed
the need of memset there. the memory fill with zero now happens at the same
code we copy the structure values.

Cheers,
Mauro
