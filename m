Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62329 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546Ab2IGN7X (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2012 09:59:23 -0400
Received: by iahk25 with SMTP id k25so3222015iah.19
        for <linux-media@vger.kernel.org>; Fri, 07 Sep 2012 06:59:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
Date: Fri, 7 Sep 2012 09:59:22 -0400
Message-ID: <CAGoCfiywx_Z=kzN3BHrw15d0MvM_24Teo1fEU42pMwm3wR53YA@mail.gmail.com>
Subject: Re: [RFCv2 API PATCH 00/28] Full series of API fixes from the 2012
 Media Workshop
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 7, 2012 at 9:29 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> I have also tested this patch series (actually a slightly older version)
> with em28xx. That driver needed a lot of changes to get it to pass the
> v4l2-compliance tests. Those can be found here:
>
> http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/em28xx

This is mostly informational, but problems found with the em28xx v4l
driver will likely also be in the au0828 (since when doing the analog
support for au0828 I derived large portions of the code from em28xx).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
