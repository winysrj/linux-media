Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:16934 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbZD3C6Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2009 22:58:24 -0400
Received: by yw-out-2324.google.com with SMTP id 5so920156ywb.1
        for <linux-media@vger.kernel.org>; Wed, 29 Apr 2009 19:58:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090429142952.65d1c923@hyperion.delvare>
References: <20090417222927.7a966350@hyperion.delvare>
	 <20090429142952.65d1c923@hyperion.delvare>
Date: Wed, 29 Apr 2009 22:58:23 -0400
Message-ID: <412bdbff0904291958k78e965ccs58e720c5a080a6c3@mail.gmail.com>
Subject: Re: [PATCH 0/6] ir-kbd-i2c conversion to the new i2c binding model
	(v2)
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 29, 2009 at 8:29 AM, Jean Delvare <khali@linux-fr.org> wrote:
> On Fri, 17 Apr 2009 22:29:27 +0200, Jean Delvare wrote:
>> Here comes an update of my conversion of ir-kbd-i2c to the new i2c
>> binding model. I've split it into 6 pieces for easier review. (...)
>
> Did anyone test these patches, please?

Hello Jean,

I'm still going to get these tested this week for em28xx.  I got
sidetracked yesterday on a race condition I discovered in the dvb
core.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
