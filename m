Return-path: <linux-media-owner@vger.kernel.org>
Received: from yop.chewa.net ([91.121.105.214]:47966 "EHLO yop.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753806Ab2ARMkC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jan 2012 07:40:02 -0500
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: v4l-utils migrated to autotools
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 18 Jan 2012 13:31:01 +0100
From: =?UTF-8?Q?R=C3=A9mi_Denis-Courmont?= <remi@remlab.net>
Cc: Gregor Jasny <gjasny@googlemail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <4F16B8CC.3010503@redhat.com>
References: <4F134701.9000105@googlemail.com> <4F16B8CC.3010503@redhat.com>
Message-ID: <2648c3dfc9ea2bd3bae776200d7e056e@chewa.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 18 Jan 2012 10:19:24 -0200, Mauro Carvalho Chehab

<mchehab@redhat.com> wrote:

> Not sure if it is possible, but it would be great if the build output

> would be less verbose. libtool adds a lot of additional (generally

useless)

> messages, with makes harder to see the compilation warnings in the

> middle of all those garbage.



These days, automake has a silent mode that looks much like a kernel

compilation.



-- 

Rémi Denis-Courmont

http://www.remlab.net/
