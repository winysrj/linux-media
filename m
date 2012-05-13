Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57331 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab2EMOVS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 May 2012 10:21:18 -0400
Received: by bkcji2 with SMTP id ji2so3190632bkc.19
        for <linux-media@vger.kernel.org>; Sun, 13 May 2012 07:21:17 -0700 (PDT)
Message-ID: <4FAFC35A.1040008@googlemail.com>
Date: Sun, 13 May 2012 16:21:14 +0200
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Andr=E9_Roth?= <neolynx@gmail.com>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 5/8] added m4 directory to gitignore
References: <1336911450-23661-1-git-send-email-neolynx@gmail.com> <1336911450-23661-5-git-send-email-neolynx@gmail.com>
In-Reply-To: <1336911450-23661-5-git-send-email-neolynx@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 5/13/12 2:17 PM, André Roth wrote:
>  configure
> +m4
>  aclocal.m4
>  autom4te.cache
>  build-aux

The m4 directory also contains files that *are* under version control.
Changes to these files will be undetected if the directory is being ignored.

Maybe one can convince autotools to put generated files somewhere else?

Thanks,
Gregor
