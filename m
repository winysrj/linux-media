Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35815 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751628AbdEDTew (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 May 2017 15:34:52 -0400
Subject: Re: [media-s3c-camif] question about arguments position
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
References: <20170504140502.Horde.e_TqvS0_CEqTDsNh1soDOGo@gator4166.hostgator.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Message-ID: <e2137221-f094-530b-e61c-70e28f22a83f@gmail.com>
Date: Thu, 4 May 2017 21:34:47 +0200
MIME-Version: 1.0
In-Reply-To: <20170504140502.Horde.e_TqvS0_CEqTDsNh1soDOGo@gator4166.hostgator.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gustavo,

On 05/04/2017 09:05 PM, Gustavo A. R. Silva wrote:
> The issue here is that the position of arguments in the call to
> camif_hw_set_effect() function do not match the order of the parameters:
> 
> camif->colorfx_cb is passed to cr
> camif->colorfx_cr is passed to cb
> 
> This is the function prototype:
> 
> void camif_hw_set_effect(struct camif_dev *camif, unsigned int effect,
>             unsigned int cr, unsigned int cb)
> 
> My question here is if this is intentional?
> 
> In case it is not, I will send a patch to fix it. But first it would be
> great to hear any comment about it.

You are right, it seems you have found a real bug. Feel free to send a patch.
The best thing to do now might be to change the function prototype to:

void camif_hw_set_effect(struct camif_dev *camif, unsigned int effect,
             unsigned int cb, unsigned int cr)

--
Regards,
Sylwester
