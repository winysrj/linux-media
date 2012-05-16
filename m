Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36144 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab2EPV2n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 May 2012 17:28:43 -0400
Received: by wibhn6 with SMTP id hn6so1202117wib.1
        for <linux-media@vger.kernel.org>; Wed, 16 May 2012 14:28:42 -0700 (PDT)
Date: Wed, 16 May 2012 23:28:37 +0200
From: =?UTF-8?B?QW5kcsOp?= Roth <neolynx@gmail.com>
To: Gregor Jasny <gjasny@googlemail.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 5/8] added m4 directory to gitignore
Message-ID: <20120516232837.37dc865f@neutrino.exnihilo>
In-Reply-To: <4FAFC35A.1040008@googlemail.com>
References: <1336911450-23661-1-git-send-email-neolynx@gmail.com>
	<1336911450-23661-5-git-send-email-neolynx@gmail.com>
	<4FAFC35A.1040008@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> On 5/13/12 2:17 PM, André Roth wrote:
> >  configure
> > +m4
> >  aclocal.m4
> >  autom4te.cache
> >  build-aux
> 
> The m4 directory also contains files that *are* under version control.
> Changes to these files will be undetected if the directory is being ignored.

this is not correct. with gitignore *only* untracked files will not be
shown in git status. modifications to tracked files are handled as
usual, and you are being able to add new files to git, although you
will not see them in git status.

> Maybe one can convince autotools to put generated files somewhere else?

IIRC the m4 directory can be specified somehow.

Should I remove the gitignore entry again ?

Thanks,
 andré
