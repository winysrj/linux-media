Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:42962 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbZC0TIx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 15:08:53 -0400
Date: Fri, 27 Mar 2009 20:01:06 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Alexey Klimov <klimov.linux@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [patch review] gspca - mr97310a: return error instead of -1 in
 sd_mod_init
Message-ID: <20090327200106.7cae9bec@free.fr>
In-Reply-To: <1238170102.3791.8.camel@tux.localhost>
References: <1238170102.3791.8.camel@tux.localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 27 Mar 2009 19:08:22 +0300
Alexey Klimov <klimov.linux@gmail.com> wrote:

> Hello, Jean-Francois
> 
> What do you think about such small cleanup ?
> 
> ---
> Patch reformats sd_mod_init in the way to make it return error code
> from usb_register instead of -1.
> 
> Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>
	[snip]

Applied. Thanks.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
