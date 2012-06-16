Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53398 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276Ab2FPQDI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jun 2012 12:03:08 -0400
Received: by obbtb18 with SMTP id tb18so5677445obb.19
        for <linux-media@vger.kernel.org>; Sat, 16 Jun 2012 09:03:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120616133512.GB13539@mwanda>
References: <20120616131611.GA17802@elgon.mountain>
	<20120616133512.GB13539@mwanda>
Date: Sat, 16 Jun 2012 13:03:07 -0300
Message-ID: <CALF0-+U6ttGwXiQgmXO6b6T_HyZA079+L=C=X2ZQi++2eOG6Hw@mail.gmail.com>
Subject: Re: V4L/DVB (12730): Add conexant cx25821 driver
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
	mchehab@redhat.com, linux-media <linux-media@vger.kernel.org>,
	stoth@kernellabs.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,

On Sat, Jun 16, 2012 at 10:35 AM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:
>
> Hm...  There are several more places which have this same problem.
> I'm not sure what's going on here.
>
> drivers/media/video/saa7164/saa7164-i2c.c:112 saa7164_i2c_register() error: memcpy() '&saa7164_i2c_algo_template' too small (24 vs 64)

I was just looking at that lines in saa7164_i2c_register:

112         memcpy(&bus->i2c_algo, &saa7164_i2c_algo_template,
113                sizeof(bus->i2c_algo));

They seem like pointless to me. The real algo is set here:

 93 static struct i2c_adapter saa7164_i2c_adap_template = {
 94         .name              = "saa7164",
 95         .owner             = THIS_MODULE,
 96         .algo              = &saa7164_i2c_algo_template,
 97 };

This would also mean that this fields are also pointless:

254         struct i2c_algo_bit_data        i2c_algo;
255         struct i2c_client               i2c_client;

IMO, the issue pointed out by Dan would never appeared
if instead of using memcpy to fill the structures, it would just
get assigned; it's type safe, right?

Please correct me if I'm wrong,
Ezequiel.
