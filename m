Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:33154 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163AbcGHT2V (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 15:28:21 -0400
Received: by mail-io0-f178.google.com with SMTP id t74so52081983ioi.0
        for <linux-media@vger.kernel.org>; Fri, 08 Jul 2016 12:28:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53ce523986cef185865a1c417269fcc5c48a1697.1468003247.git.mchehab@s-opensource.com>
References: <53ce523986cef185865a1c417269fcc5c48a1697.1468003247.git.mchehab@s-opensource.com>
From: Javier Martinez Canillas <javier@dowhile0.org>
Date: Fri, 8 Jul 2016 15:28:20 -0400
Message-ID: <CABxcv==WAaNbh6qCYZY3hODTFt9VxeHdUtSYsPQeHV+zsY0Twg@mail.gmail.com>
Subject: Re: [PATCH] [media] doc-rst: add dmabuf as streaming I/O in
 VIDIOC_REQBUFS description
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarit.de>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

On Fri, Jul 8, 2016 at 2:41 PM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> Commit 707e65831d3b("[media] DocBook: add dmabuf as streaming I/O
> in VIDIOC_REQBUFS description") added DMABUF to reqbufs description,
> but, as we're migrating to ReST markup, we need to keep it in sync
> with the change.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
Javier
