Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28527 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaETMCI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 May 2014 08:02:08 -0400
Date: Tue, 20 May 2014 15:01:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Antti Palosaari <crope@iki.fi>
Cc: kbuild@01.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [linuxtv-samsung:for-v3.16 45/81]
 drivers/media/dvb-frontends/si2168.c:47 si2168_cmd_execute() warn: add some
 parenthesis here?
Message-ID: <20140520120141.GE17724@mwanda>
References: <20140505190256.GP4963@mwanda>
 <5367FA1E.9030800@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5367FA1E.9030800@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 05, 2014 at 11:52:46PM +0300, Antti Palosaari wrote:
> >845f3505 Antti Palosaari 2014-04-10  46
> >845f3505 Antti Palosaari 2014-04-10 @47  		if (!(cmd->args[0] >> 7) & 0x01) {
> >
> >This should be:						if (!((md->args[0] >> 7) & 0x01)) {
> >Otherwise it is a precedence error where it does the negate before the
> >bitwise AND.
> 
> That was already on my TODO list as daily media build test sparse
> warned it already http://hverkuil.home.xs4all.nl/logs/Monday.log
> 
> I am waiting for media/master kernel upgrades from 3.15-rc1 as that
> kernel will hang whole machine when em28xx driver used (em28xx
> driver is USB bridge for those si2168 and si2157).
> 

Wait, what?  This is a one liner.  I haven't understood the connection
with 3.15-rc1?

regards,
dan carpenter

