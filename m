Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:47077 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753940Ab1EVDB4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 May 2011 23:01:56 -0400
References: <65DE7931C559BF4DBEE42C3F8246249A0B686EB0@V-EXMAILBOX.ctg.com> <8AFBEFD7-69E3-4E71-B155-EA773C2FED43@wilsonet.com> <65DE7931C559BF4DBEE42C3F8246249A0B69B014@V-ALBEXCHANGE.ctg.com> <EC37FC85-82B2-48AE-BB94-64ED00E7647D@wilsonet.com> <93CE8497-D6AB-43BA-A239-EE32D51582FC@wilsonet.com> <65DE7931C559BF4DBEE42C3F8246249A0B6A54C7@V-ALBEXCHANGE.ctg.com>,<1294875902.2485.19.camel@morgan.silverblock.net> <65DE7931C559BF4DBEE42C3F8246249A0B6A9B4A@V-ALBEXCHANGE.ctg.com> <65DE7931C559BF4DBEE42C3F8246249A2AB1230E@V-EXMAILBOX.ctg.com> <65DE7931C559BF4DBEE42C3F8246249A2AB13455@V-EXMAILBOX.ctg.com> <65DE7931C559BF4DBEE42C3F8246249A2AB1470A@V-EXMAILBOX.ctg.com>
In-Reply-To: <65DE7931C559BF4DBEE42C3F8246249A2AB1470A@V-EXMAILBOX.ctg.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: RE: [SOLVED] Enable IR on hdpvr
From: Andy Walls <awalls@md.metrocast.net>
Date: Sat, 21 May 2011 23:02:03 -0400
To: Jason Gauthier <jgauthier@lastar.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <8a8e1761-e060-4e3f-84bb-b04fdf5e55c5@email.android.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Jason Gauthier <jgauthier@lastar.com> wrote:

>All,
>
>
>>Okay, so I emailed a little too quickly.  The messages above got me
>thinking.  One of them is successful the other is not.
>>I verified with irsend.  So, this may be an issue with multiple
>hdpvrs.
>
>I believe I've tracked this down.  
>
>In lirc_zilog.c:
>
> At 1307:
>                ret = add_ir_device(ir);
>                if (ret)
>                        goto out_free_ir;
>
>Looking at add_ir_device:
>  It returns:
>
>	 return i == MAX_IRCTL_DEVICES ? -ENOMEM : i;
>
>Meaning, that with a single device, it will generally return 0. 
>However, if there are multiple devices it will return a positive. This
>causes the return check to succeeed, and the goto out_free_ir, and
>basically doesn't continue.
>
>So, simply changing the check to if (ret<0) seems to resolve this. 
>Then if -ENOMEM is returned it will fail, and otherwise succeed.
>
>Sorry, this is not an official patch.  The maintainer (Jarod?) should
>be able to see what I am talking about and correct this.
>
>Thanks!
>
>Jasoin
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

I think you're using a borken version.  Are you using this one with all the ref counting fixes?

http://git.linuxtv.org/media_tree.git?a=blob;f=drivers/staging/lirc/lirc_zilog.c;h=dd6a57c3c3a3149bac53eb36fd4ddeabed804050;hb=HEAD

Regards,
Andy
