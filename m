Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46841 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab2EMOSz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 May 2012 10:18:55 -0400
Received: by bkcji2 with SMTP id ji2so3189967bkc.19
        for <linux-media@vger.kernel.org>; Sun, 13 May 2012 07:18:53 -0700 (PDT)
Message-ID: <4FAFC2CA.7010306@googlemail.com>
Date: Sun, 13 May 2012 16:18:50 +0200
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Andr=E9_Roth?= <neolynx@gmail.com>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 1/6] libdvbv5 shared lib
References: <1336912143-25890-1-git-send-email-neolynx@gmail.com>
In-Reply-To: <1336912143-25890-1-git-send-email-neolynx@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I noticed the dvb library is partially licensed as GPL2 and partially
LGPL2.1+. Do you consider a re-licensing to LGPL2.1?

For better maintainability in distributions I'd also suggest to hide
non-public symbols like it's done for libv4l*.

Thanks,
Gregor
