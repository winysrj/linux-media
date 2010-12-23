Return-path: <mchehab@gaivota>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61903 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab0LWSz4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Dec 2010 13:55:56 -0500
Received: by fxm20 with SMTP id 20so7365696fxm.19
        for <linux-media@vger.kernel.org>; Thu, 23 Dec 2010 10:55:54 -0800 (PST)
Date: Thu, 23 Dec 2010 21:55:40 +0300
From: Dan Carpenter <error27@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Srinivasa.Deevi@conexant.com, linux-media@vger.kernel.org
Subject: Re: smatch report: cx231xx: incorrect check in
 cx231xx_write_i2c_data()
Message-ID: <20101223185540.GL1936@bicker>
References: <20101223164347.GA16612@bicker>
 <1293129292.24752.9.camel@morgan.silverblock.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293129292.24752.9.camel@morgan.silverblock.net>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Thu, Dec 23, 2010 at 01:34:52PM -0500, Andy Walls wrote:
> and noting that "req_data->saddr_dat" holds what was "saddr";
> the if statement, and the many others like it, [...]

The others I see are:
cx231xx_write_i2c_data()
cx231xx_read_i2c_data()
cx231xx_write_i2c_master()
cx231xx_read_i2c_master()

regards,
dan carpenter


