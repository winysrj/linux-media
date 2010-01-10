Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:51973 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab0AJCLL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jan 2010 21:11:11 -0500
Received: by fxm25 with SMTP id 25so13637035fxm.21
        for <linux-media@vger.kernel.org>; Sat, 09 Jan 2010 18:11:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <846899811001021455u28fccb5cr66fd4258d3dddd4d@mail.gmail.com>
References: <3f3a053b1001021407k6ce936b8gd7d3e575a25e734d@mail.gmail.com>
	 <3f3a053b1001021411i2e9484d7rd2d13f1a355939fe@mail.gmail.com>
	 <846899811001021455u28fccb5cr66fd4258d3dddd4d@mail.gmail.com>
Date: Sun, 10 Jan 2010 03:11:10 +0100
Message-ID: <d9def9db1001091811s6dbed557vfca9ce410e41d3d3@mail.gmail.com>
Subject: Re: CI USB
From: Markus Rechberger <mrechberger@gmail.com>
To: HoP <jpetrous@gmail.com>
Cc: Jonas <oj@koekenbier.net>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jan 2, 2010 at 11:55 PM, HoP <jpetrous@gmail.com> wrote:
> Hi Jonas
>
>> Does anyone know if there's any progress on USB CI adapter support?
>> Last posts I can find are from 2008 (Terratec Cinergy CI USB &
>> Hauppauge WinTV-CI).
>>
>> That attempt seems to have stranded with Luc Brosens (who gave it a
>> shot back then) asking for help.
>>
>> The chip manufacturer introduced a usb stick as well;
>> http://www.smardtv.com/index.php?page=products_listing&rubrique=pctv&section=usbcam
>> but besides the scary Vista logo on that page, it looks like they
>> target broadcast companies only and not end users.
>>
>
> You are right. Seems DVB CI stick is not targeted to end consumers.
>
> Anyway, it looks interesting, even it requires additional DVB tuner
> "somewhere in the pc" what means duplicated traffic (to the CI stick
> for descrambling and back for mpeg a/v decoding).
>
> It would be nice to see such stuff working in linux, but because of
> market targeting i don' t expect that.
>
> BTW, Hauppauge's WinTV-CI looked much more promissing.
> At least when I started reading whole thread about it here:
> http://www.mail-archive.com/linux-dvb@linuxtv.org/msg28113.html
>
> Unfortunatelly, last Steve's note about not getting anything
> (even any answer) has disappointed me fully. And because
> google is quiet about any progress on it I pressume
> no any docu nor driver was released later on.
>

The question is more or less how many people are interested in USB CI
support for Linux.
We basically have everything to provide a USB CI solution for linux now.

Markus
