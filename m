Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552Ab2ARLyu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jan 2012 06:54:50 -0500
Message-ID: <4F16B306.9070908@redhat.com>
Date: Wed, 18 Jan 2012 09:54:46 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?RGVuaWxzb24gRmlndWVpcmVkbyBkZSBTw6E=?=
	<denilsonsa@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Compile error at media_build
References: <CACGt9y=6nB-F+P08L-soBDVRe5K1Lry-jg-tdM21agjeYJt2fg@mail.gmail.com>
In-Reply-To: <CACGt9y=6nB-F+P08L-soBDVRe5K1Lry-jg-tdM21agjeYJt2fg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 18-01-2012 02:55, Denilson Figueiredo de Sá escreveu:
> I've tried to compile media_build in a 2.6.38 kernel. I got a compile
> error related to implicit declaration of 'kzalloc'.
> 
> The solution was to add #include <linux/slab.h> to this file:
> media_build/v4l/as3645a.c

Thanks for reporting it. Such patch was merged at the media-tree
today. It should be there for tomorrow's tarball.

Regards,
Mauro
