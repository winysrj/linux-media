Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615Ab0CTXNP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Mar 2010 19:13:15 -0400
Message-ID: <4BA556D1.1090602@redhat.com>
Date: Sun, 21 Mar 2010 00:14:25 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: RFC: Phase 2/3: Move the compat code into v4l1-compat. Convert
 apps.
References: <201003201021.05426.hverkuil@xs4all.nl>
In-Reply-To: <201003201021.05426.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 03/20/2010 10:21 AM, Hans Verkuil wrote:
> Hi all!
>
> The second phase that needs to be done to remove the v4l1 support from the
> kernel is that libv4l1 should replace the v4l1-compat code from the kernel.
>
> I do not know how complete the libv4l1 code is right now. I would like to
> know in particular whether the VIDIOCGMBUF/mmap behavior can be faked in
> libv4l1 if drivers do not support the cgmbuf vidioc call.
>

Yes it can, this for example already happens when using v4l1 apps with
uvcvideo (which is not possible without libv4l1).

> The third phase that can be done in parallel is to convert V4L1-only apps.
> I strongly suspect that any apps that are V4L1-only are also unmaintained.
> We have discussed before that we should set up git repositories for such
> tools (xawtv being one of the more prominent apps since it contains several
> v4l1-only console apps). Once we have maintainership, then we can convert
> these tools to v4l2 and distros and other interested parties have a place
> to send patches to.
>

As said before I wouldn't mind maintaining an xawtv git tree @ linuxtv,
assuming this tree were to be based on the 3.95 release.

Regards,

Hans
