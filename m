Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37836 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757311Ab2D3X3q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Apr 2012 19:29:46 -0400
Received: by obbtb18 with SMTP id tb18so123423obb.19
        for <linux-media@vger.kernel.org>; Mon, 30 Apr 2012 16:29:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120430172703.3052d3a0@lwn.net>
References: <20120430220627.B4C339D401E@zog.reactivated.net>
	<20120430172703.3052d3a0@lwn.net>
Date: Mon, 30 Apr 2012 17:29:45 -0600
Message-ID: <CAMLZHHT3ASU=dDPfFM1fe64_jLdqCjN0c-_4JjyuvAXFf5up6w@mail.gmail.com>
Subject: Re: [PATCH] via-camera: specify XO-1.5 camera clock speed
From: Daniel Drake <dsd@laptop.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: mchehab@infradead.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 30, 2012 at 5:27 PM, Jonathan Corbet <corbet@lwn.net> wrote:
> On Mon, 30 Apr 2012 23:06:27 +0100 (BST)
> Daniel Drake <dsd@laptop.org> wrote:
>
>> For the ov7670 camera to return images at the requested frame rate,
>> it needs to make calculations based on the clock speed, which is
>> a completely external factor (depends on the wiring of the system).
>>
>> On the XO-1.5, which is the only known via-camera user, the camera
>> is clocked at 90MHz.
>>
>> Pass this information to the ov7670 driver, to fix an issue where
>> a framerate of 3x the requested amount was being provided.
>
> This is big-time weird...this problem has been solved before.  The reason
> ov7670 *has* a clock speed parameter is because the XO 1.5 - the second
> user - clocked it so fast.  I'm going to have to go digging through some
> history to try to figure out where this fix went...
>
> Meanwhile, this looks fine.

We solved it with ugly #ifdef things in the OLPC kernel.
http://dev.laptop.org/ticket/10137

Then we found and discussed the upstreamable solution, put the
ov7670_config thing in place, and solved it for XO-1 (cafe).

But for whatever reason it looks like I forgot to fix via-camera --
maybe via-camera was still in flux and non-upstream at that time.

Daniel
