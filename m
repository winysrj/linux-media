Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:51501 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbaFPMdf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jun 2014 08:33:35 -0400
Received: by mail-la0-f45.google.com with SMTP id hr17so561461lab.4
        for <linux-media@vger.kernel.org>; Mon, 16 Jun 2014 05:33:34 -0700 (PDT)
Message-ID: <539EE41D.3050206@cogentembedded.com>
Date: Mon, 16 Jun 2014 16:33:33 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Ben Dooks <ben.dooks@codethink.co.uk>,
	linux-kernel@lists.codethink.co.uk, linux-sh@vger.kernel.org,
	linux-media@vger.kernel.org
CC: robert.jarzmik@free.fr, g.liakhovetski@gmx.de,
	magnus.damm@opensource.se, horms@verge.net.au,
	ian.molton@codethink.co.uk, william.towle@codethink.co.uk
Subject: Re: [PATCH 2/9] ARM: lager: add i2c1, i2c2 pins
References: <1402862194-17743-1-git-send-email-ben.dooks@codethink.co.uk> <1402862194-17743-3-git-send-email-ben.dooks@codethink.co.uk>
In-Reply-To: <1402862194-17743-3-git-send-email-ben.dooks@codethink.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 06/15/2014 11:56 PM, Ben Dooks wrote:

> Add pinctrl definitions for i2c1 and i2c2 busses on the Lager board
> to ensure these are setup correctly at initialisation time. The i2c0
> and i2c3 busses are connected to single function pins.

> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>

    Likewise, this as been already merged by Simon.

WBR, Sergei

