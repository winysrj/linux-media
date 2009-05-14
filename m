Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:4010 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbZENT02 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2009 15:26:28 -0400
Date: Thu, 14 May 2009 21:26:14 +0200
From: Jean Delvare <khali@linux-fr.org>
To: =?UTF-8?B?T2xkxZlpY2ggSmVkbGnEjWth?= <oldium.pro@seznam.cz>
Cc: LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Andy Walls <awalls@radix.net>,
	Hans Verkuil <hverkuil@xs4all.nl>, Mike Isely <isely@pobox.com>
Subject: Re: [PATCH 0/8] ir-kbd-i2c conversion to the new i2c binding model
 (v3)
Message-ID: <20090514212614.09d51a93@hyperion.delvare>
In-Reply-To: <200905142125.02332.oldium.pro@seznam.cz>
References: <20090513214559.0f009231@hyperion.delvare>
	<200905142125.02332.oldium.pro@seznam.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 14 May 2009 21:25:02 +0200, Oldřich Jedlička wrote:
> On Wednesday 13 of May 2009 at 21:45:59, Jean Delvare wrote:
> > Hi all,
> >
> > Here comes an update of my conversion of ir-kbd-i2c to the new i2c
> > binding model. I've split it into 8 pieces for easier review. Firstly
> > there is 1 preliminary patch:
> >
> 
> Hi Jean,
> 
> works for me, as usual :-) I've used the all-in-one patch and the up-to-date 
> v4l-dvb tree (compiled yesterday for completeness).

Oldrich, thanks a lot for testing and reporting, this is very
appreciated.

-- 
Jean Delvare
