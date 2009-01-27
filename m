Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.work.de ([212.12.32.20]:48412 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbZA0Vpc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2009 16:45:32 -0500
Message-ID: <497F8077.1030800@gmail.com>
Date: Wed, 28 Jan 2009 01:45:27 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Technotrend Budget S2-3200 Digital artefacts	on	HDchannels
References: <640929.18092.qm@web23204.mail.ird.yahoo.com>	<157f4a8c0901260739p424a74f6rcca2d84df04737b9@mail.gmail.com>	<157f4a8c0901260741l4d263b8bk6e34cb5bb56d8c2@mail.gmail.com>	<c74595dc0901260744i32d7deeg9a5219faca10dc93@mail.gmail.com>	<157f4a8c0901260751l39214908ydfeed5ba12b4d48b@mail.gmail.com>	<157f4a8c0901260808i39b784f6m13db53db2f135a37@mail.gmail.com>	<c74595dc0901260819g22f690d1qe809808eacb829da@mail.gmail.com>	<1a297b360901260950r599b944aoea24dcbdecbc9515@mail.gmail.com>	<c74595dc0901261107i66125bfdpe35cb7b89144ab11@mail.gmail.com>	<497F6B2E.6010305@gmail.com>	<c74595dc0901271240i2008cacdp565fe69f3269ea55@mail.gmail.com> <497F7C40.6030300@gmail.com>
In-Reply-To: <497F7C40.6030300@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Manu Abraham wrote:

> For a lower sampling frequency (aka Symbol rate), you need a higher
> clock and or higher time period. For higher sampling rates (Symbol
> Rates) the the master clock has to be decimated to  avoid overflows

Sorry, an error in one part. ^^

For a lower SRATE, you need a lower clock and a longer period of
time. With a higher SRATE for the same coeffecients, you are bound
to overflow, unless you decimate certain register contents.
Recalculating those register values are quite tedious and lots of
calculations involved for a different master clock.

The result with a higher master clock (with the same coeffecients),
if you happened to see some positive results, it was the result of
some overflow or underflow, which is for sure.

Manu



