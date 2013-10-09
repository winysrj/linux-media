Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:37766 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3JINsw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Oct 2013 09:48:52 -0400
Received: by mail-we0-f169.google.com with SMTP id q58so994335wes.0
        for <linux-media@vger.kernel.org>; Wed, 09 Oct 2013 06:48:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <525431B7.6050000@googlemail.com>
References: <1380501923-23127-1-git-send-email-jfthibert@google.com>
	<525431B7.6050000@googlemail.com>
Date: Wed, 9 Oct 2013 09:48:51 -0400
Message-ID: <CACxGHmN6Vj9sN1XB7W6-24MLCarSvhpxyMYNZHin5+uB9Rr6rQ@mail.gmail.com>
Subject: Re: [PATCH] Add support for KWorld UB435-Q V2
From: Jean-Francois Thibert <jfthibert@google.com>
To: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 8, 2013 at 12:24 PM, Frank Schäfer
<fschaefer.oss@googlemail.com> wrote:
> > This adds support for the UB435-Q V2. It seems that you might need to
> > use the device once with the official driver to reprogram the device
> > descriptors. Thanks to Jarod Wilson for the initial attempt at adding
> > support for this device.
> Could you please elaborate on this ?
> What's the "official" driver and what changes after using it ?
> Are these changes permanent ?

>From what I understand the Windows driver provided by KWorld will reprogram
the eeprom so that the device descriptors are properly describing an Isochronous
endpoint instead of Bulk. This only needs to be done once since it is permanent.
I don't know if this is required since I don't have a device in the other state.

> The commit message should be included in the patch and not be sent as a
> separate message.
> Can you fix the patch and resend it ?

Sure, I will resend the patch with the message included.

Regards
Jean-Francois
