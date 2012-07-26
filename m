Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41296 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab2GZSl5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 14:41:57 -0400
Received: by bkwj10 with SMTP id j10so1459164bkw.19
        for <linux-media@vger.kernel.org>; Thu, 26 Jul 2012 11:41:56 -0700 (PDT)
Message-ID: <50118F6F.8030504@googlemail.com>
Date: Thu, 26 Jul 2012 20:41:51 +0200
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: Konke Radlow <kradlow@cisco.com>
CC: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	hdegoede@redhat.com
Subject: Re: [RFC PATCH 0/2] Add support for RDS decoding
References: <1343238241-26772-1-git-send-email-kradlow@cisco.com>
In-Reply-To: <1343238241-26772-1-git-send-email-kradlow@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Konke,

On 7/25/12 7:43 PM, Konke Radlow wrote:
> The latest version of the code can always be found in my github repository:
> https://github.com/koradlow/v4l2-rds-ctl

In the github dir is a lib/include/libv4l2rd.h file. I cannot find it in
the patchset. It also looks like you're bases on an older revision of
the tree. Please rebase your patches.

In the mentioned header files please replace the condition in

#if __GNUC__ >= 4
#define LIBV4L_PUBLIC __attribute__ ((visibility("default")))
#else
#define LIBV4L_PUBLIC
#endif

with the ones found in libv4l2.h.

Thanks,
Gregor
