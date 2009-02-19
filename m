Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:62712 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbZBSRUH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2009 12:20:07 -0500
Received: by bwz5 with SMTP id 5so1433506bwz.13
        for <linux-media@vger.kernel.org>; Thu, 19 Feb 2009 09:20:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200902191815.16460.nsoranzo@tiscali.it>
References: <200902191741.57767.nsoranzo@tiscali.it>
	 <d9def9db0902190857p331d7667td0900ec6e8a9c75f@mail.gmail.com>
	 <200902191815.16460.nsoranzo@tiscali.it>
Date: Thu, 19 Feb 2009 18:20:03 +0100
Message-ID: <d9def9db0902190920o262fb58cg405a692cc49cb7b3@mail.gmail.com>
Subject: Re: [PATCH] em28xx: register device to soundcard for sysfs
From: Markus Rechberger <mrechberger@gmail.com>
To: Nicola Soranzo <nsoranzo@tiscali.it>
Cc: Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 19, 2009 at 6:15 PM, Nicola Soranzo <nsoranzo@tiscali.it> wrote:
> Alle giovedì 19 febbraio 2009, Markus Rechberger ha scritto:
>> On Thu, Feb 19, 2009 at 5:41 PM, Nicola Soranzo <nsoranzo@tiscali.it> wrote:
>> > As explained in "Writing an ALSA driver" (T. Iwai),
>>
>> when writing a patch write the truth about where it comes from, eg.
>> the author of the patch.
>
> I'm sorry Markus, but you're just the inspirer of the patch.
> I wanted to use your code and so two weeks ago I asked you twice privately if
> it was ok for you, and you didn't answer me.
> Then I checked the documentation cited above, changed the one-line patch to be
> more general and now it does not contain code from your tree anymore.
>

good to know :-) A short line stating out that the code was simply
diffed from the
other repository would have been enough.

> Anyway, thanks for the idea

you're welcome.

Markus
