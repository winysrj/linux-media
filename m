Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:36495 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbbEETWk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 May 2015 15:22:40 -0400
Received: by wgiu9 with SMTP id u9so31179787wgi.3
        for <linux-media@vger.kernel.org>; Tue, 05 May 2015 12:22:39 -0700 (PDT)
Message-ID: <5549187D.6090708@googlemail.com>
Date: Tue, 05 May 2015 21:22:37 +0200
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Felix Janda <felix.janda@posteo.de>,
	Hans Petter Selasky <hselasky@freebsd.org>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/4] Wrap LFS64 functions only if __GLIBC__
References: <20150125203636.GC11999@euler> <20150505093402.4c29d565@recife.lan>
In-Reply-To: <20150505093402.4c29d565@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/05/15 14:34, Mauro Carvalho Chehab wrote:
> Em Sun, 25 Jan 2015 21:36:36 +0100
> Felix Janda <felix.janda@posteo.de> escreveu:
>> -#ifdef linux
>> +#ifdef __GLIBC__
> 
> Hmm... linux was added here to avoid breaking on FreeBSD, on this
> changeset:
> 
> So, either we should get an ack from Hans Peter, or you should
> change the tests to:
> 
> 	#if linux && __GLIBC__

That would be needed to not break Debian/kFreeBSD which is a FreeBSD
Kernel with GNU C library.
