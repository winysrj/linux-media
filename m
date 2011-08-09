Return-path: <linux-media-owner@vger.kernel.org>
Received: from stevekez.vm.bytemark.co.uk ([80.68.91.30]:51435 "EHLO
	stevekerrison.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab1HIK5Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Aug 2011 06:57:24 -0400
Subject: Re: Anyone tested the DVB-T2 dual tuner TBS6280?
From: Steve Kerrison <steve@stevekerrison.com>
To: Harald Gustafsson <hgu1972@gmail.com>
Cc: mythtv-users@mythtv.org, linux-media@vger.kernel.org
In-Reply-To: <CAC3jWv+c1HOqmo0B18Z3vWOwjr=RoPrN7sfR3bqzz4Tw7=fPAQ@mail.gmail.com>
References: <CAC3jWv+c1HOqmo0B18Z3vWOwjr=RoPrN7sfR3bqzz4Tw7=fPAQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Aug 2011 11:57:19 +0100
Message-ID: <1312887439.2249.38.camel@ares>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Harald,

Currently the controller chip on the BlackGold card is unsupported - I
don't know if there's any development work going on for that in this
arena or if perhaps BlackGold are working on something themselves.
Perhaps somebody else here knows the full story.

This TBS card has only just been brought to my attention. I cannot tell
what PCIe chip it uses and if it's supported. The alleged Linux driver
download for it doesn't have the cxd2820r code in it, so I can't see
that having much chance of working.

Perhaps ask TBS directly what the status on this one is? I don't know of
anybody who has used it yet (even in Windows).

Regards,
-- 
Steve Kerrison MEng Hons.
http://www.stevekerrison.com/ 

On Tue, 2011-08-09 at 12:35 +0200, Harald Gustafsson wrote:
> Hi,
> 
> I searched for a dual tuner PCI-e DVB-T2 card with Linux support and
> found this TBS6280 card:
> http://tbsdvb.blog.com/2011/07/22/tbs-6280-freeview-hd-twin-tuner-card/
> http://www.buydvb.net/tbs6280-pcie-dvbt2t-dual-tuner-card_p38.html
> http://www.tbsdtv.com/english/Download.html
> 
> Previously I have only found the blackgold product that state they
> will have Linux support but have not seen any drivers yet.
> 
> But when searching the mythtv lists and the linux dvb list I could not
> find anyone using it. Do anyone have any info about this card, does it
> work well with terrestrial DVB-T2 reception, is linux support working,
> does it work with mythtv, etc.
> 
> /Harald
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

