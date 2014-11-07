Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:57699 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaKGNZs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Nov 2014 08:25:48 -0500
Received: by mail-oi0-f44.google.com with SMTP id h136so2374022oig.3
        for <linux-media@vger.kernel.org>; Fri, 07 Nov 2014 05:25:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1415363697-32583-1-git-send-email-hverkuil@xs4all.nl>
References: <1415363697-32583-1-git-send-email-hverkuil@xs4all.nl>
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Fri, 7 Nov 2014 14:25:32 +0100
Message-ID: <CAL8zT=hEL5LP=Ug_8EZ_vT+=xmDc4ZUz7rPS6tdQDDf0zFXn2w@mail.gmail.com>
Subject: Re: [PATCH 0/3] adv: fix G/S_EDID behavior
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2014-11-07 13:34 GMT+01:00 Hans Verkuil <hverkuil@xs4all.nl>:
> This patch series fixes the adv7604, adv7842 and adv7511 G/S_EDID behavior.
> All three have been tested with v4l2-compliance and pass.
>
> Jean-Michel, I based the adv7604 patch on your patch, but I reworked it a bit.
> I hope you don't mind.

No problem for me, I applied your version and it works on my board.
Thanks,
JM
