Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:36597 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031910Ab0B1TzK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Feb 2010 14:55:10 -0500
Date: Sun, 28 Feb 2010 20:55:28 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-media@vger.kernel.org,
	Mosalam Ebrahimi <m.ebrahimi@ieee.org>,
	Max Thrun <bear24rw@gmail.com>
Subject: Re: [PATCH 10/11] ov534: Add Powerline Frequency control
Message-ID: <20100228205528.54d1ba69@tele>
In-Reply-To: <20100228201850.81f7904a.ospite@studenti.unina.it>
References: <1267302028-7941-1-git-send-email-ospite@studenti.unina.it>
	<1267302028-7941-11-git-send-email-ospite@studenti.unina.it>
	<20100228194951.1c1e26ce@tele>
	<20100228201850.81f7904a.ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 28 Feb 2010 20:18:50 +0100
Antonio Ospite <ospite@studenti.unina.it> wrote:

> Maybe we could just use
> 	V4L2_CID_POWER_LINE_FREQUENCY_DISABLED	= 0,
> 	V4L2_CID_POWER_LINE_FREQUENCY_50HZ	= 1,
> 
> It looks like the code matches the DISABLED state (writing 0 to the
> register). Mosalam?

I don't know the ov772x sensor. I think it should look like the ov7670
where there are 3 registers to control the light frequency: one
register tells if light frequency filter must be used, and which
frequency 50Hz or 60Hz; the two other ones give the filter values for
each frequency.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
