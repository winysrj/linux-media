Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:52413 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab2LQPP3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Dec 2012 10:15:29 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so4825762lag.19
        for <linux-media@vger.kernel.org>; Mon, 17 Dec 2012 07:15:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121011231154.22683.2502.stgit@zeus.hardeman.nu>
References: <20121011231154.22683.2502.stgit@zeus.hardeman.nu>
Date: Mon, 17 Dec 2012 15:15:27 +0000
Message-ID: <CAAG0J9_iK09DCTny=6nT7u1Hrf+jMfoJMsmJmiRiwkXdQvYBsw@mail.gmail.com>
Subject: Re: [PATCH] rc-core: add separate defines for protocol bitmaps and numbers
From: James Hogan <james.hogan@imgtec.com>
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12 October 2012 00:11, David Härdeman <david@hardeman.nu> wrote:
> The RC_TYPE_* defines are currently used both where a single protocol is
> expected and where a bitmap of protocols is expected. This patch tries
> to separate the two in preparation for the following patches.
>
> The intended use is also clearer to anyone reading the code. Where a
> single protocol is expected, enum rc_type is used, where one or more
> protocol(s) are expected, something like u64 is used.
>
> The patch has been rewritten so that the format of the sysfs "protocols"
> file is no longer altered (at the loss of some detail). The file itself
> should probably be deprecated in the future though.
>
> I missed some drivers when creating the last version of the patch because
> some weren't enabled in my .config. This patch passes an allmodyes build.
>
> Signed-off-by: David Härdeman <david@hardeman.nu>
> ---

> @@ -38,7 +70,7 @@ struct rc_map {
>         unsigned int            size;   /* Max number of entries */
>         unsigned int            len;    /* Used number of entries */
>         unsigned int            alloc;  /* Size of *scan in bytes */
> -       u64                     rc_type;
> +       enum rc_type            rc_type;
>         const char              *name;
>         spinlock_t              lock;
>  };

But store_protocols() sets dev->rc_map.rc_type to a bitmap. Am I
missing something?

Cheers
James
