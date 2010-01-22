Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.211.176]:47252 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522Ab0AVVz3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2010 16:55:29 -0500
Received: by ywh6 with SMTP id 6so1395344ywh.4
        for <linux-media@vger.kernel.org>; Fri, 22 Jan 2010 13:55:28 -0800 (PST)
Message-ID: <4B5A1ECC.4000808@gmail.com>
Date: Fri, 22 Jan 2010 19:55:24 -0200
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: First -git merges
References: <4B5A1D1E.2000701@redhat.com>
In-Reply-To: <4B5A1D1E.2000701@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> As already announced, the patches are now being committed first on
> -git tree and then backported to -hg.
> 
> In order to allow people to follow the patches that are being added
> at -git, I added a git hook that will send announcement emails when
> a patch is committed at:
> 	http://linuxtv.org/git/v4l-dvb.git
> 
> Unfortunately, the first 3 or 4 git commits got lost while the hooks
> were being adjusted. Yet, as the first commits were small, it is easy
> to see the commit history at the gitweb interface.
> 
> The backport to -hg will be done by Douglas.

Ah, I forgot to mention: if you're interested on seeing the commits, you
need to subscribe linuxtv-commits@linuxtv.org. In addition to the -hg
commits that were available there since the beginning of the -hg trees, you'll
be receiving also the -git commits. The -git commits are short: one message
per git push. The message will contain a summary of all patches added by
the git push.

I'll probably tweak the hook to produce a more customized message when I have
some time.

> 
> Cheers,
> Mauro.
> 
> -------- Mensagem original --------
> Assunto: [linuxtv-commits] [git:v4l-dvb] The merge of all V4L/DVB trees	ready to upstream and linux-next branch, master,	updated. v2.6.33-rc4-647-ga533f16
> Data: Fri, 22 Jan 2010 22:32:26 +0100
> De: Mauro Carvalho Chehab <linuxtv-commits-bounces@linuxtv.org>
> Para: linuxtv-commits@linuxtv.org
> 

