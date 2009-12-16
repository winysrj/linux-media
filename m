Return-path: <linux-media-owner@vger.kernel.org>
Received: from viefep17-int.chello.at ([62.179.121.37]:56845 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762018AbZLPLPG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2009 06:15:06 -0500
Message-ID: <4B28C133.3020600@waechter.wiz.at>
Date: Wed, 16 Dec 2009 12:14:59 +0100
From: =?UTF-8?B?TWF0dGhpYXMgV8OkY2h0ZXI=?= <matthias@waechter.wiz.at>
MIME-Version: 1.0
To: Newsy Paper <newspaperman_germany@yahoo.com>
CC: Oleg Roitburd <oroitburd@gmail.com>, linux-media@vger.kernel.org
Subject: Re: no locking on dvb-s2 22000 2/3 8PSK transponder on Astra 19.2E
  with tt s2-3200
References: <108905.8710.qm@web23208.mail.ird.yahoo.com>
In-Reply-To: <108905.8710.qm@web23208.mail.ird.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 15.12.2009 20:44, schrieb Newsy Paper:
> yes, this transponder is working again at blog.ors.at they say that they updated the modulator. It is working now again but driver still has this bug, so it's interesting what the update of the modulator changed exactly.

Today I received an answer from Peter Knorr, ORS, where he told me that
when they activated their modulator on 3 Dec 2009, it was set up to
output an inverted spectrum. What they did to fix our issue was to
switch off this inversion.

For me, personally, the issue with 19.2°/11302.75h is closed. Maybe
someone with knowledge about handling STB6100/STB0899 will be able to
finally solve the issue with transponders that have an inverted spectrum.

– Matthias
