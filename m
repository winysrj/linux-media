Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63016 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054Ab2F2QdR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jun 2012 12:33:17 -0400
Received: by dady13 with SMTP id y13so4590812dad.19
        for <linux-media@vger.kernel.org>; Fri, 29 Jun 2012 09:33:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FEDD41E.3000608@redhat.com>
References: <1340918440-17523-1-git-send-email-martin.blumenstingl@googlemail.com>
 <1340918440-17523-2-git-send-email-martin.blumenstingl@googlemail.com>
 <20461.26585.508583.521723@morden.metzler> <CAFBinCApTRMdut01wPqT08ViOW=++57UHBY2ok=k=EfQSaEVCQ@mail.gmail.com>
 <4FEDD41E.3000608@redhat.com>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Fri, 29 Jun 2012 18:32:57 +0200
Message-ID: <CAFBinCC5nRA=DKuegUu2cbcWzCtpDs-RgRuVKB=1FwDCzw8pNw@mail.gmail.com>
Subject: Re: [PATCH 1/2] [media] drxk: Make the QAM demodulator command configurable.
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Ralph Metzler <rjkm@metzlerbros.de>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> I didn't tell "old command", or at least not in the sense of old firmware. I told
> that the first drivers (ddbridge and mantis), based on drxk_ac3.mc firmware, use the
> 4-parameters variant, while the other drivers use the 2-parameters variant.
Oh sorry, I must have gotten that wrong.

> Anyway, using the name "old" for such parameter is not a good idea. IMHO, you
> should use something like qam_demod_needs_4_parameters for this config data,
> or, maybe "number_of_qam_demod_parameters".
Sounds good.

> If number_of_qam_demod_parameters is not 2 or 4, try both ways. So, a device driver
> that won't specify it will be auto-probed.
Ok, I'll keep the existing order:
- first try the 4-parameter one
- then try the 2-parameter one
And I'll update the variable then to make sure we're not doing that
trial-and-error thing
twice.

I'll also update all drxk_config instances where I'm sure that they're
using the (newer)
2-parameter method.

Thanks you two for you feedback!

Regards,
Martin
