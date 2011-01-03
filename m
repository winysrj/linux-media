Return-path: <mchehab@gaivota>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:45449 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab1ACTfm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jan 2011 14:35:42 -0500
Received: by yib18 with SMTP id 18so3168662yib.19
        for <linux-media@vger.kernel.org>; Mon, 03 Jan 2011 11:35:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <7e1e3d8066d44fb6b9e1caba57378a2efbe891c1.1294078230.git.hverkuil@xs4all.nl>
References: <6515cfbdde63364fd12bca1219870f38ff371145.1294078230.git.hverkuil@xs4all.nl>
	<1294079475-13259-1-git-send-email-hverkuil@xs4all.nl>
	<7e1e3d8066d44fb6b9e1caba57378a2efbe891c1.1294078230.git.hverkuil@xs4all.nl>
Date: Mon, 3 Jan 2011 14:35:41 -0500
Message-ID: <AANLkTiki207JrsiZxboKDNPjQ69rzWS=MhjTzJj3zL2R@mail.gmail.com>
Subject: Re: [RFCv2 PATCH 06/10] radio_ms800: use video_drvdata instead of filp->private_data
From: David Ellingsworth <david@identd.dyndns.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Why does this matter? From my understanding, v4l2_fh is meant to be
embed it in a device specific structure. If it is the first member in
the device specific structure, then the pointer to v4l2_fh is the same
as the one to the device specific structure. Otherwise, a simple
container_of can be used to calculate the appropriate address of the
container. In either case, the pointer calculation method is always
going to be faster than executing a call, and de-referencing multiple
pointers to retrieve the same information. filp->private data is there
for a reason, why not use it as intended and avoid the additional
overhead added by this patch?

Regards,

David Ellingsworth
