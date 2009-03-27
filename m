Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail12.sea5.speakeasy.net ([69.17.117.14]:37152 "EHLO
	mail12.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbZC0EHq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 00:07:46 -0400
Date: Thu, 26 Mar 2009 21:07:44 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Fw: [PATCH] cx88: Missing failure checks
In-Reply-To: <20090326220428.50523141@pedra.chehab.org>
Message-ID: <Pine.LNX.4.58.0903262055200.28292@shell2.speakeasy.net>
References: <20090326220428.50523141@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 26 Mar 2009, Mauro Carvalho Chehab wrote:
> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> To: linux-kernel@vger.kernel.org, mchehab@infradead.org
> Subject: [PATCH] cx88: Missing failure checks
>
> The ioremap one was reported in October 2007 (Bug 9146), the kmalloc one
> was blindingly obvious while looking at the ioremap one
>
> The bug suggests some other configuration for lots of I/O memory (32MB per
> device is ioremapped) but I'll leave that to the real maintainers

Each function has a 16 MB window and Linux can use three of the functions.

IIRC, all the function's register windows are the same so only one needs to
be mapped.
