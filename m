Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0096.hostedemail.com ([216.40.44.96]:47607 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752748AbdF2NaV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Jun 2017 09:30:21 -0400
Message-ID: <1498743016.8633.14.camel@perches.com>
Subject: Re: [PATCH] drivers/staging/media:  Prefer using  __func__ instead
From: Joe Perches <joe@perches.com>
To: Pushkar Jambhlekar <pushkar.iit@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tamara Diaconita <diaconitatamara@gmail.com>,
        Jasmin Jessich <jasmin@anw.at>,
        Ralph Metzler <rjkm@metzlerbros.de>,
        Eva Rachel Retuya <eraretuya@gmail.com>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Thu, 29 Jun 2017 06:30:16 -0700
In-Reply-To: <1498735766-3068-1-git-send-email-pushkar.iit@gmail.com>
References: <1498735766-3068-1-git-send-email-pushkar.iit@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2017-06-29 at 16:59 +0530, Pushkar Jambhlekar wrote:
> Function name is hardcoded. replacing with __func__

Please run your proposed patches through checkpatch
before you send them.

> diff --git a/drivers/staging/media/cxd2099/cxd2099.c b/drivers/staging/media/cxd2099/cxd2099.c
[]
> @@ -100,7 +100,7 @@ static int i2c_read_reg(struct i2c_adapter *adapter, u8 adr,
>  				   .buf = val, .len = 1} };
>  
>  	if (i2c_transfer(adapter, msgs, 2) != 2) {
> -		dev_err(&adapter->dev, "error in i2c_read_reg\n");
> +		dev_err(&adapter->dev, "error in %s\n", __func__);
>  		return -1;
>  	}
>  	return 0;
> @@ -115,7 +115,7 @@ static int i2c_read(struct i2c_adapter *adapter, u8 adr,
>  				   .buf = data, .len = n} };
>  
>  	if (i2c_transfer(adapter, msgs, 2) != 2) {
> -		dev_err(&adapter->dev, "error in i2c_read\n");
> +		dev_err(&adapter->dev, "error in %s\n",__func__);

There is a missing space before __func__.

As well, the form for listing a function name
is generally:

	print("%s: <error description>\n", __func__);

so ideally, these messages would be something like:

		dev_err(&adapter->dev, "%s: i2c_transfer error\n", __func__);
