Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:36301 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbbDBXMK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Apr 2015 19:12:10 -0400
Date: Fri, 3 Apr 2015 01:11:34 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [RFC PATCH] ir: add tools for receiving and sending ir
Message-ID: <20150402231134.GA19905@hardeman.nu>
References: <1426801868-855-1-git-send-email-sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1426801868-855-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 19, 2015 at 09:51:08PM +0000, Sean Young wrote:
>Provide simple tools for displaying raw IR and received scancodes, and
>sending them.
>
>Todo:
> - ir-rec cannot enable protocol decoders
> - ir-send should accept scancode on commandline
> - long options
>

Didn't look at it in detail, but I noticed one thing...copyright headers
like this:

>+/*
>+ Copyright (C) 2015 Sean Young <sean@mess.org>
>+ */

Really should specify the license.

