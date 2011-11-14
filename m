Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:11079 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab1KNNws (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Nov 2011 08:52:48 -0500
Date: Mon, 14 Nov 2011 14:52:36 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>,
	Michael Krufky <mkrufky@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC 1/2] dvb-core: add generic helper function for I2C
 register
Message-ID: <20111114145236.34c343c0@endymion.delvare>
In-Reply-To: <4EB9C13A.2060707@iki.fi>
References: <4EB9C13A.2060707@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

As an additional note, it just occurred to me that what you are working
on is somewhat related to Mark Brown's regmap. Look in
drivers/base/regmap and see if maybe you can reuse and/or extend Mark's
approach.

-- 
Jean Delvare
