Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f174.google.com ([209.85.160.174]:47468 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbaDNOWM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Apr 2014 10:22:12 -0400
Received: by mail-yk0-f174.google.com with SMTP id 20so7428601yks.5
        for <linux-media@vger.kernel.org>; Mon, 14 Apr 2014 07:22:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <534BE92F.3010501@xs4all.nl>
References: <534BE92F.3010501@xs4all.nl>
Date: Mon, 14 Apr 2014 10:22:11 -0400
Message-ID: <CALzAhNUsa6CGGssp=FdNNC88zhhCg9HWwOTrO8Q-77mPTF1fig@mail.gmail.com>
Subject: Re: [PATCH] cx23885: add support for Hauppauge ImpactVCB-e
From: Steven Toth <stoth@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Steve Cookson - IT <it@sca-uk.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

> While I do get audio it is very choppy. It is not clear whether that is
> a general cx23885 driver problem or specific to this board. If it is specific
> to the board, then I might have missed something.
>
> Steven (Toth, not Cookson ;-) ), do you have an idea what it might be?

Nothing comes to mind, I'm not aware of any audio issues with the
other '885/7/8 boards.

A board issue or driver regression would be my guess.

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
