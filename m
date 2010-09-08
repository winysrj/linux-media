Return-path: <mchehab@pedra>
Received: from mx06.syd.iprimus.net.au ([210.50.76.235]:56252 "EHLO
	mx06.syd.iprimus.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab0IHVoZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Sep 2010 17:44:25 -0400
From: Mike Booth <mike_booth76@iprimus.com.au>
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] [Patch] Correct Signal Strength values for STB0899
Date: Thu, 9 Sep 2010 07:33:19 +1000
References: <664886.22288.qm@web29509.mail.ird.yahoo.com>
In-Reply-To: <664886.22288.qm@web29509.mail.ird.yahoo.com>
Cc: Goga777 <goga777@bk.ru>,
	Newsy Paper <newspaperman_germany@yahoo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009090733.21145.mike_booth76@iprimus.com.au>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Thu, 9 Sep 2010 03:51:06 you wrote:
> thx Goga and thx to dimka_9 for his great work.
> 
> I hope those guys will include it in the driver
> 
> regards
> 
> Newsy
> 
> --- Goga777 <goga777@bk.ru> schrieb am Mi, 8.9.2010:
> > Von: Goga777 <goga777@bk.ru>
> > Betreff: Re: [linux-dvb] [Patch] Correct Signal Strength values for
> > STB0899 An: linux-dvb@linuxtv.org
> > CC: linux-media@vger.kernel.org
> > Datum: Mittwoch, 8. September, 2010 19:47 Uhr
> > 
> > > first of all I have to say that
> > 
> > this patch is not from me.
> > 
> > > It's from rotor-0.1.4mh-v1.2.tar.gz
> > > Thx to the author of that patch and the modified rotor
> > 
> > Plugin. I think he's a friend of Mike Booth
> > 
> > > I think it should be included into s2-liplianin.
> > > With this patch all dvb-s and dvb-s2 signal strength
> > 
> > values are scaled correctly.
> > 
> > 
> > FYI - this patch from Russian DVB VDR forum. Author is
> > dimka_9
> > http://linuxdvb.org.ru/wbb/index.php?page=Thread&postID=11883#post11883
> > 
> > 
> > Goga
> > 
> > _______________________________________________
> > linux-dvb users mailing list
> > For V4L/DVB development, please use instead linux-media@vger.kernel.org
> > linux-dvb@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


We ( Mark and I) have been using dmka_9s patch for some months now haviong 
included it in rotor.

It works fine here and should be include inthe driver.

PS has anyone been able to fix BER and UNC?

Refard

Mike
