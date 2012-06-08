Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:42621 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933473Ab2FHUYi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jun 2012 16:24:38 -0400
Received: by vcbf11 with SMTP id f11so1232733vcb.19
        for <linux-media@vger.kernel.org>; Fri, 08 Jun 2012 13:24:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FD0EA64.5020602@gmail.com>
References: <4FD06C91.6020507@gmail.com> <CACSP8SjyhBsCf7hnyO3AGnNge967jWHpkyfDyrEmkgdnp60_iA@mail.gmail.com>
 <4FD0EA64.5020602@gmail.com>
From: Erik Gilling <konkers@android.com>
Date: Fri, 8 Jun 2012 13:24:16 -0700
Message-ID: <CACSP8SgzyaX_3Xy18mhsK9A_3KAeJEv1YCcXyCm0j=FgkKb-vA@mail.gmail.com>
Subject: Re: Synchronization framework
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 7, 2012 at 10:52 AM, Maarten Lankhorst
<m.b.lankhorst@gmail.com> wrote:
> I do agree you need some way to synch userspace though, but I
> think adding a new api for userspace is not the way to go.

I'm not sure I understand how you propose to expose the functionality
to userspace in a way that does not depend on the driver that "owns"
the buffer w/o adding an API.

-Erik
