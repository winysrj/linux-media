Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46447 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbZFJALP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Jun 2009 20:11:15 -0400
Message-ID: <4A2EFA23.6020602@iki.fi>
Date: Wed, 10 Jun 2009 03:11:15 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jan Nikitenko <jan.nikitenko@gmail.com>
CC: linux-media@vger.kernel.org,
	Christopher Pascoe <c.pascoe@itee.uq.edu.au>
Subject: Re: AVerTV Volar Black HD: i2c oops in warm state on mips
References: <4A28CEAD.9000000@gmail.com> <4A293B89.30502@iki.fi> <c4bc83220906091539x51ec2931i9260e36363784728@mail.gmail.com>
In-Reply-To: <c4bc83220906091539x51ec2931i9260e36363784728@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/10/2009 01:39 AM, Jan Nikitenko wrote:
> Solved with "[PATCH] af9015: fix stack corruption bug".

Jan, Thank you very much.

I reviewed your patch and seems to be correct.

This error leads to the zl10353.c and there it was copied to qt1010.c 
and af9015.c.

Probably you want also fix those and pick up credits :)

regards
Antti
-- 
http://palosaari.fi/
