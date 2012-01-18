Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34496 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426Ab2ARMoO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jan 2012 07:44:14 -0500
Received: by wibhm6 with SMTP id hm6so2157523wib.19
        for <linux-media@vger.kernel.org>; Wed, 18 Jan 2012 04:44:13 -0800 (PST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: "=?utf-8?q?R=C3=A9mi?= Denis-Courmont" <remi@remlab.net>
Subject: Re: v4l-utils migrated to autotools
Date: Wed, 18 Jan 2012 13:44:09 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Gregor Jasny <gjasny@googlemail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4F134701.9000105@googlemail.com> <4F16B8CC.3010503@redhat.com> <2648c3dfc9ea2bd3bae776200d7e056e@chewa.net>
In-Reply-To: <2648c3dfc9ea2bd3bae776200d7e056e@chewa.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201201181344.09700.pboettcher@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 18 January 2012 13:31:01 Rémi Denis-Courmont wrote:
> On Wed, 18 Jan 2012 10:19:24 -0200, Mauro Carvalho Chehab
> 
> <mchehab@redhat.com> wrote:
> > Not sure if it is possible, but it would be great if the build
> > output would be less verbose. libtool adds a lot of additional
> > (generally
> 
> useless)
> 
> > messages, with makes harder to see the compilation warnings in the
> > middle of all those garbage.
> 
> These days, automake has a silent mode that looks much like a kernel
> compilation.

I missed the first message of this thread, that's why I hijacked it here 
and it is short:

I love cmake and can't understand why people are not preferring it over 
autotools for user-space applications and conditional+configurable 
builds. 

I hope my mail is not too off-topic.

regards,
--
Patrick Boettcher

Kernel Labs Inc.
http://www.kernellabs.com/
