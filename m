Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64881 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab2G2RHn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Jul 2012 13:07:43 -0400
Received: by bkwj10 with SMTP id j10so2538894bkw.19
        for <linux-media@vger.kernel.org>; Sun, 29 Jul 2012 10:07:42 -0700 (PDT)
Message-ID: <50156DCD.5070205@googlemail.com>
Date: Sun, 29 Jul 2012 19:07:25 +0200
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: Konke Radlow <kradlow@cisco.com>
CC: linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] Add support for RDS decoding
References: <1343238241-26772-1-git-send-email-kradlow@cisco.com> <50118F6F.8030504@googlemail.com> <201207271427.40172.kradlow@cisco.com>
In-Reply-To: <201207271427.40172.kradlow@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Konke,

On 7/27/12 4:27 PM, Konke Radlow wrote:
> changing the condition in the library header from 
>> #if __GNUC__ >= 4
>> #define LIBV4L_PUBLIC __attribute__ ((visibility("default")))
>> #else
>> #define LIBV4L_PUBLIC
>> #endif
> 
> to 
>> #if HAVE_VISIBILITY
>> #define LIBV4L_PUBLIC __attribute__ ((visibility("default")))
>> #else
>> #define LIBV4L_PUBLIC
>> #endif
> 
> causes linker problems for me. The public library functions can no longer be 
> found. I cannot figure out why it's working for programs using libv4l2.la but 
> not for programs using libv4l2rds.la

You need to include <config.h> before including this file in the utility
and library to get the HAVE_VISIBILITY definition activated.
The other option would be switching from defining HAVE_VISIBILITY in
config.h to a command line define.

Thanks,
Gregor
