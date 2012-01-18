Return-path: <linux-media-owner@vger.kernel.org>
Received: from yop.chewa.net ([91.121.105.214]:42716 "EHLO yop.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757397Ab2ARNC7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jan 2012 08:02:59 -0500
To: Patrick Boettcher <pboettcher@kernellabs.com>
Subject: Re: v4l-utils migrated to autotools
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 18 Jan 2012 14:02:58 +0100
From: =?UTF-8?Q?R=C3=A9mi_Denis-Courmont?= <remi@remlab.net>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Gregor Jasny <gjasny@googlemail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <201201181344.09700.pboettcher@kernellabs.com>
References: <4F134701.9000105@googlemail.com> <4F16B8CC.3010503@redhat.com> <2648c3dfc9ea2bd3bae776200d7e056e@chewa.net> <201201181344.09700.pboettcher@kernellabs.com>
Message-ID: <c034d5bf72c3a1d000ecfd279317275c@chewa.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 18 Jan 2012 13:44:09 +0100, Patrick Boettcher

<pboettcher@kernellabs.com> wrote:

> I love cmake and can't understand why people are not preferring it over 

> autotools for user-space applications and conditional+configurable 

> builds. 



In my experience, cmake sucks at cross-compilation. It is also rather

limited when it comes to compiling libraries, as opposed to libtool.



-- 

Rémi Denis-Courmont

http://www.remlab.net/
