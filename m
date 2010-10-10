Return-path: <mchehab@pedra>
Received: from smtp5-g21.free.fr ([212.27.42.5]:60966 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757540Ab0JJKUo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Oct 2010 06:20:44 -0400
Date: Sun, 10 Oct 2010 12:21:29 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-media@vger.kernel.org
Subject: Re: gspca, audio and ov534: regression.
Message-ID: <20101010122129.68f3718a@tele>
In-Reply-To: <20101010120250.4739ce08.ospite@studenti.unina.it>
References: <20101006123321.baade0a4.ospite@studenti.unina.it>
	<20101006134855.43879d74@tele>
	<20101006160441.6ee9583d.ospite@studenti.unina.it>
	<20101006203553.22edfeb7@tele>
	<20101010120250.4739ce08.ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 10 Oct 2010 12:02:50 +0200
Antonio Ospite <ospite@studenti.unina.it> wrote:

> JF this change as is does not work for me, if I change the second
> check to 
> 	if (gspca_dev->audio && i > 1)
> 
> it does, but I don't know if this breaks anything else.

Hi Antonio,

You are right, this is the way the test must be.

I'll try to have this in the kernel 2.6.36.

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
