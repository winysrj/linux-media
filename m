Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64571 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806Ab2ARMrN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jan 2012 07:47:13 -0500
Received: by eaac11 with SMTP id c11so917688eaa.19
        for <linux-media@vger.kernel.org>; Wed, 18 Jan 2012 04:47:11 -0800 (PST)
Message-ID: <4F16BF4D.4070404@googlemail.com>
Date: Wed, 18 Jan 2012 13:47:09 +0100
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: v4l-utils migrated to autotools
References: <4F134701.9000105@googlemail.com> <4F16B8CC.3010503@redhat.com>
In-Reply-To: <4F16B8CC.3010503@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 1/18/12 1:19 PM, Mauro Carvalho Chehab wrote:
> It would be nice to write at the INSTALL what dependencies are needed for
> the autotools to work, or, alternatively, to commit the files generated
> by the autoreconf -vfi magic spell there [1].

The end user gets a tarball created with "make dist" which contains all 
the m4 files.

For the developers I will list the dependencies (autotools-dev, 
pkgconfig and libtool) explicitely.

> Not sure if it is possible, but it would be great if the build output
> would be less verbose. libtool adds a lot of additional (generally useless)
> messages, with makes harder to see the compilation warnings in the
> middle of all those garbage.

I will add the AM_SILENT_RULES option later.

Thanks,
Gregor
