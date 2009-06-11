Return-path: <linux-media-owner@vger.kernel.org>
Received: from n8a.bullet.mail.mud.yahoo.com ([209.191.87.104]:38997 "HELO
	n8a.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751711AbZFKU34 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 16:29:56 -0400
From: David Brownell <david-b@pacbell.net>
To: davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH 7/10 - v2] DM355 platform changes for vpfe capture driver
Date: Thu, 11 Jun 2009 13:23:55 -0700
Cc: m-karicheri2@ti.com, linux-media@vger.kernel.org,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>
References: <1244739649-27466-1-git-send-email-m-karicheri2@ti.com> <1244739649-27466-7-git-send-email-m-karicheri2@ti.com> <1244739649-27466-8-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1244739649-27466-8-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200906111323.56119.david-b@pacbell.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 11 June 2009, m-karicheri2@ti.com wrote:
> +               I2C_BOARD_INFO("tvp5146", TVP5146_I2C_ADDR),

Minor nit:  just use "0x5d" instead of defining TVP5146_I2C_ADDR.
Fix in a v3, iff you make one.

