Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:57298 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab0C2VnE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Mar 2010 17:43:04 -0400
Date: Mon, 29 Mar 2010 23:38:57 +0200
From: Janne Grunau <j@jannau.net>
To: =?utf-8?B?VG9tw6HFoSBTa2/EjWRvcG9sZQ==?=
	<tomas.skocdopole@ippolna.cz>
Cc: linux-media@vger.kernel.org
Subject: Re: Module option adapter_nr
Message-ID: <20100329213857.GE8039@aniel.lan>
References: <b8a3b1ca1003290841h68e4b109nd7e095393518ba63@mail.gmail.com>
 <b8a3b1ca1003291141t2cbc05c4o6be1574da798a084@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b8a3b1ca1003291141t2cbc05c4o6be1574da798a084@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Mon, Mar 29, 2010 at 08:41:08PM +0200, Tomáš Skočdopole wrote:
> 
> I am using the Archlinux distribution and i have four Skystar HD2
> cards and one Airstar DVB card in my system.
> I want to specify adapter numbers for this cards. Order of DVB-S2
> cards is not important.
> 
> So I add this lines into /etc/modprobe.d/modprobe.conf
> options b2c2-flexcop adapter_nr=0
> options mantis-core adapter_nr=11,12,13,14
> 
> But with no results.

DVB core supports by default only 8 adapters. have you tried 
options mantis-core adapter_nr=4,5,6,7
?

The code in mantis-dvb.c in Linus' repo looks correct.

Janne
