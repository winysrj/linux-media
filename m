Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:42139 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab2I3CzJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Sep 2012 22:55:09 -0400
Received: by ieak13 with SMTP id k13so10014975iea.19
        for <linux-media@vger.kernel.org>; Sat, 29 Sep 2012 19:55:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJEuUsudgQHSktrDwHfELcUC0PMiRHmSw8S8buLcOGUFBqJ9Jw@mail.gmail.com>
References: <CAJEuUsudgQHSktrDwHfELcUC0PMiRHmSw8S8buLcOGUFBqJ9Jw@mail.gmail.com>
Date: Sat, 29 Sep 2012 22:55:08 -0400
Message-ID: <CAGoCfixuTTcwmYXk+9mFsjYnQjPn3CtqLDGxRCz_NCnWGAyKRQ@mail.gmail.com>
Subject: Re: DiBcom 7000PC: Not able to scan for services on Raspberry Pi
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?Ladislav_J=F3zsa?= <l.jozsa@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Sep 29, 2012 at 3:34 PM, Ladislav Józsa <l.jozsa@gmail.com> wrote:
> Running the same on my x86_64 machine works and tvheadend sees
> multiplexes. What else information do you need from me in order to
> track the problem?

Recompile your kernel with debug info so we can see the symbols for
the stack dump.  Otherwise there is no way for anybody to know where
the oops is occurring in the driver.

Devin


-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
