Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:34840 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756406Ab2GJRFN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jul 2012 13:05:13 -0400
Received: by qadb17 with SMTP id b17so2545101qad.19
        for <linux-media@vger.kernel.org>; Tue, 10 Jul 2012 10:05:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FFC3109.3080204@mlbassoc.com>
References: <4FFC3109.3080204@mlbassoc.com>
Date: Tue, 10 Jul 2012 13:05:12 -0400
Message-ID: <CABMb9GtV_CZ=ZFoqXD_u3dmZQoD5CmsptYkgwwecO7Ch9v3AAw@mail.gmail.com>
Subject: Re: OMAP4 support
From: Chris Lalancette <clalancette@gmail.com>
To: Gary Thomas <gary@mlbassoc.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Discussion <linux-media@vger.kernel.org>,
	sergio.a.aguirre@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 10, 2012 at 9:41 AM, Gary Thomas <gary@mlbassoc.com> wrote:
> I'm looking for video support on OMAP4 platforms.  I've found the
> PandaBoard camera project
> (http://www.omappedia.org/wiki/PandaBoard_Camera_Support)
> and this is starting to work.  That said, I'm having some
> issues with setting up the pipeline, etc.
>
> Can this list help out?

I'm not sure exactly what kind of cameras you want to get working, but
if you are looking to get CSI2 cameras going through the ISS, Sergio
Aguirre has been working on support.  He also works on the media-ctl
tool, which is used for configuring the media framework pipeline.  The
latest versions that I am aware of are here:

git://gitorious.org/omap4-v4l2-camera/omap4-v4l2-camera.git

I've also added Sergio on the CC list.

Hope that helps,
Chris
