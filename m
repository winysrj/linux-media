Return-path: <linux-media-owner@vger.kernel.org>
Received: from 25.mail-out.ovh.net ([91.121.27.228]:38394 "HELO
	25.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750880Ab0EFFv2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 May 2010 01:51:28 -0400
Message-ID: <4aebc3ee6a3faf76f878df91345fb437.squirrel@webmail.ovh.net>
In-Reply-To: <r2n83bcf6341005050531kd2d65fa8r7598acec1d3df719@mail.gmail.com>
References: <ab0e35f363ecb2b5daa9146745330ef6.squirrel@webmail.ovh.net>
    <r2n83bcf6341005050531kd2d65fa8r7598acec1d3df719@mail.gmail.com>
Date: Thu, 6 May 2010 00:51:26 -0500 (GMT+5)
Subject: Re: [PATCH] tda10048: fix the uncomplete function tda10048_read_ber
From: "Guillaume Audirac" <guillaume.audirac@webag.fr>
To: "Steven Toth" <stoth@kernellabs.com>
Cc: linux-media@vger.kernel.org
Reply-To: guillaume.audirac@webag.fr
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Steven,

> Thanks Guillaume, I have a pile of other patches I'm ready to present
> for merge so I'll pull this into one of my dev trees and present this
> for merge also.... of course, I'll test it first! :)
>
> Thanks again for working on this.

You're welcome. I am just starting reviewing the driver. I have already
noticed a few errors in it. I will keep on sending obvious patches.
I can quickly summarise some of the missing important features:
- missing lock algorithm which should use the SCAN_CPT register to make it
efficient
- missing frequency offset detection (thanks to AUTOOFFSET=1 and OFFSET_F)

-- 
Guillaume

