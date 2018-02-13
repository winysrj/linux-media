Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:42957 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964832AbeBMNrK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 08:47:10 -0500
Received: by mail-qt0-f177.google.com with SMTP id l9so3388449qtj.9
        for <linux-media@vger.kernel.org>; Tue, 13 Feb 2018 05:47:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANiq72kfqf+nhioH7nGPPsFh9PU7NsGLy+8bD7oXNiLCWx6ZeQ@mail.gmail.com>
References: <cover.1516008708.git.sean@mess.org> <cdfa0d36f2f2d306e0824205b4fca0b685991ee9.1516008708.git.sean@mess.org>
 <CANiq72kfqf+nhioH7nGPPsFh9PU7NsGLy+8bD7oXNiLCWx6ZeQ@mail.gmail.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Tue, 13 Feb 2018 15:47:09 +0200
Message-ID: <CAHp75VdC9pZVKKPUo3dZeLnHt20nPz10fTTfXfKy6pX7Ha=vaw@mail.gmail.com>
Subject: Re: [PATCH 2/5] auxdisplay: charlcd: add flush function
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Sean Young <sean@mess.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 12, 2018 at 10:44 PM, Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
> On Mon, Jan 15, 2018 at 10:58 AM, Sean Young <sean@mess.org> wrote:
>> The Sasem Remote Controller has an LCD, which is connnected via usb.
>> Multiple write reg or write data commands can be combined into one usb
>> packet.
>>
>> The latency of usb is such that if we send commands one by one, we get
>> very obvious tearing on the LCD.
>>
>> By adding a flush function, we can buffer all commands until either
>> the usb packet is full or the lcd changes are complete.

> Cc'ing Arnd and Greg since this touches include/misc as well.

>> --- a/include/misc/charlcd.h
>> +++ b/include/misc/charlcd.h

As far as I can see better to create a subfolder under include for
auxdisplay stuff.
Currently we have three candidates here:
linux/cfag12864b.h
linux/ks0108.h
misc/charlcd.h

Another possibility to get rid of them under include/ by (re)moving to
drivers/auxdisplay/.

-- 
With Best Regards,
Andy Shevchenko
