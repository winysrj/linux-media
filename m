Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36953 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab0IRW5F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Sep 2010 18:57:05 -0400
Received: by fxm3 with SMTP id 3so138148fxm.19
        for <linux-media@vger.kernel.org>; Sat, 18 Sep 2010 15:57:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C938158.9020604@redhat.com>
References: <4C938158.9020604@redhat.com>
Date: Sat, 18 Sep 2010 18:57:04 -0400
Message-ID: <AANLkTinEXUcQ-iTucDArju+daudTgAHoBTCBdproK7se@mail.gmail.com>
Subject: Re: [PATCH -hg] Warn user that driver is backported and might not
 work as expected
From: David Ellingsworth <david@identd.dyndns.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Douglas Schilling Landgraf <dougsland@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

<snip>
> --- a/v4l/scripts/make_kconfig.pl       Sun Jun 27 17:17:06 2010 -0300
> +++ b/v4l/scripts/make_kconfig.pl       Fri Sep 17 11:49:02 2010 -0300
> @@ -671,4 +671,13 @@
>
>  EOF2
>        }
> +print << "EOF3";
> +WARNING: This is the V4L/DVB backport tree, with experimental drivers
> +        backported to run on legacy kernels from the development tree at:
> +               http://git.linuxtv.org/media-tree.git.
> +        It is generally safe to use it for testing a new driver or
> +        feature, but its usage on production environments is risky.
> +        Don't use it at production. You've being warned.

The last line should read: "Don't use it in production. You've been warned."

> +EOF3
> +       sleep 5;
>  }
> --

Regards,

David Ellingsworth
