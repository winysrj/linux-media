Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:37799 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758635AbcCCXNp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2016 18:13:45 -0500
Received: by mail-wm0-f50.google.com with SMTP id p65so9811993wmp.0
        for <linux-media@vger.kernel.org>; Thu, 03 Mar 2016 15:13:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAN5YuFYiRPDMUFqiiJrLXCH-tZnO9SJ-_TZfLD6_uq-L63OKyQ@mail.gmail.com>
References: <CAN5YuFYiRPDMUFqiiJrLXCH-tZnO9SJ-_TZfLD6_uq-L63OKyQ@mail.gmail.com>
Date: Thu, 3 Mar 2016 20:13:43 -0300
Message-ID: <CAAEAJfAg=QovDOHgTnh+0Gy5BbSXinc+rPGvTa61r5nyuou2tQ@mail.gmail.com>
Subject: Re: STK1160 - no video
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: Kevin Fitch <kfitch42@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kevin,

Thanks for the report.

On 3 March 2016 at 14:20, Kevin Fitch <kfitch42@gmail.com> wrote:
> I recently purchased a STK1160 based USB video capture device (Sabrent
> USB-AVCPT). I have tested it on a windows computer and it works fine,
> but not on any linux box I have tried.
>
> lsusb reports:
> Bus 002 Device 003: ID 05e1:0408 Syntek Semiconductor Co., Ltd STK1160
> Video Capture Device
>

Can you send us the kernel log after the dongle is plugged? In particular,
we are looking for something like this:

saa7115 7-0025: saa7113 found @ 0x4a (stk1160)

STK1160 devices are known to be sold with different decoder chips,
and sometimes the decoder chip is not detected by the decoder
driver.

See this thread for more information:
http://www.spinics.net/lists/linux-media/msg95216.html
-- 
Ezequiel García, VanguardiaSur
www.vanguardiasur.com.ar
