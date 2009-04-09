Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f160.google.com ([209.85.217.160]:56877 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935006AbZDIPvW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Apr 2009 11:51:22 -0400
Received: by gxk4 with SMTP id 4so1557508gxk.13
        for <linux-media@vger.kernel.org>; Thu, 09 Apr 2009 08:51:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090409124810.6c9f73bb@pedra.chehab.org>
References: <49DE0891.9010506@yahoo.gr>
	 <412bdbff0904090839v43772f6dk7f2ac47ef417f45f@mail.gmail.com>
	 <20090409124810.6c9f73bb@pedra.chehab.org>
Date: Thu, 9 Apr 2009 11:51:20 -0400
Message-ID: <412bdbff0904090851m2f165d53iadb106b238e813ee@mail.gmail.com>
Subject: Re: Multiple em28xx devices
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: rvf16 <rvf16@yahoo.gr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 9, 2009 at 11:48 AM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> On Thu, 9 Apr 2009 11:39:47 -0400
> Devin Heitmueller <devin.heitmueller@gmail.com> wrote:
>
>> 2009/4/9 rvf16 <rvf16@yahoo.gr>:
>> > So does the upstream driver support all the rest ?
>> > Analog TV
>> Yes
>>
>> > FM radio
>> No
>
> Yes, it does support FM radio, provided that you proper add radio specific
> configuration at em28xx-cards.c.

Guess I haven't been watching the tree close enough then.  :-)  I will
see about adding the profiles for the various em28xx devices I have.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
