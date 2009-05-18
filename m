Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:31049 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755902AbZERHSg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2009 03:18:36 -0400
Date: Mon, 18 May 2009 09:18:15 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Mike Isely <isely@isely.net>
Cc: Oldrich Jedlicka <oldium.pro@seznam.cz>,
	LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Andy Walls <awalls@radix.net>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 0/8] ir-kbd-i2c conversion to the new i2c binding model
  (v3)
Message-ID: <20090518091815.74e6b579@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.64.0905171654030.17519@cnc.isely.net>
References: <20090513214559.0f009231@hyperion.delvare>
	<200905142125.02332.oldium.pro@seznam.cz>
	<20090514212614.09d51a93@hyperion.delvare>
	<Pine.LNX.4.64.0905171654030.17519@cnc.isely.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 17 May 2009 16:55:54 -0500 (CDT), Mike Isely wrote:
> On Wednesday 13 of May 2009 at 21:45:59, Jean Delvare wrote:
> > Here comes an update of my conversion of ir-kbd-i2c to the new i2c
> > binding model. I've split it into 8 pieces for easier review. Firstly
> > there is 1 preliminary patch:
> > (...)
>
> I tried the all-in-one patch here on a PVR-USB2 24xxx model (slightly 
> older v4l-dvb repo and 2.6.27.13 vanilla kernel) and it worked fine.  
> I'll add an acked-by to the corresponding (trivial) pvrusb2 patch that 
> you've posted.

Thanks for the testing Mike.

Mauro, I think it's time to add these patches to the v4l-dvb repository
so that they get broader testing.

-- 
Jean Delvare
