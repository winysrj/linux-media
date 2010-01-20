Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:55513 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab0ATJyf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jan 2010 04:54:35 -0500
Received: by bwz19 with SMTP id 19so3655255bwz.28
        for <linux-media@vger.kernel.org>; Wed, 20 Jan 2010 01:54:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B56C078.8000502@redhat.com>
References: <4B55445A.10300@infradead.org>
	 <201001190853.11050.hverkuil@xs4all.nl>
	 <4B5592BF.8040201@infradead.org> <4B56C078.8000502@redhat.com>
Date: Wed, 20 Jan 2010 09:54:34 +0000
Message-ID: <59cf47a81001200154n57280719sce946e9553e8e06b@mail.gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories & libv4l
From: Paulo Assis <pj.assis@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>,
	Brandon Philips <brandon@ifup.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> The uvcdynctrl utility is part of the libwebcam project:
> http://www.quickcamteam.net/software/libwebcam
>
> But given that libwebcam is unmaintained and not used by anything AFAIK, I'm
> patching
> uvcdynctrl to no longer need it. The plan is to add uvcdynctrl to libv4l
> soon, as that
> is needed to be able to control the focus on some uvc autofocus cameras.

Actually libwebcam is still maintained in svn:

http://www.quickcamteam.net/documentation/how-to/how-to-install-the-webcam-tools

but you are right just a few applications use it, and since it's not
yet included in any distribution most end users will miss some advance
features on their webcams.
I'm just a bit worried that having two different packages providing
the same set of tools may cause some compatibility problems in the
future. Binary packages of libwebcam are being prepared and will be
available soon, so I guess some compat tests may be in order, maybe
splitting uvcdynctrl from libwebcam into a different package and
making it incompatible with libv4l would be a good idea.

Regards,
Paulo
