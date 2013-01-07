Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:54723 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab3AGKxf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2013 05:53:35 -0500
Received: by mail-bk0-f41.google.com with SMTP id jg9so8339061bkc.28
        for <linux-media@vger.kernel.org>; Mon, 07 Jan 2013 02:53:34 -0800 (PST)
Message-ID: <50EAA778.6000307@gmail.com>
Date: Mon, 07 Jan 2013 11:46:16 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Oliver Schinagl <oliver+list@schinagl.nl>
CC: linux-media <linux-media@vger.kernel.org>, pfister@linuxtv.org,
	adq_dvb@lidskialf.net, js@linuxtv.org, cus@fazekas.hu,
	mws@linuxtv.org, jmccrohan@gmail.com, shaulkr@gmail.com,
	mkrufky@linuxtv.org, mchehab@redhat.com, lubomir.carik@gmail.com,
	Christoph Pfister <christophpfister@gmail.com>
Subject: Re: [RFC] Initial scan files troubles and brainstorming
References: <507FE752.6010409@schinagl.nl> <50D0E7A7.90002@schinagl.nl>
In-Reply-To: <50D0E7A7.90002@schinagl.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/18/2012 11:01 PM, Oliver Schinagl wrote:
> Unfortunatly, I have had zero replies.

Hmm, it's sad there is a silence in this thread from linux-media guys :/.

> So why bring it up again? On 2012/11/30 Jakub Kasprzycki provided us
> with updated polish DVB-T frequencies for his region. This has yet to be
> merged, almost 3 weeks later.

I sent a patch for cz data too:
https://patchwork.kernel.org/patch/1844201/

> I'll quickly repeat why I think this approach would be quite reasonable.
> 
> * dvb-apps binary changes don't result in unnecessary releases
> * frequency updates don't result in unnecessary dvb-app releases
> * Less strict requirements for commits (code reviews etc)

Well the code should be reviewed still. See commit a2e96055db297 in your
repo, it's bogus. The freq added is in kHz instead of MHz.

> * Possibly easier entry for new submitters
> * much easier to package (tag it once per month if an update was)
> * Separate maintainer possible
> * just seems more logical to have it separated ;)

The downside is you have to change the URL in kaffeine sources as
kaffeine generates its scan file from that repo (on the server side and
the client downloads then http://kaffeine.kde.org/scanfile.dvb.qz).

> This obviously should find a nice home on linuxtv where it belongs!

At best.

> Here is my personal repository with the work I mentioned done.
> git://git.schinagl.nl/dvb_frequency_scanfiles.git
> 
> If an issue is that none of the original maintainers are not looking
> forward to do the job, I am willing to take maintenance on me for now.

Ping? Anybody? I would help with that too as I hate resending patches.
But the first step I would do is a conversion to GIT. HG is demented to
begin with.

-- 
js
