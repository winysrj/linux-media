Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:49721 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936463Ab0B1Tlx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Feb 2010 14:41:53 -0500
Date: Sun, 28 Feb 2010 20:42:12 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-media@vger.kernel.org, Max Thrun <bear24rw@gmail.com>
Subject: Re: [PATCH 05/11] ov534: Fix setting manual exposure
Message-ID: <20100228204212.0b78f1f9@tele>
In-Reply-To: <20100228195425.0be36259.ospite@studenti.unina.it>
References: <1267302028-7941-1-git-send-email-ospite@studenti.unina.it>
	<1267302028-7941-6-git-send-email-ospite@studenti.unina.it>
	<20100228193814.34f6755f@tele>
	<20100228195425.0be36259.ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 28 Feb 2010 19:54:25 +0100
Antonio Ospite <ospite@studenti.unina.it> wrote:

> JF, the intent here is to cover all the range of values available in
> Auto Exposure mode too, doesn't this make sense to you?
> 
> I could set .maximum to 253 to limit the "UI" control precision but
> then I should use 2*value when setting the registers in order to
> cover the actual max value, this looks a little unclean.
> 
> Anyhow, let me know what you prefer, I have no strong feelings on
> that. If you want to save a byte, I'll agree.

Looking at the rare chip documents I got, I often saw internal control
values on 3 bytes (16 million values). Could anybody see the difference
between values v and (v+1)?

So, often, even when the internal controls are stored in only one byte,
the ms-win drivers propose only ranges as 0..30 or 0..100.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
