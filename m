Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpo01.poczta.onet.pl ([213.180.142.132]:33219 "EHLO
	smtpo01.poczta.onet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab1JRRU1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Oct 2011 13:20:27 -0400
Date: Tue, 18 Oct 2011 19:20:19 +0200
From: Piotr Chmura <chmooreck@poczta.onet.pl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Greg KH <gregkh@suse.de>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org
Subject: Re: [PATCH 0/14] staging/media/as102: new driver submission (was
 Re: [PATCH 1/7] Staging submission: PCTV 74e driver (as102)
Message-ID: <20111018192019.4485315f@darkstar>
In-Reply-To: <CAGoCfiwLgGREEO5nRKZ4n=UD70aKTix+HZpjMvmfnADpEDgATg@mail.gmail.com>
References: <4E7F1FB5.5030803@gmail.com>
 <CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com>
 <4E7FF0A0.7060004@gmail.com>
 <CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com>
 <20110927094409.7a5fcd5a@stein>
 <20110927174307.GD24197@suse.de>
 <20110927213300.6893677a@stein>
 <4E999733.2010802@poczta.onet.pl>
 <4E99F2FC.5030200@poczta.onet.pl>
 <20111016105731.09d66f03@stein>
 <CAGoCfix9Yiju3-uyuPaV44dBg5i-LLdezz-fbo3v29i6ymRT7w@mail.gmail.com>
 <4E9ADFAE.8050208@redhat.com>
 <20111018111044.ebbc89a8.chmooreck@poczta.onet.pl>
 <CAGoCfiwLgGREEO5nRKZ4n=UD70aKTix+HZpjMvmfnADpEDgATg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 18 Oct 2011 11:52:17 -0400
Devin Heitmueller <dheitmueller@kernellabs.com> wrote:

> On Tue, Oct 18, 2011 at 5:10 AM, Piotr Chmura <chmooreck@poczta.onet.pl> wrote:
> > Thanks for comments for all of you.
> >
> > [PATCH 1-12/14] Following your guidelines i exported all changes from hg one by one. This way we will have all history in kernel tree.
> > I moved driver to staging/media and removed Kconfig/Makefile changes in parent directory in first patch.
> 
> Hello Piotr,
> 
> Not that I want to create more work for you, but it would appear that
> your patches stripped off all the Signed-off-by lines for both myself
> and Pierrick Hascoet (the developer from the hardware vendor).  You
> have replaced them with "cc:" lines, which breaks the chain of
> "Developer's Certificate of Origin".
> 
> When you take somebody else's patches, you need to preserve any
> existing Signed-off-by lines, adding your own at the bottom of the
> list.
> 
> In other words, the first patch should be:
> 
> Signed-off-by: Pierrick Hascoet <pierrick.hascoet@abilis.com>
> Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
> Signed-off-by: Piotr Chmura <chmooreck@poczta.onet.pl>
> 
> instead of:
> 
> Signed-off-by: Piotr Chmura <chmooreck@poczta.onet.pl>
> Cc: Pierrick Hascoet <pierrick.hascoet@abilis.com>
> Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
> 
> Devin
> 
> -- 
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Ok, i'll resend them again. 

Should I replay to every patch with something like [RESEND PATCH nn/mm]..., right ?

Peter
