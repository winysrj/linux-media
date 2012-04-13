Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46602 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752745Ab2DMSml (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Apr 2012 14:42:41 -0400
Received: by lahj13 with SMTP id j13so2605015lah.19
        for <linux-media@vger.kernel.org>; Fri, 13 Apr 2012 11:42:40 -0700 (PDT)
Message-ID: <4F88739A.4020401@gmail.com>
Date: Fri, 13 Apr 2012 20:42:34 +0200
From: =?ISO-8859-1?Q?Roger_M=E5rtensson?= <roger.martensson@gmail.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: media_build compile errors
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

I get compile errors when trying to build media_build as of 2012-04-13.

/home/mythfrontend/media_build/v4l/ivtv-fileops.c: In function 
'ivtv_v4l2_enc_poll':
/home/mythfrontend/media_build/v4l/ivtv-fileops.c:751:2: error: implicit 
declaration of function 'poll_requested_events' 
[-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

This is on ubuntu and kernel:
Linux 3.0.0-16-generic #29-Ubuntu SMP Tue Feb 14 12:49:42 UTC 2012 i686 
i686 i386 GNU/Linux

Anyone else seeing this problem?
