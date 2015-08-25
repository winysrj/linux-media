Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:33171 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbbHYTLH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2015 15:11:07 -0400
Received: by igfj19 with SMTP id j19so19672775igf.0
        for <linux-media@vger.kernel.org>; Tue, 25 Aug 2015 12:11:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <cover.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
Date: Tue, 25 Aug 2015 13:11:06 -0600
Message-ID: <CAKocOOOjJ3iuWTJv2qNt4=3m01YVVN444COtZ_e4ETXH=_XEbg@mail.gmail.com>
Subject: Re: [PATCH v7 00/44] MC next generation patches
From: Shuah Khan <shuahkhan@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	shuahkh@osg.samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Aug 23, 2015 at 2:17 PM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> The latest version of this patch series is at:
>         http://git.linuxtv.org/cgit.cgi/mchehab/experimental.git/log/?h=mc_next_gen
>
> The latest version of the userspace tool to test it is at:
>         http://git.linuxtv.org/cgit.cgi/mchehab/experimental-v4l-utils.git/log/?h=mc-next-gen
>
> The initial patches of this series are the same as the ones at the
>         "[PATCH v6 0/8] MC preparation patches"
> plus Javier patch series:
>         "[PATCH 0/4] [media] Media entity cleanups and build fixes"
> Addressing some of the concerns from Laurent:
>         Javier media_entity_id() patches got reordered;
>         all "elements" occurrences were replaced by "objects"
>

Do you have new media-ctl graphs that are based on these changes you
can share with us?
It would be nice to see before and after graphs from media-ctl.

thanks,
-- Shuah
