Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:32915 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163AbcGHT1t (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 15:27:49 -0400
Received: by mail-io0-f175.google.com with SMTP id t74so52070110ioi.0
        for <linux-media@vger.kernel.org>; Fri, 08 Jul 2016 12:27:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <071dedfead28ff4cd2d2faf56054ed1c46584ae1.1468004189.git.mchehab@s-opensource.com>
References: <071dedfead28ff4cd2d2faf56054ed1c46584ae1.1468004189.git.mchehab@s-opensource.com>
From: Javier Martinez Canillas <javier@dowhile0.org>
Date: Fri, 8 Jul 2016 15:27:48 -0400
Message-ID: <CABxcv=n+haxrF554eBkVcVQ4_M+uOPLpDeEZ6O+mruq4o=067A@mail.gmail.com>
Subject: Re: [PATCH] [media] doc-rst: mention the memory type to be set for
 all streaming I/O
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

On Fri, Jul 8, 2016 at 3:05 PM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> Changeset 8c9f46095176 ("[media] DocBook: mention the memory type to
> be set for all streaming I/O") updated the media DocBook to mention
> the need of filling the memory types. We need to keep the ReST
> doc updated to such change.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---

Patch looks good to me.

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
Javier
