Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:54725 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728392AbeGYHPy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jul 2018 03:15:54 -0400
Received: by mail-it0-f54.google.com with SMTP id s7-v6so7084437itb.4
        for <linux-media@vger.kernel.org>; Tue, 24 Jul 2018 23:05:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180723113521.4enawluordbdfd2p@valkosipuli.retiisi.org.uk>
References: <CAJCx=g=+GWrPTWpU_AgGKLKWtXY57c=7i-1ijMVdJP=scRqyYw@mail.gmail.com>
 <20180723113521.4enawluordbdfd2p@valkosipuli.retiisi.org.uk>
From: Matt Ranostay <matt.ranostay@konsulko.com>
Date: Tue, 24 Jul 2018 23:05:47 -0700
Message-ID: <CAJCx=gkYebxOX5DZZtJTJeQW7jzFS5aJ2_PStJ2ZxEfxqutUSA@mail.gmail.com>
Subject: Re: [RFC] media: thermal I2C cameras metadata
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 23, 2018 at 4:35 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Matt,
>
> On Sun, Jul 15, 2018 at 11:05:42PM -0700, Matt Ranostay wrote:
>> Hello et all,
>>
>> So currently working with some thermal sensors that have coefficients
>> that needs to be passed back to userspace that aren't related to the
>> pixel data but are required to normalize to remove scan patterns and
>> temp gradients. Was wondering the best way to do this, and hope it
>> isn't some is kludge of the close captioning, or just passing raw data
>> as another column line.
>
> Are you referring to the EEPROM content or something else?
>
> For EEPROM, I could think of just exposing the EEPROM to the user space
> as-is using the NVMEM API. This information is very, very device specific
> and therefore using a generic interface to access individual values there
> isn't really useful.
>

Actually that is okay for the EEPROM data that is per sensor, and
nvram does seem like it would work.
But there is per video frame data that is required along with the
static EEPROM data to calculate the actual end result.

- Matt

> --
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi
