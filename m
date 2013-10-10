Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:48987 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab3JJNiB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Oct 2013 09:38:01 -0400
Received: by mail-ee0-f51.google.com with SMTP id c1so1162889eek.10
        for <linux-media@vger.kernel.org>; Thu, 10 Oct 2013 06:38:00 -0700 (PDT)
Message-ID: <5256ADCA.2020005@googlemail.com>
Date: Thu, 10 Oct 2013 15:38:18 +0200
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Jean-Francois Thibert <jfthibert@google.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Add support for KWorld UB435-Q V2
References: <1380501923-23127-1-git-send-email-jfthibert@google.com> <525431B7.6050000@googlemail.com> <CACxGHmN6Vj9sN1XB7W6-24MLCarSvhpxyMYNZHin5+uB9Rr6rQ@mail.gmail.com>
In-Reply-To: <CACxGHmN6Vj9sN1XB7W6-24MLCarSvhpxyMYNZHin5+uB9Rr6rQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 09.10.2013 15:48, schrieb Jean-Francois Thibert:
> On Tue, Oct 8, 2013 at 12:24 PM, Frank Schäfer
> <fschaefer.oss@googlemail.com> wrote:
>>> This adds support for the UB435-Q V2. It seems that you might need to
>>> use the device once with the official driver to reprogram the device
>>> descriptors. Thanks to Jarod Wilson for the initial attempt at adding
>>> support for this device.
>> Could you please elaborate on this ?
>> What's the "official" driver and what changes after using it ?
>> Are these changes permanent ?
> From what I understand the Windows driver provided by KWorld will reprogram
> the eeprom so that the device descriptors are properly describing an Isochronous
> endpoint instead of Bulk. This only needs to be done once since it is permanent.
> I don't know if this is required since I don't have a device in the other state.
What do you mean with "properly describing an Isoc endpoint" ?
Did the Windows driver reprogram the device to provide an isoc instead
of a bulk video endpoint ?
Or did the device have no video endpoint and the bulk endpoint was used
for something different (likely device programming) ?
Any chance to get lsusb outputs ?

If you don't have a device in the other state and didn't test the bulk
endpoint's, how did you notice this issue ?

Regards,
Frank

>
>> The commit message should be included in the patch and not be sent as a
>> separate message.
>> Can you fix the patch and resend it ?
> Sure, I will resend the patch with the message included.
>
> Regards
> Jean-Francois

