Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:54921 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726519AbeLACRZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Nov 2018 21:17:25 -0500
Date: Fri, 30 Nov 2018 16:07:46 +0100
From: Andreas Pape <ap@ca-pape.de>
To: kieran.bingham@ideasonboard.com
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] media: stkwebcam: Support for ASUS A6VM notebook
 added.
Message-Id: <20181130160746.60dfbd61904af39882228543@ca-pape.de>
In-Reply-To: <ca22a6ae-f17a-8158-99af-376657adf730@ideasonboard.com>
References: <20181123161454.3215-1-ap@ca-pape.de>
        <20181123161454.3215-2-ap@ca-pape.de>
        <ca22a6ae-f17a-8158-99af-376657adf730@ideasonboard.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Keiran,

thanks for the review.

On Mon, 26 Nov 2018 12:48:53 +0000
Kieran Bingham <kieran.bingham@ideasonboard.com> wrote:

> 
> I guess these strings match the strings produced by dmi-decode on your
> laptop?
>

I didn't use dmidecode but I read the values from /sys/class/dmi/sys_vendor and
/sys/class/dmi/product_name accordingly.

Kind regards,
Andreas
