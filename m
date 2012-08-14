Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab2HNJUW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 05:20:22 -0400
Message-ID: <502A1890.2050803@redhat.com>
Date: Tue, 14 Aug 2012 11:21:20 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"Igor M. Liplianin" <liplianin@me.by>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Copyright issues, do not copy code and add your own copyrights
References: <CAHFNz9+H9=NJSB6FY7i5bJPhXQL-eCpmomBCqi14hca2q-wVvg@mail.gmail.com>
In-Reply-To: <CAHFNz9+H9=NJSB6FY7i5bJPhXQL-eCpmomBCqi14hca2q-wVvg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 08/14/2012 11:10 AM, Manu Abraham wrote:
> Hi,
>
> The subject line says it.
>
> Please fix the offending Copyright header.
>
> Offending one.
> http://git.linuxtv.org/media_tree.git/blob/staging/for_v3.7:/drivers/media/dvb-frontends/stb6100_proc.h
>
> Original one.
> http://git.linuxtv.org/media_tree.git/blob/staging/for_v3.7:/drivers/media/dvb-frontends/stb6100_cfg.h

Or even better, get rid of the offending one and add a i2c_gate_ctrl parameters to the inline
functions defined in stb6100_cfg.h, as this seems a typical case of unnecessary code-duplication.

I would also like to point out that things like these are pretty much wrong:

   27         if (&fe->ops)
   28                 frontend_ops = &fe->ops;
   29         if (&frontend_ops->tuner_ops)
   30                 tuner_ops = &frontend_ops->tuner_ops;
   31         if (tuner_ops->get_state) {

The last check de-references tuner_ops, which only is non-NULL if
fe-ops and fe->ops->tuner_ops are non NULL. So either the last check
needs to be:
              if (tuner_ops && tuner_ops->get_state) {

Or we assume that fe-ops and fe->ops->tuner_ops are always non NULL
when this helper gets called and all the previous checks can be removed.

Regards,

Hans
