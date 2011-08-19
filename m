Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:61756 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab1HSSKO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Aug 2011 14:10:14 -0400
Received: by pzk37 with SMTP id 37so5202308pzk.1
        for <linux-media@vger.kernel.org>; Fri, 19 Aug 2011 11:10:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <op.v0f8nfnjyxxkfz@localhost.localdomain>
References: <op.v0f8nfnjyxxkfz@localhost.localdomain>
Date: Fri, 19 Aug 2011 15:10:14 -0300
Message-ID: <CAOMZO5As9+Vds6ZixuJbZktswO8WejK+5m_VBpY=Rpqwhb4gpg@mail.gmail.com>
Subject: Re: image capturing on i.mx27 with gstreamer
From: Fabio Estevam <festevam@gmail.com>
To: Jan Pohanka <xhpohanka@gmail.com>
Cc: linux-media@vger.kernel.org, oselas@community.pengutronix.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jan,

On Fri, Aug 19, 2011 at 4:05 AM, Jan Pohanka <xhpohanka@gmail.com> wrote:
...
> However, there is also an issue with resolution. This works up to 640x480.
> For example for 800x600 i'm getting this error message
> WARNING: erroneous pipeline: could not link ffmpegcsp0 to mfwgstvpu_enc0

MX27 can decode/encode up to full D1 (720x576 or 720x480) resolution.

Regards,

Fabio Estevam
