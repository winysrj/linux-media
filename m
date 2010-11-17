Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:60137 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932959Ab0KQBwD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 20:52:03 -0500
Message-ID: <4CE33527.8090800@infradead.org>
Date: Tue, 16 Nov 2010 23:51:35 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Jarod Wilson <jarod@redhat.com>
CC: Nicolas Kaiser <nikai@nikai.net>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/media: nuvoton: always true expression
References: <20101116211953.238012db@absol.kitzblitz> <20101116215408.GA17140@redhat.com>
In-Reply-To: <20101116215408.GA17140@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 16-11-2010 19:54, Jarod Wilson escreveu:
> On Tue, Nov 16, 2010 at 09:19:53PM +0100, Nicolas Kaiser wrote:
>> I noticed that the second part of this conditional is always true.
>> Would the intention be to strictly check on both chip_major and
>> chip_minor?
>>
>> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
> 
> Hrm, yeah, looks like I screwed that one up. You're correct, the intention
> was to make sure we have a matching chip id high and one or the other of
> the chip id low values.
> 
> Acked-by: Jarod Wilson <jarod@redhat.com>
> 
I wander if it wouldn't be good to print something if the probe fails due to
the wrong chip ID. It may help if someone complain about a different 
revision.

Mauro.
