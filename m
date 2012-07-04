Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753370Ab2GDJRl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jul 2012 05:17:41 -0400
Message-ID: <4FF40A55.7080205@redhat.com>
Date: Wed, 04 Jul 2012 11:18:13 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	halli manjunatha <hallimanju@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 1/6] videodev2.h: add VIDIOC_ENUM_FREQ_BANDS.
References: <1341238512-17504-1-git-send-email-hverkuil@xs4all.nl> <201207031847.38946.hverkuil@xs4all.nl> <4FF357AA.2020109@redhat.com> <201207041035.43469.hverkuil@xs4all.nl>
In-Reply-To: <201207041035.43469.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 07/04/2012 10:35 AM, Hans Verkuil wrote:

<snip snip>

> Can we have a (hopefully short) irc discussion today? I'd really like to get this API
> finalized.

+1, I'm available the entire day (CET office hours + evening if needed that is)

<snip snip>

> So my current proposal is: use a bitfield in v4l2_frequency_band to describe possible
> (de)modulators and add compat code to the v4l2-ioctl.c to automatically create a
> vidioc_enum_freq_bands op if no such op was supplied, using the data from g_tuner or
> g_modulator and which device node was used to fill in the fields.

+1

Regards,

The other Hans :)
