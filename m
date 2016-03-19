Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f173.google.com ([209.85.161.173]:35685 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbcCSC3N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Mar 2016 22:29:13 -0400
Received: by mail-yw0-f173.google.com with SMTP id g127so160524106ywf.2
        for <linux-media@vger.kernel.org>; Fri, 18 Mar 2016 19:29:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAEAJfAuZm1AOV7qBq2DEJtCbxmxqk=Bm2hWoOz8DNCTY3sdZA@mail.gmail.com>
References: <CAN5YuFYiRPDMUFqiiJrLXCH-tZnO9SJ-_TZfLD6_uq-L63OKyQ@mail.gmail.com>
	<CAAEAJfAg=QovDOHgTnh+0Gy5BbSXinc+rPGvTa61r5nyuou2tQ@mail.gmail.com>
	<CAN5YuFYbg0RwhhO3ck1m86PPk+PQrqrM9qNfRsoah==4_VS-SA@mail.gmail.com>
	<CAAEAJfANkWbYRHXb2kcCeFaffQ8UBqofX569So4r0A-NzwazOg@mail.gmail.com>
	<CAN5YuFa0kXxym9bq38CCxSXp5HqUbKLYjvRfG5EUGEcoZDZK3w@mail.gmail.com>
	<CAAEAJfAuZm1AOV7qBq2DEJtCbxmxqk=Bm2hWoOz8DNCTY3sdZA@mail.gmail.com>
Date: Fri, 18 Mar 2016 22:29:12 -0400
Message-ID: <CAN5YuFZiD9_y9t7zyVaRFBKxi_BhuUgNW_gB4z839A7amEJ5Gg@mail.gmail.com>
Subject: Re: STK1160 - no video
From: Kevin Fitch <kfitch42@gmail.com>
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Cc: linux-media <linux-media@vger.kernel.org>,
	Philippe Desrochers <desrochers.philippe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Well, I just tried, and failed to reproduce those kernel log messages.
There is a comment in one of the source file about "spammy" messages
that show up if there is mismatch between the actual and expected
video standards. I don't think I had them mismatched before, but maybe
I did. Or maybe after all my mucking around I had managed to get the
adapter in a weird state. So, for now, that patch seems to be all that
is needed.

Kevin

On Fri, Mar 18, 2016 at 7:11 PM, Ezequiel Garcia
<ezequiel@vanguardiasur.com.ar> wrote:
> Hey Kevin,
>
> On 4 March 2016 at 00:11, Kevin Fitch <kfitch42@gmail.com> wrote:
>> Here is a quick patch that gives me actual video. That being said I
>> see some curious stuff being logged while video is streaming:
>>
>
> Patch looks more or less good, but that kernel log is not good.
>
> It indicates that the USB packet is not entirely sane, and so the incoming
> data is not what the driver is expecting.
>
> Have you been able to make any progress with it?
> --
> Ezequiel García, VanguardiaSur
> www.vanguardiasur.com.ar
