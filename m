Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbaBWWEc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Feb 2014 17:04:32 -0500
Message-ID: <530A706A.9030903@redhat.com>
Date: Sun, 23 Feb 2014 23:04:26 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>, moinejf@free.fr
CC: linux-media@vger.kernel.org
Subject: Re: [media] gspca - topro: New subdriver for Topro webcams
References: <20140130121408.GB17753@elgon.mountain>
In-Reply-To: <20140130121408.GB17753@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 01/30/2014 01:14 PM, Dan Carpenter wrote:
> Hello Jean-François Moine,
> 
> The patch 8f12b1ab2fac: "[media] gspca - topro: New subdriver for
> Topro webcams" from Sep 22, 2011, leads to the following
> static checker warning:
> 	drivers/media/usb/gspca/topro.c:4642
> 	sd_pkt_scan() warn: check 'data[]' for negative offsets s32min"
> 
> drivers/media/usb/gspca/topro.c
>   4632                  data++;
> 
> Should there be an "if (len < 8) return;" here?


Thanks for the report, there were indeed several missing length
checks in the packet parsing code in topro.c

I've added a patch fixing this to my gspca tree for 3.15 .

Regards,

Hans
