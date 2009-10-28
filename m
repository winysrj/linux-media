Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:38262 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbZJ1OM3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Oct 2009 10:12:29 -0400
Received: by ey-out-2122.google.com with SMTP id 9so208425eyd.19
        for <linux-media@vger.kernel.org>; Wed, 28 Oct 2009 07:12:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <83bcf6340910280708t67fdfbffw88dc4594ca527359@mail.gmail.com>
References: <8d0bb7650910261544i4ebed975rf81ec6bc38076927@mail.gmail.com>
	 <a413d4880910261623x44d106f4h167a7dab80a4a3f8@mail.gmail.com>
	 <83bcf6340910270717n12066fb8oa4870eb3214d7597@mail.gmail.com>
	 <8d0bb7650910270755v38f37f6fh3937e9727493854c@mail.gmail.com>
	 <83bcf6340910270920i4323faf8mb5b482b75bda7291@mail.gmail.com>
	 <8d0bb7650910272244wfdbdda0kae6bec6cd94e2bcc@mail.gmail.com>
	 <83bcf6340910280708t67fdfbffw88dc4594ca527359@mail.gmail.com>
Date: Wed, 28 Oct 2009 10:12:33 -0400
Message-ID: <83bcf6340910280712ue562142i5ef891fe2b701f3d@mail.gmail.com>
Subject: Re: Hauppage HVR-2250 Tuning problems
From: Steven Toth <stoth@kernellabs.com>
To: dan <danwalkeriv@gmail.com>
Cc: Another Sillyname <anothersname@googlemail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 28, 2009 at 10:08 AM, Steven Toth <stoth@kernellabs.com> wrote:
> On Wed, Oct 28, 2009 at 1:44 AM, dan <danwalkeriv@gmail.com> wrote:
>> I do have 2 2-way splitters between the card in the wall.  I tried
>> hooking the card straight to the cable outlet on the wall and ran some
>> more tests.  It's a little difficult, because there's only one cable
>> outlet in my whole apartment, and it means doing some re-arranging and
>> being offline while I'm running the tests.
>
> Removing splitters proves it's probably not a weak signal issue (also
> the SNR or 39 on the TV).  Can you apply some attenuation to reduce
> the overall rf strength? I'm thinking it's too hot.
>
> Something must be using your second tuner, mythtv maybe?

Oh, and please try the card under windows ideally on the same PC using
the same antenna feed, to rule out any card specific issues.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
