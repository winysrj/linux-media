Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:40556 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab3HJGKx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Aug 2013 02:10:53 -0400
Received: by mail-ee0-f42.google.com with SMTP id b45so2534721eek.1
        for <linux-media@vger.kernel.org>; Fri, 09 Aug 2013 23:10:52 -0700 (PDT)
Message-ID: <5205D969.4040301@gmail.com>
Date: Sat, 10 Aug 2013 09:10:49 +0300
From: Yaroslav Zakharuk <slavikz@gmail.com>
MIME-Version: 1.0
To: Antonio Ospite <ospite@studenti.unina.it>
CC: linux-media@vger.kernel.org, 1173723@bugs.launchpad.net
Subject: Re: [PATCH RFC] [media] gspca-ov534: don't call sd_start() from sd_init()
References: <20130731133634.fbfe99f97026454593d3518f@studenti.unina.it> <1375654827-14270-1-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1375654827-14270-1-git-send-email-ospite@studenti.unina.it>
Content-Type: text/plain; charset=windows-1251; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antonio,
> Let me know if the change below alone is enough and the webcam keeps working,
> a test with suspend and resume would good to have too.
I've tested your patch with the latest kernel (3.11.0-rc4) - the webcam 
works OK.  After suspend and resume, the webcam works OK too.

-- 
Bye, Yaroslav

