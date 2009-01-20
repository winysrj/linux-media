Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:4423 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759287AbZATTu2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2009 14:50:28 -0500
Received: by qw-out-2122.google.com with SMTP id 3so1509507qwe.37
        for <linux-media@vger.kernel.org>; Tue, 20 Jan 2009 11:50:26 -0800 (PST)
Message-ID: <412bdbff0901201150w2a8a66b4r50670eccc3d8340a@mail.gmail.com>
Date: Tue, 20 Jan 2009 14:50:26 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "matthieu castet" <castet.matthieu@free.fr>
Subject: Re: haupauge remote keycode for av7110_loadkeys
Cc: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
	linux-media@vger.kernel.org
In-Reply-To: <4976295E.2070509@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4974E428.7020702@free.fr>
	 <20090119185326.29da37da@caramujo.chehab.org>
	 <4976295E.2070509@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 20, 2009 at 2:43 PM, matthieu castet
<castet.matthieu@free.fr> wrote:
> Hi,
>
> Mauro Carvalho Chehab wrote:
>>
>> On Mon, 19 Jan 2009 21:35:52 +0100
>> matthieu castet <castet.matthieu@free.fr> wrote:
>>
>>
>> Matthieu,
>>
>> You can replace the ir-kbd-i2c keys using the standard input ioctls for
>> it.
>> Take a look at v4l2-apps/util/keycode app. It allows you to read and
>> replace
>> any IR keycodes on the driver that properly implements the event support
>> (including ir-kbd-i2c).
>
> great I wasn't aware of this.
> But this doesn't seem very friendly : all remote keycodes are in kernel.
> If you want to change the remote, you have to do/provide the keycode for
> your remote even if it is already in kernel.
>
> Matthieu

Matthieu,

Your assessment of the current situation is correct.  Yes, it's a
pretty annoying situation.  It does have the upside that we
automatically provide the right keycodes for whatever remote comes by
default with a particular product, but obviously it is a mess if you
want to use some different remote and if your remote wasn't supported,
adding support requires a kernel recompile.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
