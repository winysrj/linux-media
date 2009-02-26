Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:63969 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159AbZBZQlt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2009 11:41:49 -0500
Received: by ewy25 with SMTP id 25so701307ewy.37
        for <linux-media@vger.kernel.org>; Thu, 26 Feb 2009 08:41:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090226121445.74ed3202@caramujo.chehab.org>
References: <49A18DD5.40206@gmx.de>
	 <20090226121445.74ed3202@caramujo.chehab.org>
Date: Thu, 26 Feb 2009 08:35:06 -0800
Message-ID: <a3ef07920902260835n25faa130y401e2f4814172b4c@mail.gmail.com>
Subject: Re: [PATCH] dvb-api: update documentation, chapter1
From: VDR User <user.vdr@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: wk <handygewinnspiel@gmx.de>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 26, 2009 at 7:14 AM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> It seems better to say, instead, that "Version 4 was suggested, but it weren't completed nor implemented".

That's improper.  I think you mean, "Version 4 was suggested but
neither completed, nor implemented".

Why do I have a feeling even the updated doc will be full of spelling
& grammatical errors?  ;)

>> +This Linux DVB API documentation will be extended to reflect these
>> additions.
>
> While we don't finish adding the S2API parts, maybe we should say instead:
>
> This document is currently under review to reflect the S2API additions.

Maybe you should say, "This documentation is a work-in-progress and
doesn't contain the full scope of newer additions year, such as
S2API".

Also, you might want to consider changing "DVB cards" to "DVB
devices".  For example, I don't know anybody who refers to USB DVB
devices as 'DVB cards'.

Cheers,
-Derek
