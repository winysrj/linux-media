Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f174.google.com ([209.85.128.174]:36303 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757822Ab3FLRqo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Jun 2013 13:46:44 -0400
Received: by mail-ve0-f174.google.com with SMTP id oz10so7007764veb.33
        for <linux-media@vger.kernel.org>; Wed, 12 Jun 2013 10:46:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1371049262-5799-2-git-send-email-hverkuil@xs4all.nl>
References: <1371049262-5799-1-git-send-email-hverkuil@xs4all.nl> <1371049262-5799-2-git-send-email-hverkuil@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 12 Jun 2013 23:16:23 +0530
Message-ID: <CA+V-a8sC29FLoP1r5ZW1SvANcfrjFNS4zwHbA4Ug0xcduC2r3g@mail.gmail.com>
Subject: Re: [REVIEWv2 PATCH 01/12] v4l2-device: check if already unregistered.
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mike Isely <isely@isely.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.  The patch looks OK expect for the small typo below in
the commit message.

On Wed, Jun 12, 2013 at 8:30 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> It was possible to unregister an already unregistered v4l2_device struct.
> Add a check whether that already happened and just return if that was
> the case.
>
> Also refure to register a v4l2_device if both the dev and name fields are

s/refure/refuse

Regards,
--Prabhakar Lad
