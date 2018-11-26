Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f195.google.com ([209.85.219.195]:46648 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbeKZOUU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Nov 2018 09:20:20 -0500
Received: by mail-yb1-f195.google.com with SMTP id i17-v6so6900747ybp.13
        for <linux-media@vger.kernel.org>; Sun, 25 Nov 2018 19:27:36 -0800 (PST)
Received: from mail-yw1-f49.google.com (mail-yw1-f49.google.com. [209.85.161.49])
        by smtp.gmail.com with ESMTPSA id k185-v6sm13910415ywc.98.2018.11.25.19.27.33
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Nov 2018 19:27:34 -0800 (PST)
Received: by mail-yw1-f49.google.com with SMTP id t13so6961128ywe.13
        for <linux-media@vger.kernel.org>; Sun, 25 Nov 2018 19:27:33 -0800 (PST)
MIME-Version: 1.0
References: <20180814142047.93856-1-hverkuil@xs4all.nl> <20180814142047.93856-2-hverkuil@xs4all.nl>
 <alpine.DEB.2.21.1811121048400.14703@nanos.tec.linutronix.de>
 <20181118115215.5ebc681c@coco.lan> <20181123075157.077758c0@coco.lan>
 <alpine.DEB.2.21.1811231134100.2603@nanos.tec.linutronix.de> <20181123102908.2ec61ce4@coco.lan>
In-Reply-To: <20181123102908.2ec61ce4@coco.lan>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 26 Nov 2018 12:27:22 +0900
Message-ID: <CAAFQd5D7Qss_KrAXER4CTFfKQa-rtu1gZGh016=MKwiagZLuRw@mail.gmail.com>
Subject: Re: [PATCHv18 01/35] Documentation: v4l: document request API
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        kstewart@linuxfoundation.org, torvalds@linux-foundation.org,
        ben@decadent.org.uk
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 23, 2018 at 9:29 PM Mauro Carvalho Chehab
<mchehab@kernel.org> wrote:
>
> Em Fri, 23 Nov 2018 11:38:37 +0100 (CET)
> Thomas Gleixner <tglx@linutronix.de> escreveu:
>
> > Mauro,
> >
> > On Fri, 23 Nov 2018, Mauro Carvalho Chehab wrote:
> > > > While we don't have it, we can't really use SPDX identifiers on media.
> > > > So, replace them by a license text.
> > > >
> > > > Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> > > >
> > > > diff --git a/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst b/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst
> > > > index 0f8b31874002..60874a1f3d89 100644
> > > > --- a/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst
> > > > +++ b/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst
> > > > @@ -1,4 +1,15 @@
> > > > -.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-or-later WITH no-invariant-sections
> > > > +.. SPDX License for this file: GPL-2.0 OR GFDL-1.1-or-later
> > > > +..
> > > > +.. For GPL-2.0, see LICENSES/preferred/GPL-2.0
> > > > +..
> > > > +.. For GFDL-1.1-or-later, see:
> > > > +..
> > > > +.. Permission is granted to copy, distribute and/or modify this document
> > > > +.. under the terms of the GNU Free Documentation License, Version 1.1 or
> > > > +.. any later version published by the Free Software Foundation, with no
> > > > +.. Invariant Sections, no Front-Cover Texts and no Back-Cover Texts.
> > > > +.. A copy of the license is included at
> > > > +.. Documentation/media/uapi/fdl-appendix.rst.
> >
> > There is still an issue here.
> >
> > The SPDX id for GFDL requires the license text to be in LICENSES/....
> >
> > But the plain GFDL-1.1-or-later lacks the invariant/front/back parts which
> > are an exception to the license and require an exception ID along with the
> > corresponding file in LICENSES/..... again.
> >
> > So no, this won't cut it. Please stay with free form license information
> > until this is resolved.
>
> Ok, I'll use then the enclosed patch, replacing them by a free
> form license info, adding a TODO at the end, as a reminder.
>
> > Kate, can you have a look into that please on the SPDX side?
>
> Thanks,
> Mauro
>
> [PATCH] media: mediactl docs: Fix licensing message
>
> Right now, it mentions two SPDX headers that don't exist inside the Kernel:
>         GFDL-1.1-or-later
> And an exception:
>         no-invariant-sections
>
> While it would be trivial to add the first one, there's no way,
> currently, to distinguish, with SPDX, between a free and a non-free
> document under GFDL.
>
> Free documents with GFDL should not have invariant sections.
>
> There's an open issue at SPDX tree waiting for it to be solved.
> While we don't have this issue closed, let's just replace by a
> free-text license, and add a TODO note to remind us to revisit it
> later.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
>
> diff --git a/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst b/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst
> index 0f8b31874002..de131f00c249 100644
> --- a/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst
> +++ b/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst
> @@ -1,4 +1,28 @@
> -.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-or-later WITH no-invariant-sections
> +.. This file is dual-licensed: you can use it either under the terms
> +.. of the GPL or the GFDL 1.1+ license, at your option. Note that this
> +.. dual licensing only applies to this file, and not this project as a
> +.. whole.
> +..
> +.. a) This file is free software; you can redistribute it and/or
> +..    modify it under the terms of the GNU General Public License as
> +..    published by the Free Software Foundation; either version 2 of
> +..    the License, or (at your option) any later version.
> +..
> +..    This file is distributed in the hope that it will be useful,
> +..    but WITHOUT ANY WARRANTY; without even the implied warranty of
> +..    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +..    GNU General Public License for more details.
> +..
> +.. Or, alternatively,
> +..
> +.. b) Permission is granted to copy, distribute and/or modify this
> +..    document under the terms of the GNU Free Documentation License,
> +..    Version 1.1 or any later version published by the Free Software
> +..    Foundation, with no Invariant Sections, no Front-Cover Texts
> +..    and no Back-Cover Texts. A copy of the license is included at
> +..    Documentation/media/uapi/fdl-appendix.rst.
> +..
> +.. TODO: replace it to GPL-2.0 OR GFDL-1.1-or-later WITH no-invariant-sections
>
>  .. _media_ioc_request_alloc:
>
> diff --git a/Documentation/media/uapi/mediactl/media-request-ioc-queue.rst b/Documentation/media/uapi/mediactl/media-request-ioc-queue.rst
> index 6dd2d7fea714..5d2604345e19 100644
> --- a/Documentation/media/uapi/mediactl/media-request-ioc-queue.rst
> +++ b/Documentation/media/uapi/mediactl/media-request-ioc-queue.rst
> @@ -1,4 +1,28 @@
> -.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-or-later WITH no-invariant-sections
> +.. This file is dual-licensed: you can use it either under the terms
> +.. of the GPL or the GFDL 1.1+ license, at your option. Note that this
> +.. dual licensing only applies to this file, and not this project as a
> +.. whole.
> +..
> +.. a) This file is free software; you can redistribute it and/or
> +..    modify it under the terms of the GNU General Public License as
> +..    published by the Free Software Foundation; either version 2 of
> +..    the License, or (at your option) any later version.
> +..
> +..    This file is distributed in the hope that it will be useful,
> +..    but WITHOUT ANY WARRANTY; without even the implied warranty of
> +..    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +..    GNU General Public License for more details.
> +..
> +.. Or, alternatively,
> +..
> +.. b) Permission is granted to copy, distribute and/or modify this
> +..    document under the terms of the GNU Free Documentation License,
> +..    Version 1.1 or any later version published by the Free Software
> +..    Foundation, with no Invariant Sections, no Front-Cover Texts
> +..    and no Back-Cover Texts. A copy of the license is included at
> +..    Documentation/media/uapi/fdl-appendix.rst.
> +..
> +.. TODO: replace it to GPL-2.0 OR GFDL-1.1-or-later WITH no-invariant-sections
>
>  .. _media_request_ioc_queue:
>
> diff --git a/Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst b/Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst
> index febe888494c8..ec61960c81ce 100644
> --- a/Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst
> +++ b/Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst
> @@ -1,4 +1,28 @@
> -.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-or-later WITH no-invariant-sections
> +.. This file is dual-licensed: you can use it either under the terms
> +.. of the GPL or the GFDL 1.1+ license, at your option. Note that this
> +.. dual licensing only applies to this file, and not this project as a
> +.. whole.
> +..
> +.. a) This file is free software; you can redistribute it and/or
> +..    modify it under the terms of the GNU General Public License as
> +..    published by the Free Software Foundation; either version 2 of
> +..    the License, or (at your option) any later version.
> +..
> +..    This file is distributed in the hope that it will be useful,
> +..    but WITHOUT ANY WARRANTY; without even the implied warranty of
> +..    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +..    GNU General Public License for more details.
> +..
> +.. Or, alternatively,
> +..
> +.. b) Permission is granted to copy, distribute and/or modify this
> +..    document under the terms of the GNU Free Documentation License,
> +..    Version 1.1 or any later version published by the Free Software
> +..    Foundation, with no Invariant Sections, no Front-Cover Texts
> +..    and no Back-Cover Texts. A copy of the license is included at
> +..    Documentation/media/uapi/fdl-appendix.rst.
> +..
> +.. TODO: replace it to GPL-2.0 OR GFDL-1.1-or-later WITH no-invariant-sections
>
>  .. _media_request_ioc_reinit:
>
> diff --git a/Documentation/media/uapi/mediactl/request-api.rst b/Documentation/media/uapi/mediactl/request-api.rst
> index 5f4a23029c48..945113dcb218 100644
> --- a/Documentation/media/uapi/mediactl/request-api.rst
> +++ b/Documentation/media/uapi/mediactl/request-api.rst
> @@ -1,4 +1,28 @@
> -.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-or-later WITH no-invariant-sections
> +.. This file is dual-licensed: you can use it either under the terms
> +.. of the GPL or the GFDL 1.1+ license, at your option. Note that this
> +.. dual licensing only applies to this file, and not this project as a
> +.. whole.
> +..
> +.. a) This file is free software; you can redistribute it and/or
> +..    modify it under the terms of the GNU General Public License as
> +..    published by the Free Software Foundation; either version 2 of
> +..    the License, or (at your option) any later version.
> +..
> +..    This file is distributed in the hope that it will be useful,
> +..    but WITHOUT ANY WARRANTY; without even the implied warranty of
> +..    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +..    GNU General Public License for more details.
> +..
> +.. Or, alternatively,
> +..
> +.. b) Permission is granted to copy, distribute and/or modify this
> +..    document under the terms of the GNU Free Documentation License,
> +..    Version 1.1 or any later version published by the Free Software
> +..    Foundation, with no Invariant Sections, no Front-Cover Texts
> +..    and no Back-Cover Texts. A copy of the license is included at
> +..    Documentation/media/uapi/fdl-appendix.rst.
> +..
> +.. TODO: replace it to GPL-2.0 OR GFDL-1.1-or-later WITH no-invariant-sections
>
>  .. _media-request-api:
>
> diff --git a/Documentation/media/uapi/mediactl/request-func-close.rst b/Documentation/media/uapi/mediactl/request-func-close.rst
> index 098d7f2b9548..dcf3f35bcf17 100644
> --- a/Documentation/media/uapi/mediactl/request-func-close.rst
> +++ b/Documentation/media/uapi/mediactl/request-func-close.rst
> @@ -1,4 +1,28 @@
> -.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-or-later WITH no-invariant-sections
> +.. This file is dual-licensed: you can use it either under the terms
> +.. of the GPL or the GFDL 1.1+ license, at your option. Note that this
> +.. dual licensing only applies to this file, and not this project as a
> +.. whole.
> +..
> +.. a) This file is free software; you can redistribute it and/or
> +..    modify it under the terms of the GNU General Public License as
> +..    published by the Free Software Foundation; either version 2 of
> +..    the License, or (at your option) any later version.
> +..
> +..    This file is distributed in the hope that it will be useful,
> +..    but WITHOUT ANY WARRANTY; without even the implied warranty of
> +..    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +..    GNU General Public License for more details.
> +..
> +.. Or, alternatively,
> +..
> +.. b) Permission is granted to copy, distribute and/or modify this
> +..    document under the terms of the GNU Free Documentation License,
> +..    Version 1.1 or any later version published by the Free Software
> +..    Foundation, with no Invariant Sections, no Front-Cover Texts
> +..    and no Back-Cover Texts. A copy of the license is included at
> +..    Documentation/media/uapi/fdl-appendix.rst.
> +..
> +.. TODO: replace it to GPL-2.0 OR GFDL-1.1-or-later WITH no-invariant-sections
>
>  .. _request-func-close:
>
> diff --git a/Documentation/media/uapi/mediactl/request-func-ioctl.rst b/Documentation/media/uapi/mediactl/request-func-ioctl.rst
> index ff7b072a6999..11a22f887843 100644
> --- a/Documentation/media/uapi/mediactl/request-func-ioctl.rst
> +++ b/Documentation/media/uapi/mediactl/request-func-ioctl.rst
> @@ -1,4 +1,28 @@
> -.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-or-later WITH no-invariant-sections
> +.. This file is dual-licensed: you can use it either under the terms
> +.. of the GPL or the GFDL 1.1+ license, at your option. Note that this
> +.. dual licensing only applies to this file, and not this project as a
> +.. whole.
> +..
> +.. a) This file is free software; you can redistribute it and/or
> +..    modify it under the terms of the GNU General Public License as
> +..    published by the Free Software Foundation; either version 2 of
> +..    the License, or (at your option) any later version.
> +..
> +..    This file is distributed in the hope that it will be useful,
> +..    but WITHOUT ANY WARRANTY; without even the implied warranty of
> +..    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +..    GNU General Public License for more details.
> +..
> +.. Or, alternatively,
> +..
> +.. b) Permission is granted to copy, distribute and/or modify this
> +..    document under the terms of the GNU Free Documentation License,
> +..    Version 1.1 or any later version published by the Free Software
> +..    Foundation, with no Invariant Sections, no Front-Cover Texts
> +..    and no Back-Cover Texts. A copy of the license is included at
> +..    Documentation/media/uapi/fdl-appendix.rst.
> +..
> +.. TODO: replace it to GPL-2.0 OR GFDL-1.1-or-later WITH no-invariant-sections
>
>  .. _request-func-ioctl:
>
> diff --git a/Documentation/media/uapi/mediactl/request-func-poll.rst b/Documentation/media/uapi/mediactl/request-func-poll.rst
> index 85191254f381..2609fd54d519 100644
> --- a/Documentation/media/uapi/mediactl/request-func-poll.rst
> +++ b/Documentation/media/uapi/mediactl/request-func-poll.rst
> @@ -1,4 +1,28 @@
> -.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-or-later WITH no-invariant-sections
> +.. This file is dual-licensed: you can use it either under the terms
> +.. of the GPL or the GFDL 1.1+ license, at your option. Note that this
> +.. dual licensing only applies to this file, and not this project as a
> +.. whole.
> +..
> +.. a) This file is free software; you can redistribute it and/or
> +..    modify it under the terms of the GNU General Public License as
> +..    published by the Free Software Foundation; either version 2 of
> +..    the License, or (at your option) any later version.
> +..
> +..    This file is distributed in the hope that it will be useful,
> +..    but WITHOUT ANY WARRANTY; without even the implied warranty of
> +..    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +..    GNU General Public License for more details.
> +..
> +.. Or, alternatively,
> +..
> +.. b) Permission is granted to copy, distribute and/or modify this
> +..    document under the terms of the GNU Free Documentation License,
> +..    Version 1.1 or any later version published by the Free Software
> +..    Foundation, with no Invariant Sections, no Front-Cover Texts
> +..    and no Back-Cover Texts. A copy of the license is included at
> +..    Documentation/media/uapi/fdl-appendix.rst.
> +..
> +.. TODO: replace it to GPL-2.0 OR GFDL-1.1-or-later WITH no-invariant-sections
>
>  .. _request-func-poll:
>
>
>

Verified with a grep over Documentation/media that this patch replaces
all the instances of "GFDL-1.1-or-later WITH" and so:

Reviewed-by: Tomasz Figa <tfiga@chromium.org>

Best regards,
Tomasz
