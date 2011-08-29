Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:35768 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753760Ab1H2Rw1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Aug 2011 13:52:27 -0400
Date: Mon, 29 Aug 2011 19:52:44 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Luiz Ramos <lramos.prof@yahoo.com.br>, linux-media@vger.kernel.org
Subject: Re: [git:v4l-dvb/for_v3.2] [media] Fix wrong register mask in
 gspca/sonixj.c
Message-ID: <20110829195244.183d4e08@tele>
In-Reply-To: <1314637046.40286.YahooMailClassic@web121807.mail.ne1.yahoo.com>
References: <E1QxHW0-0002rG-Ur@www.linuxtv.org>
	<1314637046.40286.YahooMailClassic@web121807.mail.ne1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 29 Aug 2011 09:57:26 -0700 (PDT)
Luiz Ramos <lramos.prof@yahoo.com.br> wrote:

> Mauro:
> 
> To be fair, this patch itself isn't sufficient to solve the problem described in the text provided. One other patch is necessary to get this goal accomplished, named, one published in this same thread in 2011-07-18.
> 
> This later fix is now embedded in a wider patch provided by Jean-François Moine in 2011-08-10.
> 
> I'd suggest to change the text below, if possible, mentioning only something like "fix wrong register masking".

Hi Mauro,

Sorry, I did not notice the automatic commit report.

I submitted Luiz's patch and the darkness fix in 2 git patch requests
on Wed, 10 Aug for 3.1 and on Fri, 12 Aug for 3.2:

gspca - sonixj: Fix wrong register mask for sensor om6802
gspca - sonixj: Fix the darkness of sensor om6802 in 320x240

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
