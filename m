Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:30620 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852AbZAXDUH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2009 22:20:07 -0500
MIME-Version: 1.0
In-Reply-To: <200901240503.35695.ionut.leonte@gmail.com>
References: <3f9a31f40901222126t5baf80f8t12513dc9fd9b3f29@mail.gmail.com>
	 <200901240503.35695.ionut.leonte@gmail.com>
Date: Sat, 24 Jan 2009 08:50:05 +0530
Message-ID: <3f9a31f40901231920s122eeddfw7c58d89431c97c43@mail.gmail.com>
Subject: Re: How can I fix errors and warnings in nvidia module for Tesla
	C1060
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Ionut Leonte <garglkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-nvidia@lists.surfsouth.com, adaplas@gmail.com,
	npaci-rocks-discussion@sdsc.edu, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jan 24, 2009 at 8:33 AM, Ionut Leonte <garglkml@gmail.com> wrote:
> According to the log you attached ("Kernel messages" section):
>
>   nvidia: module license 'NVIDIA' taints kernel.
>   NVRM: No NVIDIA graphics adapter found!
>
> Are you sure you're using the correct driver ?
>

Nvidia Tesla C1060 has no output, so I was using intel motherboard
garphics, when I disable intel motherboard graphics adapter
installation processes able to find nvidia graphics adapter and build
the nvidia module.

But now I got another problem I use various git kernels trees, so I
need to build these modules for each kernel tree. And seems nvidia is
not disclosing the source code for Nvidia Telsa Series module :-(

--
JSR
