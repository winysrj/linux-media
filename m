Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:33112 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbZKELTJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Nov 2009 06:19:09 -0500
Date: Thu, 5 Nov 2009 12:19:06 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] gspca pac7302/pac7311: fix buffer overrun
Message-ID: <20091105121906.46ea011d@tele>
In-Reply-To: <4AF20272.7040104@freemail.hu>
References: <4AF20272.7040104@freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 04 Nov 2009 23:38:42 +0100
Németh Márton <nm127@freemail.hu> wrote:

> The reg_w_seq() function expects the sequence length in entries
> and not in bytes. One entry in init_7302 and init_7311 is two
> bytes and not one.
> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>
> ---
> diff -upr a/drivers/media/video/gspca/pac7302.c
> b/drivers/media/video/gspca/pac7302.c
	[snip]

Hello Németh,

Thank you for the patch! The bug did exist for a long time, and nobody
found it yet.

I have just a remark: some of your patches have a diff starting with
'a/drivers/..'. They should start with 'a/linux/drivers/..' (as done by
'hg export').

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
