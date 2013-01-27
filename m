Return-path: <linux-media-owner@vger.kernel.org>
Received: from impaqm4.telefonica.net ([213.4.138.20]:28262 "EHLO
	telefonica.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754742Ab3A0AKd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jan 2013 19:10:33 -0500
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: Antti Palosaari <crope@iki.fi>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Add lock to af9035 driver for dual mode
Date: Sun, 27 Jan 2013 01:10:26 +0100
Message-ID: <2105558.TtkZgv1BCF@jar7.dominio>
In-Reply-To: <5100F440.90302@iki.fi>
References: <45300900.lplt0zG7i2@jar7.dominio> <1411603.1yOyLSGzvX@jar7.dominio> <5100F440.90302@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Jueves, 24 de enero de 2013 10:43:44 Antti Palosaari escribió:
> On 01/24/2013 02:15 AM, Jose Alberto Reguero wrote:
> > On Jueves, 24 de enero de 2013 00:36:25 Antti Palosaari escribió:
> >> On 01/24/2013 12:34 AM, Jose Alberto Reguero wrote:
> >>> Add lock to af9035 driver for dual mode.
> >> 
> >> May I ask why you do that?
> >> 
> >> regards
> >> Antti
> > 
> > Just to avoid interference between the two demods.
> > 
> > Jose Alberto
> 
> ... and how you can see that interference? What should I do that I can
> see these problems you are trying to fix with that patch.
> 
> regards
> Antti

It is not to fix any real problem. It is to avoid concurrent access to both 
demods to prevent bad effects.

Jose Alberto


