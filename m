Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36381 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbaAHK3X (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 05:29:23 -0500
Received: by mail-ob0-f174.google.com with SMTP id wn1so1486247obc.33
        for <linux-media@vger.kernel.org>; Wed, 08 Jan 2014 02:29:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140108090942.GA28296@elgon.mountain>
References: <20140108090942.GA28296@elgon.mountain>
Date: Wed, 8 Jan 2014 15:59:22 +0530
Message-ID: <CAK9yfHwvwjEpm6EhVcqNAO=a1R59+TzXOMgaEQ9N_vEpAAcOfg@mail.gmail.com>
Subject: Re: [media] Add driver for Samsung S5K5BAF camera sensor
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dan,

On 8 January 2014 14:39, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> Hello Andrzej Hajda,
>
> This is a semi-automatic email about new static checker warnings.
>
> The patch 7d459937dc09: "[media] Add driver for Samsung S5K5BAF
> camera sensor" from Dec 5, 2013, leads to the following Smatch
> complaint:
>
> drivers/media/i2c/s5k5baf.c:554 s5k5baf_fw_get_seq()
>          warn: variable dereferenced before check 'fw' (see line 551)
>
> drivers/media/i2c/s5k5baf.c
>    550          struct s5k5baf_fw *fw = state->fw;
>    551          u16 *data = fw->data + 2 * fw->count;
>                                            ^^^^^^^^^
> Dereference.
>
>    552          int i;
>    553
>    554          if (fw == NULL)
>                     ^^^^^^^^^^
> Check.
>
>    555                  return NULL;
>    556
>

A patch [1] to fix this has already been queued up by Mauro.

[1] https://linuxtv.org/patch/21292/

-- 
With warm regards,
Sachin
