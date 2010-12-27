Return-path: <mchehab@gaivota>
Received: from bordeaux.papayaltd.net ([82.129.38.124]:55213 "EHLO
	bordeaux.papayaltd.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab0L0MOS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Dec 2010 07:14:18 -0500
Subject: Re: ngene & Satix-S2 dual problems
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=windows-1252
From: Andre <linux-media@dinkum.org.uk>
In-Reply-To: <AANLkTik4-U7oEAvDgyKe+ptM1B3Q14h5we0TUXh5txip@mail.gmail.com>
Date: Mon, 27 Dec 2010 12:14:16 +0000
Cc: linux-media@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <7C2F665C-6EA3-4C28-9B38-76BEF416B32B@dinkum.org.uk>
References: <4D1753CF.9010205@gmail.com> <55B5612B-5E2B-4C2E-AD5E-B0D5A7AC865B@dinkum.org.uk> <AANLkTik4-U7oEAvDgyKe+ptM1B3Q14h5we0TUXh5txip@mail.gmail.com>
To: Ludovic BOUE <ludovic.boue@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>


On 27 Dec 2010, at 11:12, Ludovic BOUE wrote:

> Hi,
> 
> About the CI part, from what I’ve read, it seems that the stream must be get from
> dvr0, than passed to sec0. And the final decrypted stream must be read
> from sec0.
> 
> I use Mumudvb and will not be able to handle this setup.

I hadn't found mumudvb before, interesting software, thanks.

The mumudvb pages on scrambled channels makes some suggestions, sounds like sasc-ng would be a better fit for this type of software, it's much more stable than a year ago too!

The rest I don't know about.

Andre