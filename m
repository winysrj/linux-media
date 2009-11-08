Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:61040 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbZKHJ41 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Nov 2009 04:56:27 -0500
Message-ID: <4AF695CC.7040809@freemail.hu>
Date: Sun, 08 Nov 2009 10:56:28 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Jean-Francois Moine <moinejf@free.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: pac7302: INFO: possible circular locking dependency detected
References: <4AF48F80.4000809@freemail.hu> <4AF68BC6.4040801@redhat.com>
In-Reply-To: <4AF68BC6.4040801@redhat.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Hans de Goede wrote:
> [snip]
> 
> About the usb control msg errors, I don't think they are related to this issue at all, no real
> world app ever does a streamon and an mmap at the same time. As said if we could serialize mmap and
> ioctl at a high enough level, things would be fine too.

I am using http://moinejf.free.fr/svv.c . In the start_capturing() function it calls the
VIDIOC_STREAMON ioctl in case of memory mapped mode. Is this wrong? Or do you mean under
"at the same time" that VIDIOC_STREAMON and mmap() is called from different tasks/threads?

Regards,

	Márton Németh
