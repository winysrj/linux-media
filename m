Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:20883 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbZCHXyD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Mar 2009 19:54:03 -0400
Received: by wf-out-1314.google.com with SMTP id 28so1634573wfa.4
        for <linux-media@vger.kernel.org>; Sun, 08 Mar 2009 16:54:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090308155125.5f8afe07@caramujo.chehab.org>
References: <d18a06340903080108p3d06e2ajd2f4f1026f1eef40@mail.gmail.com>
	 <20090308140304.3cf9370a@caramujo.chehab.org>
	 <a3ef07920903081138n25f00be1k282061ed17bf406@mail.gmail.com>
	 <20090308155125.5f8afe07@caramujo.chehab.org>
Date: Sun, 8 Mar 2009 16:54:02 -0700
Message-ID: <a3ef07920903081654l39b98c2du57350109d7381fb@mail.gmail.com>
Subject: Re: Kconfig changes in /hg/v4l-dvb caused dvb_usb_cxusb to stop
	building
From: VDR User <user.vdr@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Peter Baartz <baartzy@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 8, 2009 at 11:51 AM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
>> Yesterday I grabbed a fresh clone of v4l and compiled drivers for my
>> nexus-s.  Only that none of the required frontend modules were enabled
>> automatically as they should be when I selected AV7110.  I had to
>> manually go enable them by hand.  Luckily I knew which ones were
>> needed but I'm sure a ton of users have no clue.
>
> Hopefully, it should be fixed right now. I did a one-line change at the scripts
> that does the .config initialization. At least, on my tests, everything seems
> to be fine right now with -hg.

I just grabbed a fresh clone (7cfb5386b66f tip) to see and it's still
broken.  Everything was enabled in menuconfig by default but
deselecting everything and then enabling AV7110 back still isn't
-M-'ing the required frontends.
