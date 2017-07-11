Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:47292 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932462AbdGKRkD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 13:40:03 -0400
Subject: Re: [PATCH] staging: fbtft: make const array gamma_par_mask static
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20170711172002.19757-1-colin.king@canonical.com>
 <20170711173035.GA12352@kroah.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
From: Colin Ian King <colin.king@canonical.com>
Message-ID: <b46c6daf-a31d-3fc9-0319-172b2d14099a@canonical.com>
Date: Tue, 11 Jul 2017 18:39:59 +0100
MIME-Version: 1.0
In-Reply-To: <20170711173035.GA12352@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/07/17 18:30, Greg Kroah-Hartman wrote:
> On Tue, Jul 11, 2017 at 06:20:02PM +0100, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> Don't populate array gamma_par_mask on the stack but instead make it
>> static.  Makes the object code smaller by 148 bytes:
>>
>> Before:
>>    text	   data	    bss	    dec	    hex	filename
>>    2993	   1104	      0	   4097	   1001	drivers/staging/fbtft/fb_st7789v.o
>>
>> After:
>>    text	   data	    bss	    dec	    hex	filename
>>    2757	   1192	      0	   3949	    f6d	drivers/staging/fbtft/fb_st7789v.o
>>
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> ---
>>  drivers/media/usb/gspca/xirlink_cit.c | 2 +-
>>  drivers/staging/fbtft/fb_st7789v.c    | 2 +-
>>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> Your subject doesn't match the patch :(

Got distracted by the Trump Jnr tweet. Will resend.

> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
