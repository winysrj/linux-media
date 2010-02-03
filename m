Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932814Ab0BCUkH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2010 15:40:07 -0500
Message-ID: <4B69DF20.50205@redhat.com>
Date: Wed, 03 Feb 2010 18:40:00 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Ringel <stefan.ringel@arcor.de>
CC: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH 9/15] -  tm6000 analog digital switch
References: <4B673790.3030706@arcor.de> <4B673B2D.6040507@arcor.de> <4B675B19.3080705@redhat.com> <4B685FB9.1010805@arcor.de> <4B688507.606@redhat.com> <4B688E41.2050806@arcor.de> <4B689094.2070204@redhat.com> <4B6894FE.6010202@arcor.de> <4B69D83D.5050809@arcor.de> <4B69D8CC.2030008@arcor.de> <4B69DBCC.50108@arcor.de>
In-Reply-To: <4B69DBCC.50108@arcor.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stefan Ringel wrote:

> @@ -994,6 +995,13 @@ static int generic_set_freq(struct dvb_frontend
> *fe, u32 freq /* in HZ */,

Your emailer is damaging the patches. The above should be in the same line,
otherwise the patch won't apply.

It seems that you're using Thunderbird, right?

User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0

You should really read the README.patches (http://linuxtv.org/hg/v4l-dvb/raw-file/tip/README.patches)
before submitting your work. In particular, at the end of Part II, there are the procedures for
submissions via email. It ends with:

" BE CAREFUL: several emailers including Thunderdird breaks long lines, causing
  patch corruption.
  In the specific case of Thunderbird, an extension is needed to send the
  patches, called Asalted Patches:
	https://hg.mozilla.org/users/clarkbw_gnome.org/asalted-patches/"

So, please get the asalted-patches extension, apply it on your Thunderbird, review your patch
series based on the contents of README.patches and re-submit.

-- 

Cheers,
Mauro
