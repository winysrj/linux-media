Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:46919 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756569Ab2KZRuU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Nov 2012 12:50:20 -0500
Date: Mon, 26 Nov 2012 18:51:02 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH] gspca - ov534: Fix the light frequency filter
Message-ID: <20121126185102.28afbd11@armhf>
In-Reply-To: <20121126181241.d13631659092083fb9021aac@studenti.unina.it>
References: <20121122124652.3a832e33@armhf>
	<20121123180909.021c55a8c3795329836c42b7@studenti.unina.it>
	<20121123191232.7ed9c546@armhf>
	<20121126140806.65a6aa2b310c774e4edd62c3@studenti.unina.it>
	<20121126162318.228c249f@armhf>
	<20121126181241.d13631659092083fb9021aac@studenti.unina.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 26 Nov 2012 18:12:41 +0100
Antonio Ospite <ospite@studenti.unina.it> wrote:

> BTW the documentation might also be wrong or inaccurate.

The ov7670 documentation has exactly the same description of the
register 0x2b, and I don't think that the manufacturer would greatly
change the meaning of such low registers in so close sensors.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
