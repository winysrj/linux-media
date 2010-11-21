Return-path: <mchehab@gaivota>
Received: from lo.gmane.org ([80.91.229.12]:37645 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532Ab0KUPqu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Nov 2010 10:46:50 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1PKC7s-0004TO-Pb
	for linux-media@vger.kernel.org; Sun, 21 Nov 2010 16:46:48 +0100
Received: from 60.52.96.29 ([60.52.96.29])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 21 Nov 2010 16:46:48 +0100
Received: from bahathir by 60.52.96.29 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 21 Nov 2010 16:46:48 +0100
To: linux-media@vger.kernel.org
From: Mohammad Bahathir Hashim <bahathir@gmail.com>
Subject: Re: For those that uses Pinnacle PCTV 340e
Date: Sun, 21 Nov 2010 15:46:36 +0000 (UTC)
Message-ID: <icbess$jj2$1@dough.gmane.org>
References: <AANLkTinWJu92nCR4vHUO3MWZp_ipNZL8LzpYrU4GDj7U@mail.gmail.com>
 <ibqclc$q5u$1@dough.gmane.org>
 <AANLkTi=iLjVzq2T61FkPEEMdPKXd6L9Va5_L0JjkhN5J@mail.gmail.com>
Reply-To: Mohammad Bahathir Hashim <bahathir@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

>
> Tried "your" code today and it works slightly better since the tuner
> still works after a reboot.
> The remote stops working tho. I get this in dmesg: "dib0700: rc submit
> urb failed".
>
> Can't say I notice any difference on how warm it becomes tho.
>
> /Magnus Alm

Thank you for trying the patch.  The patch is just a quick and simple
patch, to make xc4000 works with linux 2.6.35, and I only just want to
make sure the DVB feature is up and running. I remembered that Devin
had said something about RC polling, which make the 'load' getting
high (1.00) eventhough the system proccesses are in idle or sleeping. 

In my case, the PCTV 340e dongle is cooler when it is in idle; ie, not
streaming to the host; compared to the original xc4000 driver.

One more thing is, the SNR, signal strength, ... are quite not reported
correctly. if you use 'femon -H'.

I really hope other experienced developers can take a look into the
code, and make it better compability with current kernel. :)


Thank you very much.

