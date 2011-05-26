Return-path: <mchehab@pedra>
Received: from smtp5-g21.free.fr ([212.27.42.5]:60663 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487Ab1EZGrm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 May 2011 02:47:42 -0400
Date: Thu, 26 May 2011 08:48:15 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Petter Selasky <hselasky@c2i.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Make nchg variable signed because the code compares
 this variable against negative values.
Message-ID: <20110526084815.48a35684@tele>
In-Reply-To: <4DDD99B5.2050105@redhat.com>
References: <201105231309.54265.hselasky@c2i.net>
	<4DDD99B5.2050105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 25 May 2011 21:07:17 -0300
Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> This patch looks ok to me, although the description is not 100%. 
> 
> The sonixj driver compares the value for nchg with
> 		if (sd->nchg < -6 || sd->nchg >= 12) {
> 
> With u8, negative values won't work.
> 
> Please check.

Hi Mauro and Hans Petter,

With all the messages in the list, I did not noticed this patch.

Indeed, the fix is correct. I was wondering why there were still
problems with the image size in sonixj. They should disappear now.

Thanks.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
