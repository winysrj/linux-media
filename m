Return-path: <linux-media-owner@vger.kernel.org>
Received: from 30.mail-out.ovh.net ([213.186.62.213]:42770 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751176Ab0FUHGX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jun 2010 03:06:23 -0400
Message-ID: <4C1F0DDC.4070307@ventoso.org>
Date: Mon, 21 Jun 2010 08:59:40 +0200
From: Luca Olivetti <luca@ventoso.org>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@kernellabs.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] af9005: use generic_bulk_ctrl_endpoint_response
References: <AANLkTimtPb6A5Cd6mB2z3S5U2uZy0l4fkbVyyL3njizs@mail.gmail.com>
In-Reply-To: <AANLkTimtPb6A5Cd6mB2z3S5U2uZy0l4fkbVyyL3njizs@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

En/na Michael Krufky ha escrit:
> Could somebody please test this patch and confirm that it doesn't
> break the af9005 support?
> 
> This patch removes the af9005_usb_generic_rw function and uses the
> dvb_usb_generic_rw function instead, using
> generic_bulk_ctrl_endpoint_response to differentiate between the read
> pipe and the write pipe.

Unfortunately I cannot test it (my device is broken)[*].
At the time I wrote my own rw function because I didn't find a way to 
send on a bulk endpoint and receiving on another one (i.e. I didn't know 
about generic_bulk_ctrl_endpoint/generic_bulk_ctrl_endpoint_response or 
they weren't available at the time).

[*]Actually the tuner is broken, but the usb is working fine, so maybe I 
can give it a try.

Bye
-- 
Luca
