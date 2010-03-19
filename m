Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:42120 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab0CSPto (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Mar 2010 11:49:44 -0400
Received: by fxm19 with SMTP id 19so731970fxm.21
        for <linux-media@vger.kernel.org>; Fri, 19 Mar 2010 08:49:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BA38088.1020006@redhat.com>
References: <83e56201383c6a99ea51dafcd2794dfe.squirrel@webmail.xs4all.nl>
	 <201003190904.53867.laurent.pinchart@ideasonboard.com>
	 <50cd74a798bbf96501cd40b90d2a2b93.squirrel@webmail.xs4all.nl>
	 <4BA38088.1020006@redhat.com>
Date: Fri, 19 Mar 2010 11:49:42 -0400
Message-ID: <30353c3d1003190849v35b57dcai9ab11ff1362b4f46@mail.gmail.com>
Subject: Re: RFC: Drop V4L1 support in V4L2 drivers
From: David Ellingsworth <david@identd.dyndns.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	v4l-dvb <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 19, 2010 at 9:47 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> The V4L1 drivers that lasts are the ones without maintainers and probably without
> a large users base. So, basically legacy hardware. So, their removals make sense.
>

In many ways the above statement is a catch 22. Most, if not all the
v4l1 drivers are currently broken or unmaintained. However, this does
not mean there are users who would not be using these drivers if they
actually worked or had been properly maintained. I know this to be a
fact of the ibmcam driver. It is both broken and unmaintained. Because
of this I'm sure no one is currently using it. I happen to have a USB
camera which is supposedly supported by the ibmcam driver.
Unfortunately, I have not the time nor expertise needed to
update/fix/replace this driver, though I have previously tried. If
someone on this list is willing to collaborate with me to make a
functional v4l2 driver to replace the existing ibmcam driver, I'd be
more than willing to expend more time and energy in doing so.
Hopefully someday I'll actually be able to use the camera that I own,
considering as is it barely works under Windows.

Regards,

David Ellingsworth
