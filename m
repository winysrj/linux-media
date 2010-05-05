Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f191.google.com ([209.85.221.191]:39583 "EHLO
	mail-qy0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934492Ab0EEMib (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 May 2010 08:38:31 -0400
Received: by qyk29 with SMTP id 29so7451109qyk.14
        for <linux-media@vger.kernel.org>; Wed, 05 May 2010 05:38:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ab0e35f363ecb2b5daa9146745330ef6.squirrel@webmail.ovh.net>
References: <ab0e35f363ecb2b5daa9146745330ef6.squirrel@webmail.ovh.net>
Date: Wed, 5 May 2010 08:31:20 -0400
Message-ID: <r2n83bcf6341005050531kd2d65fa8r7598acec1d3df719@mail.gmail.com>
Subject: Re: [PATCH] tda10048: fix the uncomplete function tda10048_read_ber
From: Steven Toth <stoth@kernellabs.com>
To: guillaume.audirac@webag.fr
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Completes the bit-error-rate read function with the CBER register (before
> Viterbi decoder). The returned value is 1e8*actual_ber to be positive.
> Also includes some typo mistakes.
>
> Signed-off-by: Guillaume Audirac <guillaume.audirac@webag.fr>

Thanks Guillaume, I have a pile of other patches I'm ready to present
for merge so I'll pull this into one of my dev trees and present this
for merge also.... of course, I'll test it first! :)

Thanks again for working on this.

Regards,

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
